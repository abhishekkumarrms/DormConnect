import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

class StorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static Future<void> saveTokens(
      String accessToken, String refreshToken) async {
    await Future.wait([
      _storage.write(key: AppConstants.tokenKey, value: accessToken),
      _storage.write(key: AppConstants.refreshTokenKey, value: refreshToken),
    ]);
  }

  static Future<String?> getAccessToken() =>
      _storage.read(key: AppConstants.tokenKey);

  static Future<String?> getRefreshToken() =>
      _storage.read(key: AppConstants.refreshTokenKey);

  static Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: AppConstants.tokenKey),
      _storage.delete(key: AppConstants.refreshTokenKey),
    ]);
  }

  static Future<void> saveUserId(String userId) =>
      _storage.write(key: AppConstants.userIdKey, value: userId);

  static Future<String?> getUserId() =>
      _storage.read(key: AppConstants.userIdKey);

  static Future<void> saveRole(String role) =>
      _storage.write(key: AppConstants.roleKey, value: role);

  static Future<String?> getRole() => _storage.read(key: AppConstants.roleKey);

  static Future<void> saveDeviceId() async {
    final existing = await _storage.read(key: AppConstants.deviceIdKey);
    if (existing == null) {
      final id = 'dc_${DateTime.now().millisecondsSinceEpoch}';
      await _storage.write(key: AppConstants.deviceIdKey, value: id);
    }
  }

  static Future<String> getDeviceId() async {
    await saveDeviceId();
    return (await _storage.read(key: AppConstants.deviceIdKey))!;
  }

  static Future<void> clearAll() => _storage.deleteAll();
}
