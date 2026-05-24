// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SosAlertImpl _$$SosAlertImplFromJson(Map<String, dynamic> json) =>
    _$SosAlertImpl(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      studentName: json['student_name'] as String?,
      roomNumber: json['room_number'] as String?,
      hostelName: json['hostel_name'] as String?,
      message: json['message'] as String?,
      location: json['location'] as String?,
      status: $enumDecodeNullable(_$SosStatusEnumMap, json['status']) ??
          SosStatus.triggered,
      respondedById: json['responded_by_id'] as String?,
      responseNote: json['response_note'] as String?,
      respondedAt: json['responded_at'] == null
          ? null
          : DateTime.parse(json['responded_at'] as String),
      triggeredAt: json['triggered_at'] == null
          ? null
          : DateTime.parse(json['triggered_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$SosAlertImplToJson(_$SosAlertImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'student_id': instance.studentId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('student_name', instance.studentName);
  writeNotNull('room_number', instance.roomNumber);
  writeNotNull('hostel_name', instance.hostelName);
  writeNotNull('message', instance.message);
  writeNotNull('location', instance.location);
  val['status'] = _$SosStatusEnumMap[instance.status]!;
  writeNotNull('responded_by_id', instance.respondedById);
  writeNotNull('response_note', instance.responseNote);
  writeNotNull('responded_at', instance.respondedAt?.toIso8601String());
  writeNotNull('triggered_at', instance.triggeredAt?.toIso8601String());
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  return val;
}

const _$SosStatusEnumMap = {
  SosStatus.triggered: 'triggered',
  SosStatus.responded: 'responded',
  SosStatus.resolved: 'resolved',
};
