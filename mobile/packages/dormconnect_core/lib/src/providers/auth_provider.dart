import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../utils/constants.dart';
import '../utils/storage.dart';
import 'api_providers.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  bool get isAuthenticated => user != null;

  AuthState copyWith({User? user, bool? isLoading, String? error}) =>
      AuthState(
        user: user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AuthState()) {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final token = await SecureStorage.read(AppConstants.tokenKey);
    if (token == null) return;
    try {
      final user = await _ref.read(authApiProvider).getMe();
      state = AuthState(user: user);
    } catch (_) {
      await SecureStorage.deleteAll();
    }
  }

  Future<bool> sendOtp(String phone) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _ref.read(authApiProvider).sendOtp(phone);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _extractError(e));
      return false;
    }
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final deviceId = await _getOrCreateDeviceId();
      final data =
          await _ref.read(authApiProvider).verifyOtp(phone, otp, deviceId);
      await _saveTokens(data);
      final user = User.fromJson(data['user'] as Map<String, dynamic>);
      state = AuthState(user: user);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _extractError(e));
      return false;
    }
  }

  Future<bool> staffLogin(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final deviceId = await _getOrCreateDeviceId();
      final data = await _ref
          .read(authApiProvider)
          .staffLogin(email, password, deviceId);
      await _saveTokens(data);
      final user = User.fromJson(data['user'] as Map<String, dynamic>);
      state = AuthState(user: user);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _extractError(e));
      return false;
    }
  }

  Future<bool> guardLogin(String phone, String pin) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final deviceId = await _getOrCreateDeviceId();
      final data =
          await _ref.read(authApiProvider).guardLogin(phone, pin, deviceId);
      await _saveTokens(data);
      final user = User.fromJson(data['user'] as Map<String, dynamic>);
      state = AuthState(user: user);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _extractError(e));
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _ref.read(authApiProvider).logout();
    } catch (_) {}
    await SecureStorage.deleteAll();
    state = const AuthState();
  }

  Future<String> _getOrCreateDeviceId() async {
    var deviceId = await SecureStorage.read(AppConstants.deviceIdKey);
    if (deviceId == null) {
      deviceId = DateTime.now().millisecondsSinceEpoch.toString();
      await SecureStorage.write(AppConstants.deviceIdKey, deviceId);
    }
    return deviceId;
  }

  Future<void> _saveTokens(Map<String, dynamic> data) async {
    await SecureStorage.write(
        AppConstants.tokenKey, data['access_token'] as String);
    await SecureStorage.write(
        AppConstants.refreshTokenKey, data['refresh_token'] as String);
  }

  String _extractError(Object e) {
    final msg = e.toString();
    if (msg.contains('detail')) {
      try {
        final start = msg.indexOf('{');
        final end = msg.lastIndexOf('}') + 1;
        if (start >= 0 && end > start) {
          final json = jsonDecode(msg.substring(start, end)) as Map;
          return json['detail']?.toString() ?? msg;
        }
      } catch (_) {}
    }
    return msg;
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier(ref));

final currentUserProvider = Provider<User?>(
    (ref) => ref.watch(authProvider).user);
