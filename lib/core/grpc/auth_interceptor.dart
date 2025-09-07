import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:peopleslab/core/auth/auth_manager.dart';
import 'package:peopleslab/core/logging/logger.dart';

class AuthInterceptor extends ClientInterceptor {
  // Public so callers can share the same key
  static const kSkipKey = 'x-skip-auth';
  final AuthManager authManager;

  AuthInterceptor({required this.authManager});

  bool _shouldSkip(CallOptions options) =>
      options.metadata.containsKey(kSkipKey);

  void _attachAuthIfNeeded(Map<String, String> md, bool skip) {
    if (skip) return;
    final access = authManager.accessToken;
    if (access != null &&
        access.isNotEmpty &&
        !md.containsKey('authorization')) {
      md['authorization'] = 'Bearer $access';
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

    CallOptions withHeaders() {
      return options.mergedWith(
        CallOptions(
          providers: [
            (md, _) async {
              // Clean internal headers
              md.remove(kSkipKey);
              // Attach auth header (if any)
              _attachAuthIfNeeded(md, skip);
            },
          ],
        ),
      );
    }

    final call = invoker(method, request, withHeaders());

    // On 401: signal AuthManager (no retry here).
    call.catchError((Object e, StackTrace st) {
      if (e is GrpcError && e.code == StatusCode.unauthenticated && !skip) {
        appLogger.w('auth_interceptor|401 path=${method.path}');
        // Fire-and-forget
        Future.microtask(() => authManager.handleUnauthorized());
      }
      throw e;
    });

    return call;
  }
}
