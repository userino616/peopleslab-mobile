import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:peopleslab/features/auth/data/auth_repository.dart';

/// Public backend interface to support testing/custom storage backends.
abstract class UserStoreBackend {
  Future<String?> read({required String key});
  Future<void> write({required String key, required String? value});
  Future<void> delete({required String key});
}

class _FSSUserStore implements UserStoreBackend {
  final FlutterSecureStorage _inner;
  const _FSSUserStore(this._inner);

  @override
  Future<void> delete({required String key}) => _inner.delete(key: key);

  @override
  Future<String?> read({required String key}) => _inner.read(key: key);

  @override
  Future<void> write({required String key, required String? value}) =>
      _inner.write(key: key, value: value);
}

/// Stores minimal user profile persistently and caches it in memory.
class UserStorage {
  static const _kUserId = 'user_id';
  static const _kUserEmail = 'user_email';

  final UserStoreBackend _store;

  UserStorage(FlutterSecureStorage storage) : _store = _FSSUserStore(storage);
  UserStorage.withStore(this._store);

  AuthUser? _cache;

  final StreamController<AuthUser?> _userController =
      StreamController<AuthUser?>.broadcast();

  Stream<AuthUser?> get userStream => _userController.stream;

  Future<void> _ensureLoaded() async {
    if (_cache != null) return;
    final id = await _store.read(key: _kUserId);
    final email = await _store.read(key: _kUserEmail);
    if ((id ?? '').isNotEmpty && (email ?? '').isNotEmpty) {
      _cache = AuthUser(id: id!, email: email!);
    } else {
      _cache = null;
    }
  }

  Future<AuthUser?> getUser() async {
    await _ensureLoaded();
    return _cache;
  }

  Future<void> writeUser(AuthUser user) async {
    await _store.write(key: _kUserId, value: user.id);
    await _store.write(key: _kUserEmail, value: user.email);
    _cache = user;
    _userController.add(_cache);
  }

  Future<void> clearUser() async {
    await _store.delete(key: _kUserId);
    await _store.delete(key: _kUserEmail);
    _cache = null;
    _userController.add(_cache);
  }
}
