import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopleslab/core/providers.dart';
import 'package:peopleslab/features/auth/domain/auth_repository.dart';

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
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return AuthController(repo);
});

