import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/core/di/providers.dart';
import 'package:peopleslab/features/auth/domain/auth_repository.dart';
import 'package:peopleslab/core/auth/auth_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthState {
  final bool loading;
  final String? errorMessage;
  final AuthUser? user;
  const AuthState({this.loading = false, this.errorMessage, this.user});

  AuthState copyWith({bool? loading, String? errorMessage, AuthUser? user}) {
    return AuthState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
      user: user,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  final AuthManager _auth;
  AuthController(this._repo, this._auth) : super(const AuthState());

  /// Tries to load current user using existing session
  Future<void> loadCurrentUser() async {
    try {
      final me = await _repo.getMe();
      if (me != null) {
        state = state.copyWith(user: me);
      }
    } catch (_) {
      // Unauthenticated or transient errors are handled by interceptor; ignore here
    }
  }

  Future<bool> signIn(String email, String password) async {
    state = state.copyWith(loading: true, errorMessage: null);
    try {
      final session = await _repo.signIn(email: email, password: password);
      await _auth.applySessionTokens(session.tokens);
      state = state.copyWith(loading: false, user: session.user);
      return true;
    } catch (e) {
      state = state.copyWith(loading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    state = state.copyWith(loading: true, errorMessage: null);
    try {
      final session = await _repo.signUp(email: email, password: password);
      await _auth.applySessionTokens(session.tokens);
      state = state.copyWith(loading: false, user: session.user);
      return true;
    } catch (e) {
      state = state.copyWith(loading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    state = const AuthState();
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(loading: true, errorMessage: null);
    try {
      final google = GoogleSignIn.instance;
      await google.initialize();
      final acc = await google.authenticate(scopeHint: const ['email']);
      final idToken = acc.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        state = state.copyWith(
          loading: false,
          errorMessage: 'auth.google_id_missing',
        );
        return false;
      }
      final session = await _repo.signInWithGoogle(idToken: idToken);
      await _auth.applySessionTokens(session.tokens);
      state = state.copyWith(loading: false, user: session.user);
      return true;
    } on GoogleSignInException catch (e) {
      // Treat user-cancel as non-error UI state
      if (e.code == GoogleSignInExceptionCode.canceled) {
        state = state.copyWith(loading: false);
        return false;
      }
      state = state.copyWith(loading: false, errorMessage: e.toString());
      return false;
    } catch (e) {
      state = state.copyWith(loading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    // Only meaningful on iOS/macOS
    if (defaultTargetPlatform != TargetPlatform.iOS &&
        defaultTargetPlatform != TargetPlatform.macOS) {
      state = state.copyWith(errorMessage: 'auth.apple_unsupported');
      return false;
    }
    state = state.copyWith(loading: true, errorMessage: null);
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final idToken = credential.identityToken;
      if (idToken == null || idToken.isEmpty) {
        state = state.copyWith(
          loading: false,
          errorMessage: 'auth.apple_id_missing',
        );
        return false;
      }
      final session = await _repo.signInWithApple(idToken: idToken);
      await _auth.applySessionTokens(session.tokens);
      state = state.copyWith(loading: false, user: session.user);
      return true;
    } catch (e) {
      state = state.copyWith(loading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    state = state.copyWith(loading: true, errorMessage: null);
    try {
      await _repo.forgotPassword(email: email);
      state = state.copyWith(loading: false);
      return true;
    } catch (e) {
      state = state.copyWith(loading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    state = state.copyWith(loading: true, errorMessage: null);
    try {
      await _repo.resetPassword(
        email: email,
        code: code,
        newPassword: newPassword,
      );
      state = state.copyWith(loading: false);
      return true;
    } catch (e) {
      state = state.copyWith(loading: false, errorMessage: e.toString());
      return false;
    }
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final repo = ref.read(authRepositoryProvider);
    final auth = ref.read(authManagerProvider);
    final c = AuthController(repo, auth);
    // On startup: attempt to load current user; interceptor handles 401/refresh
    Future.microtask(() async {
      await c.loadCurrentUser();
    });
    return c;
  },
);
