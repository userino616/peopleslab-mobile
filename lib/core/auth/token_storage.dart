import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Tokens {
  final String? accessToken;
  final String? refreshToken;
  final int? accessExpiryMillis;
  final int? refreshExpiryMillis;

  const Tokens({
    this.accessToken,
    this.refreshToken,
    this.accessExpiryMillis,
    this.refreshExpiryMillis,
  });
}

/// Public backend interface to support testing/custom storage backends.
abstract class TokenStoreBackend {
  Future<String?> read({required String key});

  Future<void> write({required String key, required String? value});

  Future<void> delete({required String key});
}

class _FSSStore implements TokenStoreBackend {
  final FlutterSecureStorage _inner;

  const _FSSStore(this._inner);

  @override
  Future<void> delete({required String key}) => _inner.delete(key: key);

  @override
  Future<String?> read({required String key}) => _inner.read(key: key);

  @override
  Future<void> write({required String key, required String? value}) =>
      _inner.write(key: key, value: value);
}

class TokenStorage {
  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';
  static const _kAccessExp = 'access_exp'; // epoch millis
  static const _kRefreshExp = 'refresh_exp'; // epoch millis

  final TokenStoreBackend _store;

  TokenStorage(FlutterSecureStorage storage) : _store = _FSSStore(storage);

  TokenStorage.withStore(this._store);

  // In-memory cache to minimize IO
  Tokens? _cache;

  // Reactive updates: broadcast token changes on writes/clear
  final StreamController<Tokens?> _tokensController =
      StreamController<Tokens?>.broadcast();

  // Emits the current cached tokens first, then subsequent updates.
  Stream<Tokens?> get tokensStream async* {
    await _ensureCacheLoaded();
    yield _cache;
    yield* _tokensController.stream;
  }

  Future<void> _setOrDelete(String key, String? value) async {
    if (value == null || value.isEmpty) {
      await _store.delete(key: key);
    } else {
      await _store.write(key: key, value: value);
    }
  }

  Future<Tokens?> _loadFromStorage() async {
    final access = await _store.read(key: _kAccess);
    final refresh = await _store.read(key: _kRefresh);
    final aexpStr = await _store.read(key: _kAccessExp);
    final rexpStr = await _store.read(key: _kRefreshExp);
    final aexp = aexpStr == null || aexpStr.isEmpty
        ? null
        : int.tryParse(aexpStr);
    final rexp = rexpStr == null || rexpStr.isEmpty
        ? null
        : int.tryParse(rexpStr);
    final t = Tokens(
      accessToken: access,
      refreshToken: refresh,
      accessExpiryMillis: aexp,
      refreshExpiryMillis: rexp,
    );
    _cache = t;
    return t;
  }

  Future<void> _ensureCacheLoaded() async {
    if (_cache != null) return;
    await _loadFromStorage();
  }

  // ----- Public API (cached) -----

  Future<Tokens?> getTokens() async {
    await _ensureCacheLoaded();
    return _cache;
  }

  Future<void> writeTokens({
    required String accessToken,
    required String refreshToken,
    int? accessExpiresIn,
    int? refreshExpiresIn,
  }) async {
    await _ensureCacheLoaded();
    final now = DateTime.now().millisecondsSinceEpoch;
    final accessExpMs = accessExpiresIn == null
        ? null
        : now + accessExpiresIn * 1000; // from seconds to millis
    final refreshExpMs = refreshExpiresIn == null
        ? _cache?.refreshExpiryMillis
        : now + refreshExpiresIn * 1000; // from seconds to millis

    await _store.write(key: _kAccess, value: accessToken);
    await _store.write(key: _kRefresh, value: refreshToken);
    await _setOrDelete(_kAccessExp, accessExpMs?.toString());
    await _setOrDelete(_kRefreshExp, refreshExpMs?.toString());

    _cache = Tokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      accessExpiryMillis: accessExpMs,
      refreshExpiryMillis: refreshExpMs,
    );
    _tokensController.add(_cache);
  }

  Future<void> clearTokens() async {
    await _setOrDelete(_kAccess, null);
    await _setOrDelete(_kRefresh, null);
    await _setOrDelete(_kAccessExp, null);
    await _setOrDelete(_kRefreshExp, null);
    _cache = const Tokens();
    _tokensController.add(_cache);
  }
}
