import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:peopleslab/core/logging/logger.dart';

/// Simple DTO for tokens kept in memory cache
class Tokens {
  final String? accessToken;
  final String? refreshToken;
  final int? accessExpiryMillis; // epoch millis
  final int? refreshExpiryMillis; // epoch millis

  const Tokens({
    this.accessToken,
    this.refreshToken,
    this.accessExpiryMillis,
    this.refreshExpiryMillis,
  });

  Tokens copyWith({
    String? accessToken,
    String? refreshToken,
    int? accessExpiryMillis,
    int? refreshExpiryMillis,
  }) =>
      Tokens(
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
        accessExpiryMillis: accessExpiryMillis ?? this.accessExpiryMillis,
        refreshExpiryMillis: refreshExpiryMillis ?? this.refreshExpiryMillis,
      );
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
  Future<void> write({required String key, required String? value}) => _inner.write(key: key, value: value);
}

class TokenStorage {
  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';
  static const _kAccessExp = 'access_exp'; // epoch millis
  static const _kRefreshExp = 'refresh_exp'; // epoch millis
  static const _kDeviceId = 'device_id';

  final TokenStoreBackend _store;

  /// Optional cap for token TTL on web. If provided and running on web,
  /// the stored expiry will be min(server expiry, now + this cap).
  final Duration? webTtlCap;

  TokenStorage(FlutterSecureStorage storage, {this.webTtlCap}) : _store = _FSSStore(storage);
  TokenStorage.withStore(this._store, {this.webTtlCap});

  // In-memory cache to minimize IO
  Tokens? _cache;

  // Gate to dedupe initial load
  Future<Tokens?>? _loadFuture;

  // Simple async mutex to serialize writes (avoid races)
  Completer<void>? _writeLock;

  // Reactive updates: broadcast token changes on writes/clear
  final StreamController<Tokens?> _tokensController = StreamController<Tokens?>.broadcast();
  Stream<Tokens?> get tokensStream => _tokensController.stream;

  Future<T> _withWriteLock<T>(Future<T> Function() action) async {
    while (_writeLock != null) {
      await _writeLock!.future; // wait for ongoing write
    }
    final c = Completer<void>();
    _writeLock = c;
    try {
      return await action();
    } finally {
      c.complete();
      _writeLock = null;
    }
  }

  Future<Tokens?> _loadFromStorage() async {
    final access = await _store.read(key: _kAccess);
    final refresh = await _store.read(key: _kRefresh);
    final aexpStr = await _store.read(key: _kAccessExp);
    final rexpStr = await _store.read(key: _kRefreshExp);
    final aexp = aexpStr == null || aexpStr.isEmpty ? null : int.tryParse(aexpStr);
    final rexp = rexpStr == null || rexpStr.isEmpty ? null : int.tryParse(rexpStr);
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
    _loadFuture ??= _loadFromStorage();
    await _loadFuture;
    _loadFuture = null; // allow subsequent forced reloads if needed
  }

  // ----- Public API (cached) -----

  /// Unified getter: reads tokens + expiries once, then serves from cache.
  Future<Tokens?> getTokens() async {
    await _ensureCacheLoaded();
    return _cache;
  }

  /// Backwards-compatible helpers used by interceptors
  Future<String?> readAccessToken() async {
    await _ensureCacheLoaded();
    return _cache?.accessToken;
  }

  Future<String?> readRefreshToken() async {
    await _ensureCacheLoaded();
    return _cache?.refreshToken;
  }

  Future<int?> readAccessExpiryMillis() async {
    await _ensureCacheLoaded();
    return _cache?.accessExpiryMillis;
  }

  Future<int?> readRefreshExpiryMillis() async {
    await _ensureCacheLoaded();
    return _cache?.refreshExpiryMillis;
  }

