import 'package:grpc/grpc.dart';
import 'package:peopleslab/core/logging/logger.dart';
import 'package:uuid/uuid.dart';

/// Adds `x-request-id` to outgoing requests and logs request lifecycle.
class LoggingInterceptor extends ClientInterceptor {
  static const requestIdHeader = 'x-request-id';

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    final requestId = const Uuid().v4();

    final withTracing = options.mergedWith(
      CallOptions(
        providers: [
          (md, _) async {
            md.putIfAbsent(requestIdHeader, () => requestId);
          },
        ],
      ),
    );

    appLogger.t('grpc|start id=$requestId path=${method.path}');

    final call = invoker(method, request, withTracing);

    // Log errors without altering the original Future chain
    call.catchError((Object e, StackTrace st) {
      if (e is GrpcError) {
        appLogger.w(
          'grpc|error code=${e.code} id=$requestId path=${method.path} message=${e.message}',
        );
      } else {
        appLogger.w(
          'grpc|error id=$requestId path=${method.path} type=${e.runtimeType}',
        );
      }
      // Propagate the original error with its stack trace and correct type.
      return Future<R>.error(e, st);
    });

    return call;
  }
}
