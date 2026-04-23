// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudentImpl _$$StudentImplFromJson(Map<String, dynamic> json) =>
    _$StudentImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      rollNumber: json['rollNumber'] as String,
      roomNumber: json['roomNumber'] as String?,
      hostelId: json['hostelId'] as String,
      hostelName: json['hostelName'] as String?,
      guardianName: json['guardianName'] as String?,
      guardianPhone: json['guardianPhone'] as String?,
      email: json['email'] as String?,
      profilePhoto: json['profilePhoto'] as String?,
      course: json['course'] as String?,
      year: (json['year'] as num?)?.toInt(),
      feeReceiptUrl: json['feeReceiptUrl'] as String?,
      enrollmentStatus: $enumDecodeNullable(
              _$EnrollmentStatusEnumMap, json['enrollmentStatus']) ??
          EnrollmentStatus.pending,
      currentStatus:
          $enumDecodeNullable(_$StudentStatusEnumMap, json['currentStatus']) ??
              StudentStatus.inHostel,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$StudentImplToJson(_$StudentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'phone': instance.phone,
      'rollNumber': instance.rollNumber,
      'roomNumber': instance.roomNumber,
      'hostelId': instance.hostelId,
      'hostelName': instance.hostelName,
      'guardianName': instance.guardianName,
      'guardianPhone': instance.guardianPhone,
      'email': instance.email,
      'profilePhoto': instance.profilePhoto,
      'course': instance.course,
      'year': instance.year,
      'feeReceiptUrl': instance.feeReceiptUrl,
      'enrollmentStatus': _$EnrollmentStatusEnumMap[instance.enrollmentStatus]!,
      'currentStatus': _$StudentStatusEnumMap[instance.currentStatus]!,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$EnrollmentStatusEnumMap = {
  EnrollmentStatus.pending: 'pending',
  EnrollmentStatus.active: 'active',
  EnrollmentStatus.inactive: 'inactive',
  EnrollmentStatus.checkedOut: 'checkedOut',
};

const _$StudentStatusEnumMap = {
  StudentStatus.inHostel: 'inHostel',
  StudentStatus.outHostel: 'outHostel',
};
