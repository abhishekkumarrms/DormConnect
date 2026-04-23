// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visitor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VisitorImpl _$$VisitorImplFromJson(Map<String, dynamic> json) =>
    _$VisitorImpl(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      visitorName: json['visitorName'] as String,
      relation: json['relation'] as String?,
      visitorPhone: json['visitorPhone'] as String,
      purpose: json['purpose'] as String?,
      expectedAt: json['expectedAt'] == null
          ? null
          : DateTime.parse(json['expectedAt'] as String),
      expectedDurationHours: (json['expectedDurationHours'] as num?)?.toInt(),
      status: $enumDecodeNullable(_$VisitorStatusEnumMap, json['status']) ??
          VisitorStatus.requested,
      approvedById: json['approvedById'] as String?,
      entryTime: json['entryTime'] == null
          ? null
          : DateTime.parse(json['entryTime'] as String),
      exitTime: json['exitTime'] == null
          ? null
          : DateTime.parse(json['exitTime'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$VisitorImplToJson(_$VisitorImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'visitorName': instance.visitorName,
      'relation': instance.relation,
      'visitorPhone': instance.visitorPhone,
      'purpose': instance.purpose,
      'expectedAt': instance.expectedAt?.toIso8601String(),
      'expectedDurationHours': instance.expectedDurationHours,
      'status': _$VisitorStatusEnumMap[instance.status]!,
      'approvedById': instance.approvedById,
      'entryTime': instance.entryTime?.toIso8601String(),
      'exitTime': instance.exitTime?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$VisitorStatusEnumMap = {
  VisitorStatus.requested: 'requested',
  VisitorStatus.approved: 'approved',
  VisitorStatus.rejected: 'rejected',
  VisitorStatus.inside: 'inside',
  VisitorStatus.exited: 'exited',
};
