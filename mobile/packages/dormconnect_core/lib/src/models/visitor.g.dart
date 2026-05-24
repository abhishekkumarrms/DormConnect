// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visitor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VisitorImpl _$$VisitorImplFromJson(Map<String, dynamic> json) =>
    _$VisitorImpl(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      visitorName: json['visitor_name'] as String,
      relation: json['relation'] as String?,
      visitorPhone: json['visitor_phone'] as String,
      purpose: json['purpose'] as String?,
      expectedAt: json['expected_at'] == null
          ? null
          : DateTime.parse(json['expected_at'] as String),
      expectedDurationHours: (json['expected_duration_hours'] as num?)?.toInt(),
      status: $enumDecodeNullable(_$VisitorStatusEnumMap, json['status']) ??
          VisitorStatus.requested,
      approvedById: json['approved_by_id'] as String?,
      entryTime: json['entry_time'] == null
          ? null
          : DateTime.parse(json['entry_time'] as String),
      exitTime: json['exit_time'] == null
          ? null
          : DateTime.parse(json['exit_time'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$VisitorImplToJson(_$VisitorImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'student_id': instance.studentId,
    'visitor_name': instance.visitorName,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('relation', instance.relation);
  val['visitor_phone'] = instance.visitorPhone;
  writeNotNull('purpose', instance.purpose);
  writeNotNull('expected_at', instance.expectedAt?.toIso8601String());
  writeNotNull('expected_duration_hours', instance.expectedDurationHours);
  val['status'] = _$VisitorStatusEnumMap[instance.status]!;
  writeNotNull('approved_by_id', instance.approvedById);
  writeNotNull('entry_time', instance.entryTime?.toIso8601String());
  writeNotNull('exit_time', instance.exitTime?.toIso8601String());
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  return val;
}

const _$VisitorStatusEnumMap = {
  VisitorStatus.requested: 'requested',
  VisitorStatus.approved: 'approved',
  VisitorStatus.rejected: 'rejected',
  VisitorStatus.inside: 'inside',
  VisitorStatus.exited: 'exited',
};
