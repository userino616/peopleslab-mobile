import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_connection_interface.dart' show ClientChannelBase;
import 'package:grpc/grpc_web.dart';
import 'package:peopleslab/core/config/app_config.dart';

class GrpcClientFactory {
  static ClientChannelBase createChannel() {
    if (kIsWeb) {
      final uri = Uri(
        scheme: AppConfig.grpcUseTls ? 'https' : 'http',
        host: AppConfig.grpcHost,
        port: AppConfig.grpcPort,
      );
      return GrpcWebClientChannel.xhr(uri);
    }

    final options = ChannelOptions(
      credentials: AppConfig.grpcUseTls
          ? const ChannelCredentials.secure()
          : const ChannelCredentials.insecure(),
    );

    return ClientChannel(
      AppConfig.grpcHost,
      port: AppConfig.grpcPort,
      options: options,
    );
  }
}
