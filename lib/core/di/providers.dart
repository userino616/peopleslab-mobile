import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/core/logging/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grpc/grpc_connection_interface.dart' show ClientChannelBase;
import 'package:grpc/grpc.dart' show ClientInterceptor;
import 'package:peopleslab/core/auth/token_storage.dart';
import 'package:peopleslab/core/grpc/auth_interceptor.dart';
import 'package:peopleslab/core/grpc/logging_interceptor.dart';
import 'package:peopleslab/core/auth/auth_manager.dart';
import 'package:peopleslab/core/grpc/grpc_channel.dart';
import 'package:peopleslab/features/auth/data/grpc_auth_repository.dart';
import 'package:peopleslab/features/auth/domain/auth_repository.dart';
import 'package:peopleslab/features/auth/presentation/controllers/auth_controller.dart';
import 'package:peopleslab_api/auth/v1/service.pbgrpc.dart' as authpb;

// gRPC channel provider
final grpcChannelProvider = Provider<ClientChannelBase>((ref) {
  final channel = GrpcClientFactory.createChannel();

  appLogger.i(
    'gRPC channel created: ${channel.runtimeType}#${identityHashCode(channel)}',
  );

  ref.onDispose(() async {
    await GrpcClientFactory.shutdownChannel(channel);
    appLogger.i(
      'gRPC channel shutdown: ${channel.runtimeType}#${identityHashCode(channel)}',
    );
  });

  return channel;
});

// Keep TokenStorage internal to this library
final _tokenStorageProvider = Provider<TokenStorage>(
  (ref) => TokenStorage(const FlutterSecureStorage()),
);

/// Reactive stream of token changes emitted by TokenStorage.
final tokensStreamProvider = StreamProvider<Tokens?>((ref) {
  final storage = ref.read(_tokenStorageProvider);
  return storage.tokensStream;
});

final authManagerProvider = Provider<AuthManager>((ref) {
  final storage = ref.read(_tokenStorageProvider);
  final manager = AuthManager(storage: storage);
  ref.onDispose(manager.dispose);
  return manager;
});

/// Central list of gRPC interceptors used by all clients
final grpcInterceptorsProvider = Provider<List<ClientInterceptor>>((ref) {
  final authManager = ref.read(authManagerProvider);
  return [LoggingInterceptor(), AuthInterceptor(authManager: authManager)];
});

/// Per-service client provider example: AuthServiceClient
final authServiceClientProvider = Provider<authpb.AuthServiceClient>((ref) {
  final channel = ref.watch(grpcChannelProvider);
  final interceptors = ref.watch(grpcInterceptorsProvider);
  return authpb.AuthServiceClient(channel, interceptors: interceptors);
});

/// Centralized gRPC reset function
final grpcResetterProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    appLogger.i('Resetting gRPC: invalidating channel');
    ref.invalidate(grpcChannelProvider);
  };
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.read(_tokenStorageProvider);

  final repo = GrpcAuthRepository(
    () => ref.read(authServiceClientProvider),
    getDeviceId: () => ref.read(_tokenStorageProvider).deviceId(),
  );

  // Wire AuthManager callbacks (refresh/logout/reset) to repository and DI
  final manager = ref.read(authManagerProvider);
  manager.configure(
    refresh: () async {
      final rt = manager.refreshToken;
      if (rt == null || rt.isEmpty) return null;
      return repo.refresh(refreshToken: rt);
    },
    networkLogout: (rt) => repo.signOut(refreshToken: rt),
    resetGrpc: ref.read(grpcResetterProvider),
  );
  return repo;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authControllerProvider);
  final tokensAsync = ref.watch(tokensStreamProvider);
  final hasRefresh = tokensAsync.maybeWhen(
    data: (tokens) => (tokens?.refreshToken ?? '').isNotEmpty,
    orElse: () => false,
  );
  return authState.user != null && hasRefresh;
});
