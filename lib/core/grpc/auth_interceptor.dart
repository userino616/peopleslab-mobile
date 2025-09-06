import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:peopleslab/core/auth/token_storage.dart';
import 'package:peopleslab/core/logging/logger.dart';
import 'package:uuid/uuid.dart';

class AuthInterceptor extends ClientInterceptor {
  // Public so callers can share the same key
  static const kSkipKey = 'x-skip-auth';
  final TokenStorage storage;

  AuthInterceptor({required this.storage});

  // External hooks supplied by repository
  Future<bool> Function()? _refresh;
  Future<void> Function()? _onAuthFailure;

  // Mutex for refresh serialization
  Completer<void>? _refreshing;
  bool _lastRefreshSucceeded = false;

  void configure({
    required Future<bool> Function() refresh,
    required Future<void> Function() onAuthFailure,
  }) {
    _refresh = refresh;
    _onAuthFailure = onAuthFailure;
  }

  bool _shouldSkip(CallOptions options) => options.metadata.containsKey(kSkipKey);

  FutureOr<void> _attachAuthIfNeeded(Map<String, String> md, bool skip) async {
    if (skip) return;
    final access = await storage.readAccessToken();
    if (access != null && access.isNotEmpty && !md.containsKey('authorization')) {
      md['authorization'] = 'Bearer $access';
    }
  }

  Future<bool> _refreshGuarded() async {
    final refresh = _refresh;
    if (refresh == null) return false;

    if (_refreshing != null) {
      await _refreshing!.future;
      return _lastRefreshSucceeded;
    }

    _refreshing = Completer<void>();
    try {
      appLogger.i('auth_interceptor|refresh:start');
      final ok = await refresh();
      _lastRefreshSucceeded = ok;
      appLogger.i('auth_interceptor|refresh:end ok=$ok');
      return ok;
    } catch (_) {
      _lastRefreshSucceeded = false;
      rethrow;
    } finally {
      _refreshing?.complete();
      _refreshing = null;
    }
  }

  void _handleAuthFailureAsync() {
    final onFail = _onAuthFailure;
    if (onFail != null) {
      Future.microtask(() async {
        try {
          await onFail();
        } catch (_) {}
      });
    }
  }

  // Unary with optional soft pre-refresh -> attach -> single call
  @override
  ResponseFuture<R> interceptUnary<Q, R>(
      ClientMethod<Q, R> method,
      Q request,
      CallOptions options,
      ClientUnaryInvoker<Q, R> invoker,
      ) {
    final skip = _shouldSkip(options);
    final requestId = const Uuid().v4();

    CallOptions withHeaders({required int attempt}) {
      return options.mergedWith(
        CallOptions(
          providers: [
                (md, _) async {
              // Clean internal headers
              md.remove(kSkipKey);
              // Tracing
              md['x-request-id'] = requestId;
              md['x-request-attempt'] = attempt.toString();

              // Soft pre-refresh: if token відсутній/прострочений — спробувати оновити
              if (!skip) {
                try {
                  final now = DateTime.now().millisecondsSinceEpoch;
                  final exp = await storage.readAccessExpiryMillis();
                  final access = await storage.readAccessToken();
                  final needsRefresh =
                      (access == null || access.isEmpty) || (exp != null && exp <= now + 5000);
                  if (needsRefresh) {
                    appLogger.i('auth_interceptor|pre_refresh:start id=$requestId path=${method.path}');
                    final ok = await _refreshGuarded();
                    appLogger.i('auth_interceptor|pre_refresh:end ok=$ok id=$requestId');
                  }
                } catch (e) {
                  appLogger.w('auth_interceptor|pre_refresh:error $e id=$requestId');
                }
              }

              // Attach auth header (if any)
              await _attachAuthIfNeeded(md, skip);
              appLogger.t('auth_interceptor|attach id=$requestId attempt=$attempt path=${method.path}');
            },
          ],
        ),
      );
    }

    final call = invoker(method, request, withHeaders(attempt: 1));

    // On 401: trigger async failure handler (logout/cleanup). No custom retry here.
    call.catchError((Object e, StackTrace st) {
      if (e is GrpcError && e.code == StatusCode.unauthenticated && !skip) {
        appLogger.w('auth_interceptor|401 id=$requestId attempt=1 path=${method.path}');
        _handleAuthFailureAsync();
      }
      throw e;
    });

    return call;
  }
}