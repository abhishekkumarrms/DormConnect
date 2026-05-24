// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ComplaintUpdateImpl _$$ComplaintUpdateImplFromJson(
        Map<String, dynamic> json) =>
    _$ComplaintUpdateImpl(
      updatedByName: json['updated_by_name'] as String,
      oldStatus: json['old_status'] as String?,
      newStatus: json['new_status'] as String?,
      note: json['note'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$ComplaintUpdateImplToJson(
    _$ComplaintUpdateImpl instance) {
  final val = <String, dynamic>{
    'updated_by_name': instance.updatedByName,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('old_status', instance.oldStatus);
  writeNotNull('new_status', instance.newStatus);
  writeNotNull('note', instance.note);
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  return val;
}

_$ComplaintImpl _$$ComplaintImplFromJson(Map<String, dynamic> json) =>
    _$ComplaintImpl(
      id: json['id'] as String,
      studentId: json['student_id'] as String?,
      studentName: json['student_name'] as String?,
      roomNumber: json['room_number'] as String?,
      category: $enumDecode(_$ComplaintCategoryEnumMap, json['category']),
      status: $enumDecode(_$ComplaintStatusEnumMap, json['status']),
      description: json['description'] as String,
      photoUrl: json['photo_url'] as String?,
      assignedToName: json['assigned_to_name'] as String?,
      updates: (json['updates'] as List<dynamic>?)
              ?.map((e) => ComplaintUpdate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ComplaintImplToJson(_$ComplaintImpl instance) {
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
  val['category'] = _$ComplaintCategoryEnumMap[instance.category]!;
  val['status'] = _$ComplaintStatusEnumMap[instance.status]!;
  val['description'] = instance.description;
  writeNotNull('photo_url', instance.photoUrl);
  writeNotNull('assigned_to_name', instance.assignedToName);
  val['updates'] = instance.updates.map((e) => e.toJson()).toList();
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  return val;
}

const _$ComplaintCategoryEnumMap = {
  ComplaintCategory.food: 'FOOD',
  ComplaintCategory.staffBehavior: 'STAFF_BEHAVIOR',
  ComplaintCategory.security: 'SECURITY',
  ComplaintCategory.environment: 'ENVIRONMENT',
  ComplaintCategory.ragging: 'RAGGING',
  ComplaintCategory.other: 'OTHER',
};

const _$ComplaintStatusEnumMap = {
  ComplaintStatus.submitted: 'SUBMITTED',
  ComplaintStatus.accepted: 'ACCEPTED',
  ComplaintStatus.inProgress: 'IN_PROGRESS',
  ComplaintStatus.resolved: 'RESOLVED',
  ComplaintStatus.rejected: 'REJECTED',
  ComplaintStatus.escalated: 'ESCALATED',
  ComplaintStatus.reopened: 'REOPENED',
};
