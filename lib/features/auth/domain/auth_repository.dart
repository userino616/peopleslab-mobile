class AuthUser {
  final String id;
  final String email;

  const AuthUser({required this.id, required this.email});
}

abstract class AuthRepository {
  Future<AuthUser> signIn({required String email, required String password});
  Future<AuthUser> signUp({required String email, required String password});
  Future<void> signOut();
  // Refresh access token using refresh token. Returns true on success.
  Future<bool> refresh();

  // Load current user profile using existing session; returns null if unauthenticated.
  Future<AuthUser?> getMe();

  // Social sign-in
  Future<AuthUser> signInWithGoogle({required String idToken});
  Future<AuthUser> signInWithApple({required String idToken});

  // Password reset
  Future<void> forgotPassword({required String email});
  Future<void> resetPassword({required String email, required String code, required String newPassword});
}
