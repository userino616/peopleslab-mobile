class AuthUser {
  final String id;
  final String email;

  const AuthUser({required this.id, required this.email});
}

class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final int? expiresIn; // seconds until access token expiry
  final int? refreshExpiresIn; // seconds until refresh token expiry

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    this.expiresIn,
    this.refreshExpiresIn,
  });
}

class AuthSession {
  final AuthUser user;
  final AuthTokens tokens;
  const AuthSession({required this.user, required this.tokens});
}

abstract class AuthRepository {
  Future<AuthSession> signIn({required String email, required String password});
  Future<AuthSession> signUp({required String email, required String password});
  Future<void> signOut({required String refreshToken});
  Future<AuthTokens?> refresh({required String refreshToken});

  // Social sign-in
  Future<AuthSession> signInWithGoogle({required String idToken});
  Future<AuthSession> signInWithApple({required String idToken});

  // Password reset
  Future<void> forgotPassword({required String email});
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });
}
