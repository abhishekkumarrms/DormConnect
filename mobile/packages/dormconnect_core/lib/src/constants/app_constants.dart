class AppConstants {
  static const String appName = 'DormConnect';
  static const int otpLength = 6;
  static const int gateOtpExpirySeconds = 120;
  static const int pollingIntervalSeconds = 10;
  static const int sessionTimeoutMinutes = 60;

  // Storage keys
  static const String tokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String deviceIdKey = 'device_id';
  static const String userIdKey = 'user_id';
  static const String roleKey = 'user_role';

  static const Map<String, String> roleLabels = {
    'chiefWarden': 'Chief Warden',
    'asstChiefWarden': 'Asst. Chief Warden',
    'warden': 'Warden',
    'asstWarden': 'Asst. Warden',
    'caretaker': 'Caretaker',
    'guard': 'Guard',
    'student': 'Student',
    'guardian': 'Guardian',
  };
}
