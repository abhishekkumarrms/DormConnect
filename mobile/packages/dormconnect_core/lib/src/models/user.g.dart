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
      hostelId: json['hostelId'] as String?,
      institutionId: json['institutionId'] as String?,
      fcmToken: json['fcmToken'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'role': _$UserRoleEnumMap[instance.role]!,
      'hostelId': instance.hostelId,
      'institutionId': instance.institutionId,
      'fcmToken': instance.fcmToken,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

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
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenType: json['tokenType'] as String,
      role: json['role'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$$TokenResponseImplToJson(_$TokenResponseImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'tokenType': instance.tokenType,
      'role': instance.role,
      'userId': instance.userId,
    };