  /// Atomic update: writes both tokens (and expiries if provided) or rolls back.
  /// Also updates in-memory cache.
  Future<void> writeTokens({
    required String accessToken,
    required String refreshToken,
    int? accessExpiresIn,
    int? refreshExpiresIn,
  }) async {
    await _withWriteLock(() async {
      await _ensureCacheLoaded();
      final prev = _cache;

      final now = DateTime.now().millisecondsSinceEpoch;
      int? accessExpMs = accessExpiresIn == null ? null : now + accessExpiresIn * 1000;
      int? refreshExpMs = refreshExpiresIn == null ? prev?.refreshExpiryMillis : now + refreshExpiresIn * 1000;

      // Apply web TTL cap if configured
      if (kIsWeb && webTtlCap != null) {
        final capMs = now + webTtlCap!.inMilliseconds;
        if (accessExpMs != null) accessExpMs = accessExpMs > capMs ? capMs : accessExpMs;
        if (refreshExpMs != null) refreshExpMs = refreshExpMs > capMs ? capMs : refreshExpMs;
      }

      // Perform writes with rollback on error
      try {
        await _store.write(key: _kAccess, value: accessToken);
        await _store.write(key: _kRefresh, value: refreshToken);
        if (accessExpMs != null) {
          await _store.write(key: _kAccessExp, value: accessExpMs.toString());
        }
        if (refreshExpMs != null) {
          await _store.write(key: _kRefreshExp, value: refreshExpMs.toString());
        }
        // Update cache only after successful writes
        _cache = Tokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
          accessExpiryMillis: accessExpMs,
          refreshExpiryMillis: refreshExpMs,
        );
        // Emit change event
        appLogger.i('TokenStorage: emit write (access?=${_cache?.accessToken != null}, refresh?=${_cache?.refreshToken != null})');
        _tokensController.add(_cache);
      } catch (e) {
        // Rollback best-effort to previous values
        if (prev?.accessToken != null) {
          await _store.write(key: _kAccess, value: prev!.accessToken);
        } else {
          await _store.delete(key: _kAccess);
        }
        if (prev?.refreshToken != null) {
          await _store.write(key: _kRefresh, value: prev!.refreshToken);
        } else {
          await _store.delete(key: _kRefresh);
        }
        if (prev?.accessExpiryMillis != null) {
          await _store.write(key: _kAccessExp, value: prev!.accessExpiryMillis.toString());
        } else {
          await _store.delete(key: _kAccessExp);
        }
        if (prev?.refreshExpiryMillis != null) {
          await _store.write(key: _kRefreshExp, value: prev!.refreshExpiryMillis.toString());
        } else {
          await _store.delete(key: _kRefreshExp);
        }
        rethrow;
      }
    });
  }

  /// Alias per spec
  Future<void> setTokens(String accessToken, String refreshToken, {int? accessExpiresIn, int? refreshExpiresIn}) =>
      writeTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        accessExpiresIn: accessExpiresIn,
        refreshExpiresIn: refreshExpiresIn,
      );

  Future<void> clearTokens() async {
    await _withWriteLock(() async {
      await _store.delete(key: _kAccess);
      await _store.delete(key: _kRefresh);
      await _store.delete(key: _kAccessExp);
      await _store.delete(key: _kRefreshExp);
      _cache = const Tokens();
      // Emit change event
      appLogger.i('TokenStorage: emit clear');
      _tokensController.add(_cache);
    });
  }

  /// Alias per spec
  Future<void> clear() => clearTokens();

  // ----- Utilities -----
  /// Returns true if access token is considered expired using a skew window.
  Future<bool> isAccessExpired({int skewMillis = 5000}) async {
    await _ensureCacheLoaded();
    final exp = _cache?.accessExpiryMillis;
    if (exp == null) return true;
    final now = DateTime.now().millisecondsSinceEpoch;
    return exp <= now + skewMillis;
  }

  /// Remaining TTL for access token; null if unknown; zero if already expired.
  Future<Duration?> accessTtl() async {
    await _ensureCacheLoaded();
    final exp = _cache?.accessExpiryMillis;
    if (exp == null) return null;
    final now = DateTime.now().millisecondsSinceEpoch;
    final delta = exp - now;
    return Duration(milliseconds: delta < 0 ? 0 : delta);
  }

  // Device id with small in-memory cache as well
  String? _deviceIdCache;
  Future<String> deviceId() async {
    if (_deviceIdCache != null) return _deviceIdCache!;
    final existing = await _store.read(key: _kDeviceId);
    if (existing != null && existing.isNotEmpty) {
      _deviceIdCache = existing;
      return existing;
    }
    final id = const Uuid().v4();
    await _store.write(key: _kDeviceId, value: id);
    _deviceIdCache = id;
    return id;
  }
}
