class AppConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );
  static const String tokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String deviceIdKey = 'device_id';
  static const String userKey = 'user_data';
  static const String roleKey = 'user_role';

  static const Duration otpTtl = Duration(seconds: 120);
  static const Duration smsOtpTtl = Duration(minutes: 5);
  static const int otpLength = 6;

  static const Map<String, String> roleLabels = {
    'CHIEF_WARDEN': 'Chief Warden',
    'ASST_CHIEF_WARDEN': 'Asst. Chief Warden',
    'WARDEN': 'Warden',
    'ASST_WARDEN': 'Asst. Warden',
    'CARETAKER': 'Caretaker',
    'GUARD': 'Guard',
    'STUDENT': 'Student',
    'GUARDIAN': 'Guardian',
  };
}
