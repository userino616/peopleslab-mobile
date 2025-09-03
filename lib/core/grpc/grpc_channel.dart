import 'package:grpc/grpc_connection_interface.dart' show ClientChannelBase;

// Use platform-specific implementations to avoid importing web-only APIs
// on non-web targets.
import 'grpc_channel_io.dart' if (dart.library.html) 'grpc_channel_web.dart'
    as impl;

class GrpcClientFactory {
  static ClientChannelBase createChannel() => impl.createChannel();
}
