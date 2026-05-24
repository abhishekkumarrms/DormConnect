// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudentImpl _$$StudentImplFromJson(Map<String, dynamic> json) =>
    _$StudentImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      rollNumber: json['roll_number'] as String,
      roomNumber: json['room_number'] as String?,
      hostelId: json['hostel_id'] as String,
      hostelName: json['hostel_name'] as String?,
      guardianName: json['guardian_name'] as String?,
      guardianPhone: json['guardian_phone'] as String?,
      guardianRelation: json['guardian_relation'] as String?,
      email: json['email'] as String?,
      profilePhoto: json['profile_photo'] as String?,
      course: json['course'] as String?,
      year: (json['year'] as num?)?.toInt(),
      enrollmentStatus: $enumDecodeNullable(
              _$EnrollmentStatusEnumMap, json['enrollment_status']) ??
          EnrollmentStatus.pending,
      currentStatus:
          $enumDecodeNullable(_$StudentStatusEnumMap, json['current_status']) ??
              StudentStatus.inHostel,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$StudentImplToJson(_$StudentImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'user_id': instance.userId,
    'name': instance.name,
    'phone': instance.phone,
    'roll_number': instance.rollNumber,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('room_number', instance.roomNumber);
  val['hostel_id'] = instance.hostelId;
  writeNotNull('hostel_name', instance.hostelName);
  writeNotNull('guardian_name', instance.guardianName);
  writeNotNull('guardian_phone', instance.guardianPhone);
  writeNotNull('guardian_relation', instance.guardianRelation);
  writeNotNull('email', instance.email);
  writeNotNull('profile_photo', instance.profilePhoto);
  writeNotNull('course', instance.course);
  writeNotNull('year', instance.year);
  val['enrollment_status'] =
      _$EnrollmentStatusEnumMap[instance.enrollmentStatus]!;
  val['current_status'] = _$StudentStatusEnumMap[instance.currentStatus]!;
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  return val;
}

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
