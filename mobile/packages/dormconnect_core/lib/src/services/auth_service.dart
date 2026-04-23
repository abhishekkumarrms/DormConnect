import '../api/api_client.dart';
import '../constants/api_constants.dart';
import '../models/user.dart';
import 'storage_service.dart';

class AuthService {
  final ApiClient _client;
  AuthService(this._client);

  Future<bool> sendOtp(String phone) async {
    final resp = await _client.post(
      '${ApiConstants.apiPrefix}${ApiConstants.sendOtp}',
      data: {'phone': phone},
    );
    return resp.statusCode == 200;
  }

  Future<TokenResponse> verifyOtp(String phone, String otp) async {
    final deviceId = await StorageService.getDeviceId();
    final resp = await _client.post(
      '${ApiConstants.apiPrefix}${ApiConstants.verifyOtp}',
      data: {'phone': phone, 'otp': otp, 'device_id': deviceId},
    );
    final token = TokenResponse.fromJson(resp.data as Map<String, dynamic>);
    await _saveSession(token);
    return token;
  }

  Future<TokenResponse> staffLogin(String email, String password) async {
    final deviceId = await StorageService.getDeviceId();
    final resp = await _client.post(
      '${ApiConstants.apiPrefix}${ApiConstants.staffLogin}',
      data: {'email': email, 'password': password, 'device_id': deviceId},
    );
    final token = TokenResponse.fromJson(resp.data as Map<String, dynamic>);
    await _saveSession(token);
    return token;
  }

  Future<TokenResponse> guardLogin(String phone, String pin) async {
    final deviceId = await StorageService.getDeviceId();
    final resp = await _client.post(
      '${ApiConstants.apiPrefix}${ApiConstants.guardLogin}',
      data: {'phone': phone, 'pin': pin, 'device_id': deviceId},
    );
    final token = TokenResponse.fromJson(resp.data as Map<String, dynamic>);
    await _saveSession(token);
    return token;
  }

  Future<void> logout() async {
    try {
      await _client.post(
          '${ApiConstants.apiPrefix}${ApiConstants.logout}');
    } catch (_) {}
    await StorageService.clearAll();
  }

  Future<bool> isLoggedIn() async {
    final token = await StorageService.getAccessToken();
    return token != null;
  }

  Future<String?> getCurrentRole() => StorageService.getRole();

  Future<void> _saveSession(TokenResponse token) async {
    await Future.wait([
      StorageService.saveTokens(token.accessToken, token.refreshToken),
      StorageService.saveUserId(token.userId),
      StorageService.saveRole(token.role),
    ]);
  }
}
