import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/core/logging/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grpc/grpc_connection_interface.dart' show ClientChannelBase;
import 'package:grpc/grpc.dart' show ClientInterceptor;
import 'package:peopleslab/core/auth/token_storage.dart';
import 'package:peopleslab/core/auth/user_storage.dart';
import 'package:peopleslab/core/grpc/auth_interceptor.dart';
import 'package:peopleslab/core/grpc/logging_interceptor.dart';
import 'package:peopleslab/core/grpc/grpc_channel.dart';
import 'package:peopleslab/features/auth/data/grpc/grpc_auth_repository.dart';
import 'package:peopleslab/features/auth/data/auth_repository.dart';
import 'package:peopleslab_api/auth/v1/service.pbgrpc.dart' as authpb;
import 'package:grpc/grpc.dart' show CallOptions;

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

// Token storage provider
final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => TokenStorage(const FlutterSecureStorage()),
);

// User storage provider
final userStorageProvider = Provider<UserStorage>(
  (ref) => UserStorage(const FlutterSecureStorage()),
);

/// Reactive stream of token changes emitted by TokenStorage.
final tokensStreamProvider = StreamProvider<Tokens?>((ref) {
  final storage = ref.read(tokenStorageProvider);
  return storage.tokensStream;
});

/// True once the initial tokens snapshot has been loaded/emitted
final authHydratedProvider = Provider<bool>((ref) {
  final tokensAsync = ref.watch(tokensStreamProvider);
  return tokensAsync.when(
    data: (_) => true,
    loading: () => false,
    error: (_, _) => true, // proceed even if errored
  );
});

// No AuthManager provider

/// Central list of gRPC interceptors used by all clients
final grpcInterceptorsProvider = Provider<List<ClientInterceptor>>((ref) {
  final storage = ref.read(tokenStorageProvider);

  Future<bool> refresh(String rt) async {
    // todo move from here
    final client = authpb.AuthServiceClient(ref.read(grpcChannelProvider));
    final resp = await client.refresh(
      authpb.RefreshRequest(refreshToken: rt),
      options: CallOptions(metadata: {AuthInterceptor.kSkipKey: 'true'}),
    );
    if (resp.accessToken.isEmpty || resp.refreshToken.isEmpty) return false;
    await storage.writeTokens(
      accessToken: resp.accessToken,
      refreshToken: resp.refreshToken,
      accessExpiresIn: resp.expiresIn == 0 ? null : resp.expiresIn,
      refreshExpiresIn: null,
    );
    return true;
  }

  return [
    LoggingInterceptor(),
    AuthInterceptor(
      storage: storage,
      refresh: refresh,
      userStorage: ref.read(userStorageProvider),
    ),
  ];
});

/// Per-service client provider example: AuthServiceClient
final authServiceClientProvider = Provider<authpb.AuthServiceClient>((ref) {
  final channel = ref.watch(grpcChannelProvider);
  final interceptors = ref.watch(grpcInterceptorsProvider);
  return authpb.AuthServiceClient(channel, interceptors: interceptors);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return GrpcAuthRepository(ref.read(authServiceClientProvider));
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final tokensAsync = ref.watch(tokensStreamProvider);
  return tokensAsync.maybeWhen(
    data: (tokens) => (tokens?.refreshToken ?? '').isNotEmpty,
    orElse: () => false,
  );
});
