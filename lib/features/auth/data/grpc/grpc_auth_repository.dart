import 'package:grpc/grpc.dart';
import 'package:peopleslab_api/auth/v1/service.pbgrpc.dart' as authpb;
import 'package:peopleslab/core/grpc/auth_interceptor.dart';
import 'package:peopleslab/features/auth/data/auth_repository.dart';

class GrpcAuthRepository implements AuthRepository {
  final authpb.AuthServiceClient _client;

  GrpcAuthRepository(this._client);

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final resp = await _client.emailSignIn(
      authpb.EmailSignInRequest(
        email: email,
        password: password,
        // device info is optional; omitted for simplicity
      ),
      options: CallOptions(metadata: {AuthInterceptor.kSkipKey: 'true'}),
    );
    final user = resp.user;
    return AuthSession(
      user: AuthUser(id: user.id, email: user.email),
      tokens: AuthTokens(
        accessToken: resp.accessToken,
        refreshToken: resp.refreshToken,
        expiresIn: resp.expiresIn == 0 ? null : resp.expiresIn,
        refreshExpiresIn: resp.refreshExpiresIn == 0
            ? null
            : resp.refreshExpiresIn,
      ),
    );
  }

  @override
  Future<AuthSession> signUp({
    required String email,
    required String password,
  }) async {
    final resp = await _client.emailSignUp(
      authpb.EmailSignUpRequest(
        email: email,
        password: password,
        // device info is optional; omitted for simplicity
      ),
      options: CallOptions(metadata: {AuthInterceptor.kSkipKey: 'true'}),
    );
    final user = resp.user;
    return AuthSession(
      user: AuthUser(id: user.id, email: user.email),
      tokens: AuthTokens(
        accessToken: resp.accessToken,
        refreshToken: resp.refreshToken,
        expiresIn: resp.expiresIn == 0 ? null : resp.expiresIn,
        refreshExpiresIn: resp.refreshExpiresIn == 0
            ? null
            : resp.refreshExpiresIn,
      ),
    );
  }

  @override
  Future<void> signOut({required String refreshToken}) async {
    try {
      await _client.logout(
        authpb.LogoutRequest(refreshToken: refreshToken),
        options: CallOptions(metadata: {AuthInterceptor.kSkipKey: 'true'}),
      );
    } catch (_) {
      /* best effort */
    }
  }

  @override
  Future<AuthSession> signInWithGoogle({required String idToken}) async {
    final resp = await _client.socialSignIn(
      authpb.SocialSignInRequest(
        provider: authpb.Provider.PROVIDER_GOOGLE,
        idToken: idToken,
      ),
      options: CallOptions(metadata: {AuthInterceptor.kSkipKey: 'true'}),
    );
    final user = resp.user;
    return AuthSession(
      user: AuthUser(id: user.id, email: user.email),
      tokens: AuthTokens(
        accessToken: resp.accessToken,
        refreshToken: resp.refreshToken,
        expiresIn: resp.expiresIn == 0 ? null : resp.expiresIn,
        refreshExpiresIn: resp.refreshExpiresIn == 0
            ? null
            : resp.refreshExpiresIn,
      ),
    );
  }

  @override
  Future<AuthSession> signInWithApple({required String idToken}) async {
    final resp = await _client.socialSignIn(
      authpb.SocialSignInRequest(
        provider: authpb.Provider.PROVIDER_APPLE,
        idToken: idToken,
      ),
      options: CallOptions(metadata: {AuthInterceptor.kSkipKey: 'true'}),
    );
    final user = resp.user;
    return AuthSession(
      user: AuthUser(id: user.id, email: user.email),
      tokens: AuthTokens(
        accessToken: resp.accessToken,
        refreshToken: resp.refreshToken,
        expiresIn: resp.expiresIn == 0 ? null : resp.expiresIn,
        refreshExpiresIn: resp.refreshExpiresIn == 0
            ? null
            : resp.refreshExpiresIn,
      ),
    );
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await _client.forgotPassword(
      authpb.ForgotPasswordRequest(email: email),
      options: CallOptions(metadata: {AuthInterceptor.kSkipKey: 'true'}),
    );
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await _client.resetPassword(
      authpb.ResetPasswordRequest(
        email: email,
        code: code,
        newPassword: newPassword,
      ),
      options: CallOptions(metadata: {AuthInterceptor.kSkipKey: 'true'}),
    );
  }

  @override
  Future<AuthTokens?> refresh({required String refreshToken}) async {
    final resp = await _client.refresh(
      authpb.RefreshRequest(refreshToken: refreshToken),
      options: CallOptions(metadata: {AuthInterceptor.kSkipKey: 'true'}),
    );
    if (resp.accessToken.isEmpty || resp.refreshToken.isEmpty) return null;
    return AuthTokens(
      accessToken: resp.accessToken,
      refreshToken: resp.refreshToken,
      expiresIn: resp.expiresIn == 0 ? null : resp.expiresIn,
      refreshExpiresIn: null,
    );
  }
}
