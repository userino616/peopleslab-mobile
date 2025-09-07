import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/core/di/providers.dart';
import 'package:peopleslab/features/auth/data/auth_repository.dart';
import 'package:peopleslab/core/auth/token_storage.dart';
import 'package:peopleslab/core/auth/user_storage.dart';
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
  final TokenStorage _storage;
  final UserStorage _userStorage;
  AuthController(this._repo, this._storage, this._userStorage)
    : super(const AuthState());

  /// Loads current user from persistent storage (no network GetMe)
  Future<void> loadCurrentUser() async {
    final me = await _userStorage.getUser();
    if (me != null) {
      state = state.copyWith(user: me);
    }
  }

  Future<bool> signIn(String email, String password) async {
    state = state.copyWith(loading: true, errorMessage: null);
    try {
      final session = await _repo.signIn(email: email, password: password);
      await _storage.writeTokens(
        accessToken: session.tokens.accessToken,
        refreshToken: session.tokens.refreshToken,
        accessExpiresIn: session.tokens.expiresIn,
        refreshExpiresIn: session.tokens.refreshExpiresIn,
      );
      await _userStorage.writeUser(session.user);
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
      await _storage.writeTokens(
        accessToken: session.tokens.accessToken,
        refreshToken: session.tokens.refreshToken,
        accessExpiresIn: session.tokens.expiresIn,
        refreshExpiresIn: session.tokens.refreshExpiresIn,
      );
      await _userStorage.writeUser(session.user);
      state = state.copyWith(loading: false, user: session.user);
      return true;
    } catch (e) {
      state = state.copyWith(loading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> signOut() async {
    final rt = (await _storage.getTokens())?.refreshToken;
    if (rt != null && rt.isNotEmpty) {
      try {
        await _repo.signOut(refreshToken: rt);
      } catch (_) {
        /* ignore */
      }
    }
    await _storage.clearTokens();
    await _userStorage.clearUser();
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
      await _storage.writeTokens(
        accessToken: session.tokens.accessToken,
        refreshToken: session.tokens.refreshToken,
        accessExpiresIn: session.tokens.expiresIn,
        refreshExpiresIn: session.tokens.refreshExpiresIn,
      );
      await _userStorage.writeUser(session.user);
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
      await _storage.writeTokens(
        accessToken: session.tokens.accessToken,
        refreshToken: session.tokens.refreshToken,
        accessExpiresIn: session.tokens.expiresIn,
        refreshExpiresIn: session.tokens.refreshExpiresIn,
      );
      await _userStorage.writeUser(session.user);
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
    final storage = ref.read(tokenStorageProvider);
    final users = ref.read(userStorageProvider);
    final c = AuthController(repo, storage, users);
    // On startup: attempt to load current user; interceptor handles 401/refresh
    Future.microtask(() async {
      await c.loadCurrentUser();
    });
    return c;
  },
);
