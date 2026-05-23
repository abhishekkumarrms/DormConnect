// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MovementLogImpl _$$MovementLogImplFromJson(Map<String, dynamic> json) =>
    _$MovementLogImpl(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String?,
      roomNumber: json['roomNumber'] as String?,
      photoUrl: json['photoUrl'] as String?,
      type: $enumDecode(_$MovementTypeEnumMap, json['type']),
      destination: json['destination'] as String?,
      expectedReturn: json['expectedReturn'] == null
          ? null
          : DateTime.parse(json['expectedReturn'] as String),
      actualReturn: json['actualReturn'] == null
          ? null
          : DateTime.parse(json['actualReturn'] as String),
      isOverdue: json['isOverdue'] as bool? ?? false,
      isFlagged: json['isFlagged'] as bool? ?? false,
      note: json['note'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$MovementLogImplToJson(_$MovementLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'roomNumber': instance.roomNumber,
      'photoUrl': instance.photoUrl,
      'type': _$MovementTypeEnumMap[instance.type]!,
      'destination': instance.destination,
      'expectedReturn': instance.expectedReturn?.toIso8601String(),
      'actualReturn': instance.actualReturn?.toIso8601String(),
      'isOverdue': instance.isOverdue,
      'isFlagged': instance.isFlagged,
      'note': instance.note,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$MovementTypeEnumMap = {
  MovementType.out: 'out',
  MovementType.in_: 'in_',
  MovementType.manual: 'manual',
};

_$GateOtpImpl _$$GateOtpImplFromJson(Map<String, dynamic> json) =>
    _$GateOtpImpl(
      otp: json['otp'] as String,
      expiresInSeconds: (json['expiresInSeconds'] as num).toInt(),
      studentId: json['studentId'] as String,
      movementType: json['movementType'] as String?,
    );

Map<String, dynamic> _$$GateOtpImplToJson(_$GateOtpImpl instance) =>
    <String, dynamic>{
      'otp': instance.otp,
      'expiresInSeconds': instance.expiresInSeconds,
      'studentId': instance.studentId,
      'movementType': instance.movementType,
    };

_$LiveRequestImpl _$$LiveRequestImplFromJson(Map<String, dynamic> json) =>
    _$LiveRequestImpl(
      studentId: json['studentId'] as String,
      otp: json['otp'] as String,
      studentName: json['studentName'] as String,
      roomNumber: json['roomNumber'] as String?,
      rollNumber: json['rollNumber'] as String?,
      photoUrl: json['photoUrl'] as String?,
      secondsRemaining: (json['secondsRemaining'] as num).toInt(),
    );

Map<String, dynamic> _$$LiveRequestImplToJson(_$LiveRequestImpl instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'otp': instance.otp,
      'studentName': instance.studentName,
      'roomNumber': instance.roomNumber,
      'rollNumber': instance.rollNumber,
      'photoUrl': instance.photoUrl,
      'secondsRemaining': instance.secondsRemaining,
    };
