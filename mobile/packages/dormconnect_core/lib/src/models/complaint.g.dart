// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ComplaintUpdateImpl _$$ComplaintUpdateImplFromJson(
        Map<String, dynamic> json) =>
    _$ComplaintUpdateImpl(
      updatedByName: json['updatedByName'] as String,
      oldStatus: json['oldStatus'] as String?,
      newStatus: json['newStatus'] as String?,
      note: json['note'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ComplaintUpdateImplToJson(
        _$ComplaintUpdateImpl instance) =>
    <String, dynamic>{
      'updatedByName': instance.updatedByName,
      'oldStatus': instance.oldStatus,
      'newStatus': instance.newStatus,
      'note': instance.note,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$ComplaintImpl _$$ComplaintImplFromJson(Map<String, dynamic> json) =>
    _$ComplaintImpl(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String?,
      roomNumber: json['roomNumber'] as String?,
      category: $enumDecode(_$ComplaintCategoryEnumMap, json['category']),
      status: $enumDecode(_$ComplaintStatusEnumMap, json['status']),
      description: json['description'] as String,
      photoUrl: json['photoUrl'] as String?,
      assignedToName: json['assignedToName'] as String?,
      updates: (json['updates'] as List<dynamic>?)
              ?.map((e) => ComplaintUpdate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ComplaintImplToJson(_$ComplaintImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'roomNumber': instance.roomNumber,
      'category': _$ComplaintCategoryEnumMap[instance.category]!,
      'status': _$ComplaintStatusEnumMap[instance.status]!,
      'description': instance.description,
      'photoUrl': instance.photoUrl,
      'assignedToName': instance.assignedToName,
      'updates': instance.updates,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$ComplaintCategoryEnumMap = {
  ComplaintCategory.electrical: 'electrical',
  ComplaintCategory.plumbing: 'plumbing',
  ComplaintCategory.furniture: 'furniture',
  ComplaintCategory.cleaning: 'cleaning',
  ComplaintCategory.internet: 'internet',
  ComplaintCategory.food: 'food',
  ComplaintCategory.security: 'security',
  ComplaintCategory.other: 'other',
};

const _$ComplaintStatusEnumMap = {
  ComplaintStatus.submitted: 'submitted',
  ComplaintStatus.accepted: 'accepted',
  ComplaintStatus.inProgress: 'inProgress',
  ComplaintStatus.resolved: 'resolved',
  ComplaintStatus.rejected: 'rejected',
  ComplaintStatus.escalated: 'escalated',
  ComplaintStatus.reopened: 'reopened',
};
