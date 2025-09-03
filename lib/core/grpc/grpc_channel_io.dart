import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_connection_interface.dart' show ClientChannelBase;
import 'package:peopleslab/core/config/app_config.dart';

ClientChannelBase createChannel() {
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

