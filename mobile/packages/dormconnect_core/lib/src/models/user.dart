import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

enum UserRole {
  chiefWarden,
  asstChiefWarden,
  warden,
  asstWarden,
  caretaker,
  guard,
  student,
  guardian;

  bool get isStaff => [
        chiefWarden, asstChiefWarden, warden, asstWarden, caretaker
      ].contains(this);

  bool get isAdmin => [chiefWarden, asstChiefWarden].contains(this);

  String get displayName {
    switch (this) {
      case chiefWarden: return 'Chief Warden';
      case asstChiefWarden: return 'Asst. Chief Warden';
      case warden: return 'Warden';
      case asstWarden: return 'Asst. Warden';
      case caretaker: return 'Caretaker';
      case guard: return 'Guard';
      case student: return 'Student';
      case guardian: return 'Guardian';
    }
  }
}

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String phone,
    String? email,
    required UserRole role,
    String? hostelId,
    String? institutionId,
    String? fcmToken,
    @Default(true) bool isActive,
    DateTime? createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class TokenResponse with _$TokenResponse {
  const factory TokenResponse({
    required String accessToken,
    required String refreshToken,
    required String tokenType,
    required String role,
    required String userId,
  }) = _TokenResponse;

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);
}
