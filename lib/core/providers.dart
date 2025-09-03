import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grpc/grpc_connection_interface.dart' show ClientChannelBase;
import 'package:peopleslab/core/auth/token_storage.dart';
import 'package:peopleslab/core/grpc/auth_interceptor.dart';
import 'package:peopleslab/core/grpc/grpc_channel.dart';
import 'package:peopleslab/features/auth/data/grpc_auth_repository.dart';
import 'package:peopleslab/features/auth/domain/auth_repository.dart';

// gRPC channel provider
final grpcChannelProvider = Provider<ClientChannelBase>((ref) => GrpcClientFactory.createChannel());

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) => const FlutterSecureStorage());

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage(ref.read(flutterSecureStorageProvider)));

final authInterceptorProvider = Provider<AuthInterceptor>((ref) {
  return AuthInterceptor(channel: ref.read(grpcChannelProvider), storage: ref.read(tokenStorageProvider));
});

// Auth repository provider (switchable between Fake and gRPC)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final channel = ref.read(grpcChannelProvider);
  final storage = ref.read(tokenStorageProvider);
  final interceptor = ref.read(authInterceptorProvider);
  return GrpcAuthRepository(channel, storage, interceptor);
});
