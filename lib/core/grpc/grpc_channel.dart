import 'package:grpc/grpc_connection_interface.dart' show ClientChannelBase;
import 'grpc_channel_io.dart' as impl;

class GrpcClientFactory {
  static ClientChannelBase createChannel() => impl.createChannel();
  static Future<void> shutdownChannel(ClientChannelBase channel) => impl.shutdownChannel(channel);
}
