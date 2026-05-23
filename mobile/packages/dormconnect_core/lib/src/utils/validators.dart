class Validators {
  static String? validatePhone(String? v) {
    if (v == null || v.isEmpty) return 'Phone number required';
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v)) return 'Enter a valid 10-digit phone number';
    return null;
  }

  static String? validateEmail(String? v) {
    if (v == null || v.isEmpty) return 'Email required';
    if (!RegExp(r'^[\w.]+@[\w]+\.\w+$').hasMatch(v)) return 'Enter a valid email';
    return null;
  }

  static String? validatePin(String? v) {
    if (v == null || v.isEmpty) return 'PIN required';
    if (!RegExp(r'^\d{4,6}$').hasMatch(v)) return 'PIN must be 4–6 digits';
    return null;
  }

  static String? validateOtp(String? v) {
    if (v == null || v.isEmpty) return 'OTP required';
    if (!RegExp(r'^\d{6}$').hasMatch(v)) return 'OTP must be exactly 6 digits';
    return null;
  }

  static String? validateRequired(String? v, String fieldName) {
    if (v == null || v.trim().isEmpty) return '$fieldName is required';
    return null;
  }

  static String? validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password required';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  // Convenience aliases (old API)
  static String? phone(String? v) => validatePhone(v);
  static String? otp(String? v) => validateOtp(v);
  static String? pin(String? v) => validatePin(v);
  static String? email(String? v) => validateEmail(v);
  static String? password(String? v) => validatePassword(v);
  static String? required(String? v, [String field = 'Field']) =>
      validateRequired(v, field);
}
