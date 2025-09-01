import 'package:grpc/grpc.dart';
import 'package:peopleslab/core/config/app_config.dart';

class GrpcClientFactory {
  static ClientChannel createChannel() {
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

