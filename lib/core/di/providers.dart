import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/core/logging/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grpc/grpc_connection_interface.dart' show ClientChannelBase;
import 'package:peopleslab/core/auth/token_storage.dart';
import 'package:peopleslab/core/grpc/auth_interceptor.dart';
import 'package:peopleslab/core/grpc/grpc_channel.dart';
import 'package:peopleslab/features/auth/data/grpc_auth_repository.dart';
import 'package:peopleslab/features/auth/domain/auth_repository.dart';
import 'package:peopleslab/features/auth/presentation/controllers/auth_controller.dart';

// gRPC channel provider
final grpcChannelProvider = Provider<ClientChannelBase>((ref) {
  final channel = GrpcClientFactory.createChannel();
  appLogger.i('gRPC channel created: ${channel.runtimeType}#${identityHashCode(channel)}');
  ref.onDispose(() async {
    await GrpcClientFactory.shutdownChannel(channel);
    appLogger.i('gRPC channel shutdown: ${channel.runtimeType}#${identityHashCode(channel)}');
  });
  return channel;
});

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) => const FlutterSecureStorage());

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  // On web, flutter_secure_storage uses localStorage under the hood. We cap TTL optionally.
  final store = ref.read(flutterSecureStorageProvider);
  return TokenStorage(store, webTtlCap: kIsWeb ? const Duration(hours: 12) : null);
});

/// Reactive stream of token changes emitted by TokenStorage.
final tokensStreamProvider = StreamProvider<Tokens?>((ref) {
  final storage = ref.read(tokenStorageProvider);
  return storage.tokensStream;
});

final authInterceptorProvider = Provider<AuthInterceptor>((ref) {
  return AuthInterceptor(storage: ref.read(tokenStorageProvider));
});

// Auth repository provider (switchable between Fake and gRPC)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.read(tokenStorageProvider);

  ClientChannelBase getChannel() => ref.read(grpcChannelProvider);
  AuthInterceptor getInterceptor() => ref.read(authInterceptorProvider);

  Future<void> resetGrpc() async {
    appLogger.i('Resetting gRPC DI: invalidating channel & interceptor');
    // Invalidate interceptor first so future clients pick up the fresh instance
    ref.invalidate(authInterceptorProvider);
    // Disposing channel triggers onDispose -> shutdown
    ref.invalidate(grpcChannelProvider);
  }

  return GrpcAuthRepository(getChannel, storage, getInterceptor, onResetGrpc: resetGrpc);
});

/// Єдина «правда» про авторизацію: користувач є в стані + є refreshToken
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authControllerProvider);
  final tokensAsync = ref.watch(tokensStreamProvider);
  final hasRefresh = tokensAsync.maybeWhen(
    data: (toks) => (toks?.refreshToken ?? '').isNotEmpty,
    orElse: () => false,
  );
  return authState.user != null && hasRefresh;
});