// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      hostelId: json['hostel_id'] as String?,
      institutionId: json['institution_id'] as String?,
      fcmToken: json['fcm_token'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'phone': instance.phone,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('email', instance.email);
  val['role'] = _$UserRoleEnumMap[instance.role]!;
  writeNotNull('hostel_id', instance.hostelId);
  writeNotNull('institution_id', instance.institutionId);
  writeNotNull('fcm_token', instance.fcmToken);
  val['is_active'] = instance.isActive;
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  return val;
}

const _$UserRoleEnumMap = {
  UserRole.chiefWarden: 'chiefWarden',
  UserRole.asstChiefWarden: 'asstChiefWarden',
  UserRole.warden: 'warden',
  UserRole.asstWarden: 'asstWarden',
  UserRole.caretaker: 'caretaker',
  UserRole.guard: 'guard',
  UserRole.student: 'student',
  UserRole.guardian: 'guardian',
};

_$TokenResponseImpl _$$TokenResponseImplFromJson(Map<String, dynamic> json) =>
    _$TokenResponseImpl(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String,
      role: json['role'] as String,
      userId: json['user_id'] as String,
    );

Map<String, dynamic> _$$TokenResponseImplToJson(_$TokenResponseImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'token_type': instance.tokenType,
      'role': instance.role,
      'user_id': instance.userId,
    };
