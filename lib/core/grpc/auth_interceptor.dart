import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:peopleslab/core/auth/token_storage.dart';

class AuthInterceptor extends ClientInterceptor {
  static const _kSkipKey = 'x-skip-auth-interceptor';

  final ClientChannel channel;
  final TokenStorage storage;

  AuthInterceptor({required this.channel, required this.storage});

  // Authorization is injected via a metadata provider in interceptors.

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    // Skip if explicitly told to
    final skip = options.metadata.containsKey(_kSkipKey);

    // Add authorization via a metadata provider (awaited by gRPC before send)
    FutureOr<void> provider(Map<String, String> md, String uri) async {
      if (skip) return;
      final access = await storage.readAccessToken();
      if (access != null && access.isNotEmpty && !md.containsKey('authorization')) {
        md['authorization'] = 'Bearer $access';
      }
    }

    final newOptions = options.mergedWith(CallOptions(providers: [provider]));
    return invoker(method, request, newOptions);
  }

}
