import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:peopleslab/core/auth/token_storage.dart';
import 'package:peopleslab/core/auth/user_storage.dart';

class AuthInterceptor extends ClientInterceptor {
  // Public so callers can share the same key
  static const kSkipKey = 'x-skip-auth';
  final TokenStorage storage;
  final Future<bool> Function(String refreshToken) refresh;
  final UserStorage? userStorage;

  AuthInterceptor({
    required this.storage,
    required this.refresh,
    this.userStorage,
  });

  bool _shouldSkip(CallOptions options) =>
      options.metadata.containsKey(kSkipKey);

  Future<void> _attachAuthIfNeeded(Map<String, String> md, bool skip) async {
    if (skip) return;
    final access = (await storage.getTokens())?.accessToken;
    if (access != null &&
        access.isNotEmpty &&
        !md.containsKey('authorization')) {
      md['authorization'] = 'Bearer $access';
    }
  }

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    final skip = _shouldSkip(options);

    CallOptions withHeaders() {
      return options.mergedWith(
        CallOptions(
          providers: [
            (md, _) async {
              // Clean internal headers
              md.remove(kSkipKey);
              // Attach auth header (if any)
              await _attachAuthIfNeeded(md, skip);
            },
          ],
        ),
      );
    }

    final call = invoker(method, request, withHeaders());
    call.catchError((Object e, StackTrace st) async {
      if (e is GrpcError && e.code == StatusCode.unauthenticated && !skip) {
        // Fire refresh on 401; no retry here, keep it simple
        final rt = (await storage.getTokens())?.refreshToken;
        if (rt != null && rt.isNotEmpty) {
          try {
            await refresh(rt);
            // We intentionally do not retry the original call here.
            // Regardless of refresh success, propagate the original error.
          } catch (_) {
            // fallthrough to cleanup
          }
        }
        await storage.clearTokens();
        // Keep user state consistent on forced logout
        await userStorage?.clearUser();
      }
      // Always propagate the original error with its stack trace.
      return Future<R>.error(e, st);
    });
    return call;
  }
}
