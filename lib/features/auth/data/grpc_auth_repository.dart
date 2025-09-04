import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_connection_interface.dart' show ClientChannelBase;
import 'package:peopleslab_api/auth/v1/service.pbgrpc.dart' as authpb;
import 'package:peopleslab/core/auth/token_storage.dart';
import 'package:peopleslab/core/grpc/auth_interceptor.dart';
import 'package:peopleslab/features/auth/domain/auth_repository.dart';

/// Placeholder implementation. Replace with real gRPC stubs after proto generation.
class GrpcAuthRepository implements AuthRepository {
  final ClientChannelBase channel;
  final TokenStorage storage;
  late final authpb.AuthServiceClient _client;

  GrpcAuthRepository(this.channel, this.storage, AuthInterceptor interceptor) {
    _client = authpb.AuthServiceClient(channel, interceptors: [interceptor]);
  }

  // todo enrich with propel user device data and probably move to conts
  Future<authpb.Device> _device() async => authpb.Device(
        deviceId: await storage.deviceId(),
        platform: 'flutter',
        userAgent: 'peopleslab-app',
      );

  @override
  Future<AuthUser> signIn({required String email, required String password}) async {
    final resp = await _client.emailSignIn(
      authpb.EmailSignInRequest(email: email, password: password, device: await _device()),
      options: CallOptions(timeout: const Duration(seconds: 10)),
    );
    await storage.writeTokens(accessToken: resp.accessToken, refreshToken: resp.refreshToken);
    final user = resp.user;
    return AuthUser(id: user.id, email: user.email);
  }

  @override
  Future<AuthUser> signUp({required String email, required String password}) async {
    final resp = await _client.emailSignUp(
      authpb.EmailSignUpRequest(email: email, password: password, device: await _device()),
      options: CallOptions(timeout: const Duration(seconds: 12)),
    );
    await storage.writeTokens(accessToken: resp.accessToken, refreshToken: resp.refreshToken);
    final user = resp.user;
    return AuthUser(id: user.id, email: user.email);
  }

  @override
  Future<void> signOut() async {
    final token = await storage.readRefreshToken();
    if (token == null || token.isEmpty) return;
    await _client.logout(
      authpb.LogoutRequest(refreshToken: token),
      options: CallOptions(timeout: const Duration(seconds: 5)),
    );
    await storage.clearTokens();
  }

  @override
  Future<AuthUser> signInWithGoogle({required String idToken}) async {
    final resp = await _client.socialSignIn(
      authpb.SocialSignInRequest(
        provider: authpb.Provider.PROVIDER_GOOGLE,
        idToken: idToken,
        device: await _device(),
      ),
      options: CallOptions(timeout: const Duration(seconds: 10), metadata: {_skipAuth: 'true'}),
    );
    await storage.writeTokens(accessToken: resp.accessToken, refreshToken: resp.refreshToken);
    final user = resp.user;
    return AuthUser(id: user.id, email: user.email);
  }

  @override
  Future<AuthUser> signInWithApple({required String idToken}) async {
    final resp = await _client.socialSignIn(
      authpb.SocialSignInRequest(
        provider: authpb.Provider.PROVIDER_APPLE,
        idToken: idToken,
        device: await _device(),
      ),
      options: CallOptions(timeout: const Duration(seconds: 10), metadata: {_skipAuth: 'true'}),
    );
    await storage.writeTokens(accessToken: resp.accessToken, refreshToken: resp.refreshToken);
    final user = resp.user;
    return AuthUser(id: user.id, email: user.email);
  }

  static const _skipAuth = 'x-skip-auth-interceptor';

  @override
  Future<void> forgotPassword({required String email}) async {
    await _client.forgotPassword(
      authpb.ForgotPasswordRequest(email: email),
      options: CallOptions(timeout: const Duration(seconds: 8), metadata: {_skipAuth: 'true'}),
    );
  }

  @override
  Future<void> resetPassword({required String email, required String code, required String newPassword}) async {
    await _client.resetPassword(
      authpb.ResetPasswordRequest(email: email, code: code, newPassword: newPassword),
      options: CallOptions(timeout: const Duration(seconds: 10), metadata: {_skipAuth: 'true'}),
    );
  }
}
