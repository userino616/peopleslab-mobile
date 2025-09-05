import 'package:grpc/grpc_connection_interface.dart' show ClientChannelBase;
import 'package:grpc/grpc_web.dart';
import 'package:peopleslab/core/config/app_config.dart';

ClientChannelBase createChannel() {
  final uri = Uri(
    scheme: AppConfig.grpcUseTls ? 'https' : 'http',
    host: AppConfig.grpcHost,
    port: AppConfig.grpcPort,
  );
  return GrpcWebClientChannel.xhr(uri);
}

Future<void> shutdownChannel(ClientChannelBase channel) async {
  // No-op for web channel; underlying XHR/WebSocket closes with page lifecycle
}
