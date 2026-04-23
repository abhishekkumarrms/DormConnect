// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SosAlertImpl _$$SosAlertImplFromJson(Map<String, dynamic> json) =>
    _$SosAlertImpl(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String?,
      roomNumber: json['roomNumber'] as String?,
      hostelName: json['hostelName'] as String?,
      message: json['message'] as String?,
      location: json['location'] as String?,
      status: $enumDecodeNullable(_$SosStatusEnumMap, json['status']) ??
          SosStatus.triggered,
      respondedById: json['respondedById'] as String?,
      responseNote: json['responseNote'] as String?,
      respondedAt: json['respondedAt'] == null
          ? null
          : DateTime.parse(json['respondedAt'] as String),
      triggeredAt: json['triggeredAt'] == null
          ? null
          : DateTime.parse(json['triggeredAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SosAlertImplToJson(_$SosAlertImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'roomNumber': instance.roomNumber,
      'hostelName': instance.hostelName,
      'message': instance.message,
      'location': instance.location,
      'status': _$SosStatusEnumMap[instance.status]!,
      'respondedById': instance.respondedById,
      'responseNote': instance.responseNote,
      'respondedAt': instance.respondedAt?.toIso8601String(),
      'triggeredAt': instance.triggeredAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$SosStatusEnumMap = {
  SosStatus.triggered: 'triggered',
  SosStatus.responded: 'responded',
  SosStatus.resolved: 'resolved',
};
