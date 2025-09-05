import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class TokenStorage {
  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';
  static const _kAccessExp = 'access_exp'; // epoch millis
  static const _kRefreshExp = 'refresh_exp'; // epoch millis
  static const _kDeviceId = 'device_id';

  final FlutterSecureStorage _storage;
  TokenStorage(this._storage);

  Future<String?> readAccessToken() => _storage.read(key: _kAccess);
  Future<String?> readRefreshToken() => _storage.read(key: _kRefresh);
  Future<int?> readAccessExpiryMillis() async {
    final v = await _storage.read(key: _kAccessExp);
    if (v == null || v.isEmpty) return null;
    return int.tryParse(v);
  }
  Future<int?> readRefreshExpiryMillis() async {
    final v = await _storage.read(key: _kRefreshExp);
    if (v == null || v.isEmpty) return null;
    return int.tryParse(v);
  }

  Future<void> writeTokens({
    required String accessToken,
    required String refreshToken,
    int? accessExpiresIn,
    int? refreshExpiresIn,
  }) async {
    await _storage.write(key: _kAccess, value: accessToken);
    await _storage.write(key: _kRefresh, value: refreshToken);
    final now = DateTime.now().millisecondsSinceEpoch;
    if (accessExpiresIn != null) {
      final exp = now + accessExpiresIn * 1000;
      await _storage.write(key: _kAccessExp, value: exp.toString());
    }
    if (refreshExpiresIn != null) {
      final exp = now + refreshExpiresIn * 1000;
      await _storage.write(key: _kRefreshExp, value: exp.toString());
    }
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _kAccess);
    await _storage.delete(key: _kRefresh);
    await _storage.delete(key: _kAccessExp);
    await _storage.delete(key: _kRefreshExp);
  }

  Future<String> deviceId() async {
    final existing = await _storage.read(key: _kDeviceId);
    if (existing != null && existing.isNotEmpty) return existing;
    final id = const Uuid().v4();
    await _storage.write(key: _kDeviceId, value: id);
    return id;
  }
}
