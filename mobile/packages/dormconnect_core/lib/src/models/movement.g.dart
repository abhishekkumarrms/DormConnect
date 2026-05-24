// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MovementLogImpl _$$MovementLogImplFromJson(Map<String, dynamic> json) =>
    _$MovementLogImpl(
      id: json['id'] as String,
      studentId: json['student_id'] as String?,
      studentName: json['student_name'] as String?,
      roomNumber: json['room_number'] as String?,
      photoUrl: json['photo_url'] as String?,
      type: $enumDecode(_$MovementTypeEnumMap, json['type']),
      destination: json['destination'] as String?,
      expectedReturn: json['expected_return'] == null
          ? null
          : DateTime.parse(json['expected_return'] as String),
      actualReturn: json['actual_return'] == null
          ? null
          : DateTime.parse(json['actual_return'] as String),
      isOverdue: json['is_overdue'] as bool? ?? false,
      isFlagged: json['is_flagged'] as bool? ?? false,
      note: json['note'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$MovementLogImplToJson(_$MovementLogImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('student_id', instance.studentId);
  writeNotNull('student_name', instance.studentName);
  writeNotNull('room_number', instance.roomNumber);
  writeNotNull('photo_url', instance.photoUrl);
  val['type'] = _$MovementTypeEnumMap[instance.type]!;
  writeNotNull('destination', instance.destination);
  writeNotNull('expected_return', instance.expectedReturn?.toIso8601String());
  writeNotNull('actual_return', instance.actualReturn?.toIso8601String());
  val['is_overdue'] = instance.isOverdue;
  val['is_flagged'] = instance.isFlagged;
  writeNotNull('note', instance.note);
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  return val;
}

const _$MovementTypeEnumMap = {
  MovementType.out: 'OUT',
  MovementType.in_: 'IN',
  MovementType.manual: 'MANUAL',
};

_$GateOtpImpl _$$GateOtpImplFromJson(Map<String, dynamic> json) =>
    _$GateOtpImpl(
      otp: json['otp'] as String,
      expiresInSeconds: (json['expires_in_seconds'] as num).toInt(),
      studentId: json['student_id'] as String,
      movementType: json['movement_type'] as String?,
    );

Map<String, dynamic> _$$GateOtpImplToJson(_$GateOtpImpl instance) {
  final val = <String, dynamic>{
    'otp': instance.otp,
    'expires_in_seconds': instance.expiresInSeconds,
    'student_id': instance.studentId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('movement_type', instance.movementType);
  return val;
}

_$LiveRequestImpl _$$LiveRequestImplFromJson(Map<String, dynamic> json) =>
    _$LiveRequestImpl(
      studentId: json['student_id'] as String,
      otp: json['otp'] as String,
      studentName: json['student_name'] as String,
      roomNumber: json['room_number'] as String?,
      rollNumber: json['roll_number'] as String?,
      photoUrl: json['photo_url'] as String?,
      secondsRemaining: (json['seconds_remaining'] as num).toInt(),
    );

Map<String, dynamic> _$$LiveRequestImplToJson(_$LiveRequestImpl instance) {
  final val = <String, dynamic>{
    'student_id': instance.studentId,
    'otp': instance.otp,
    'student_name': instance.studentName,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('room_number', instance.roomNumber);
  writeNotNull('roll_number', instance.rollNumber);
  writeNotNull('photo_url', instance.photoUrl);
  val['seconds_remaining'] = instance.secondsRemaining;
  return val;
}
