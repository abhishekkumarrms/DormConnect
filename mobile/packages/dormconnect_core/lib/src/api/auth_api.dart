import 'api_client.dart';
import '../models/user.dart';

class AuthApi {
  final ApiClient _client;
  AuthApi(this._client);

  Future<Map<String, dynamic>> sendOtp(String phone) async {
    final resp = await _client.post('/api/v1/auth/send-otp', data: {'phone': phone});
    return resp.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp, String deviceId) async {
    final resp = await _client.post('/api/v1/auth/verify-otp', data: {
      'phone': phone,
      'otp': otp,
      'device_id': deviceId,
    });
    return resp.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> staffLogin(String email, String password, String deviceId) async {
    final resp = await _client.post('/api/v1/auth/staff-login', data: {
      'email': email,
      'password': password,
      'device_id': deviceId,
    });
    return resp.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> guardLogin(String phone, String pin, String deviceId) async {
    final resp = await _client.post('/api/v1/auth/guard-login', data: {
      'phone': phone,
      'pin': pin,
      'device_id': deviceId,
    });
    return resp.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final resp = await _client.post('/api/v1/auth/refresh',
        data: {'refresh_token': refreshToken});
    return resp.data as Map<String, dynamic>;
  }

  Future<void> logout() async {
    await _client.post('/api/v1/auth/logout');
  }

  Future<User> getMe() async {
    final resp = await _client.get('/api/v1/auth/me');
    return User.fromJson(resp.data as Map<String, dynamic>);
  }
}
