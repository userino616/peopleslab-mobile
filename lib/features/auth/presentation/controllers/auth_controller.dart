import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/core/providers.dart';
import 'package:peopleslab/features/auth/domain/auth_repository.dart';
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
  AuthController(this._repo) : super(const AuthState());

  Future<bool> signIn(String email, String password) async {
    state = state.copyWith(loading: true, errorMessage: null);
    try {
      final user = await _repo.signIn(email: email, password: password);
      state = state.copyWith(loading: false, user: user);
      return true;
    } catch (e) {
      state = state.copyWith(loading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    state = state.copyWith(loading: true, errorMessage: null);
    try {
      final user = await _repo.signUp(email: email, password: password);
      state = state.copyWith(loading: false, user: user);
      return true;
    } catch (e) {
      state = state.copyWith(loading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> signOut() async {
    await _repo.signOut();
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
        state = state.copyWith(loading: false, errorMessage: 'auth.google_id_missing');
        return false;
      }
      final user = await _repo.signInWithGoogle(idToken: idToken);
      state = state.copyWith(loading: false, user: user);
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
    if (kIsWeb || (defaultTargetPlatform != TargetPlatform.iOS && defaultTargetPlatform != TargetPlatform.macOS)) {
      state = state.copyWith(errorMessage: 'auth.apple_unsupported');
      return false;
    }
    state = state.copyWith(loading: true, errorMessage: null);
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );
      final idToken = credential.identityToken;
      if (idToken == null || idToken.isEmpty) {
        state = state.copyWith(loading: false, errorMessage: 'auth.apple_id_missing');
        return false;
      }
      final user = await _repo.signInWithApple(idToken: idToken);
      state = state.copyWith(loading: false, user: user);
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

  Future<bool> resetPassword({required String email, required String code, required String newPassword}) async {
    state = state.copyWith(loading: true, errorMessage: null);
    try {
      await _repo.resetPassword(email: email, code: code, newPassword: newPassword);
      state = state.copyWith(loading: false);
      return true;
    } catch (e) {
      state = state.copyWith(loading: false, errorMessage: e.toString());
      return false;
    }
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return AuthController(repo);
});
