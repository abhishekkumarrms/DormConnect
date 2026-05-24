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
  final String? scope;           // "full" | "enrollment" | null
  final String? enrollmentPhone; // phone saved during sendOtp
  final String? enrollmentState; // "REQUIRED" | "PENDING" | null

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.scope,
    this.enrollmentPhone,
    this.enrollmentState,
  });

  bool get isAuthenticated => user != null;
  bool get hasEnrollmentToken => scope == 'enrollment';

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    String? scope,
    String? enrollmentPhone,
    String? enrollmentState,
    bool clearUser = false,
    bool clearScope = false,
    bool clearEnrollment = false,
  }) =>
      AuthState(
        user: clearUser ? null : (user ?? this.user),
        isLoading: isLoading ?? this.isLoading,
        error: error,
        scope: clearScope ? null : (scope ?? this.scope),
        enrollmentPhone: clearEnrollment ? null : (enrollmentPhone ?? this.enrollmentPhone),
        enrollmentState: clearEnrollment ? null : (enrollmentState ?? this.enrollmentState),
      );
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AuthState(isLoading: true)) {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final token = await SecureStorage.read(AppConstants.tokenKey);
    if (token == null) {
      state = const AuthState();
      return;
    }
    try {
      final user = await _ref.read(authApiProvider).getMe();
      state = AuthState(user: user, scope: 'full');
    } catch (_) {
      await SecureStorage.deleteAll();
      state = const AuthState();
    }
  }

  Future<bool> sendOtp(String phone) async {
    state = state.copyWith(isLoading: true, error: null, enrollmentPhone: phone);
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
      final data = await _ref.read(authApiProvider).verifyOtp(phone, otp, deviceId);
      final tokenScope = data['scope'] as String? ?? 'full';
      final enrollmentState = data['enrollment_state'] as String?;

      await SecureStorage.write(AppConstants.tokenKey, data['access_token'] as String);

      if (tokenScope == 'full') {
        final refreshToken = data['refresh_token'] as String? ?? '';
        if (refreshToken.isNotEmpty) {
          await SecureStorage.write(AppConstants.refreshTokenKey, refreshToken);
        }
        final user = await _ref.read(authApiProvider).getMe();
        state = AuthState(user: user, scope: 'full');
      } else {
        // enrollment-scope — no full user profile yet
        state = AuthState(
          scope: tokenScope,
          enrollmentPhone: phone,
          enrollmentState: enrollmentState,
        );
      }
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
      final user = await _ref.read(authApiProvider).getMe();
      state = AuthState(user: user, scope: 'full');
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
      final user = await _ref.read(authApiProvider).getMe();
      state = AuthState(user: user, scope: 'full');
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _extractError(e));
      return false;
    }
  }

  /// Called after enrollment form submission — marks state as PENDING for router redirect.
  void onEnrollmentSubmitted() {
    state = state.copyWith(enrollmentState: 'PENDING');
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
    final refresh = data['refresh_token'] as String? ?? '';
    if (refresh.isNotEmpty) {
      await SecureStorage.write(AppConstants.refreshTokenKey, refresh);
    }
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
