import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_connection_interface.dart' show ClientChannelBase;
import 'package:peopleslab/core/auth/token_storage.dart';

class AuthInterceptor extends ClientInterceptor {
  // Public so callers can share the same key
  static const kSkipKey = 'x-skip-auth';

  final ClientChannelBase channel;
  final TokenStorage storage;

  AuthInterceptor({required this.channel, required this.storage});

  // External hooks supplied by repository
  Future<bool> Function()? _refresh;
  Future<void> Function()? _onAuthFailure;

  // Mutex for refresh serialization
  Completer<void>? _refreshing;
  bool _lastRefreshSucceeded = false;

  void configure({required Future<bool> Function() refresh, required Future<void> Function() onAuthFailure}) {
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
    // If no handler is configured, nothing we can do
    final refresh = _refresh;
    if (refresh == null) return false;

    if (_refreshing != null) {
      await _refreshing!.future;
      return _lastRefreshSucceeded;
    }

    _refreshing = Completer<void>();
    try {
      final ok = await refresh();
      _lastRefreshSucceeded = ok;
      return ok;
    } catch (_) {
      _lastRefreshSucceeded = false;
      rethrow;
    } finally {
      _refreshing?.complete();
      _refreshing = null;
    }
  }

  Future<void> _handleAuthFailure() async {
    final onFail = _onAuthFailure;
    if (onFail != null) {
      await onFail();
    }
  }

  // Unary with pre-send refresh (mutex) and token injection
  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    final skip = _shouldSkip(options);

    FutureOr<void> provider(Map<String, String> md, String uri) async {
      // Never send local-only control header to the server
      md.remove(kSkipKey);
      if (skip) return;
      // Check if we need to refresh before sending the request
      final now = DateTime.now().millisecondsSinceEpoch;
      final exp = await storage.readAccessExpiryMillis();
      final access = await storage.readAccessToken();
      // 5s skew window
      final needsRefresh =
          (access == null || access.isEmpty) || (exp != null && exp <= now + 5000);

      if (needsRefresh) {
        bool ok = false;
        try {
          ok = await _refreshGuarded();
        } catch (_) {
          ok = false;
        }
        if (!ok) {
          await _handleAuthFailure();
          throw GrpcError.unauthenticated('Unable to refresh token');
        }
      }

      await _attachAuthIfNeeded(md, false);
    }

    final newOptions = options.mergedWith(CallOptions(providers: [provider]));
    return invoker(method, request, newOptions);
  }
}
