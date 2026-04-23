// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MaintenanceRequestImpl _$$MaintenanceRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$MaintenanceRequestImpl(
      id: json['id'] as String,
      hostelId: json['hostelId'] as String,
      reportedById: json['reportedById'] as String,
      reportedByName: json['reportedByName'] as String?,
      roomNumber: json['roomNumber'] as String?,
      category: $enumDecode(_$MaintenanceCategoryEnumMap, json['category']),
      status: $enumDecode(_$MaintenanceStatusEnumMap, json['status']),
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String?,
      assignedToName: json['assignedToName'] as String?,
      scheduledAt: json['scheduledAt'] == null
          ? null
          : DateTime.parse(json['scheduledAt'] as String),
      fixedNote: json['fixedNote'] as String?,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MaintenanceRequestImplToJson(
        _$MaintenanceRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hostelId': instance.hostelId,
      'reportedById': instance.reportedById,
      'reportedByName': instance.reportedByName,
      'roomNumber': instance.roomNumber,
      'category': _$MaintenanceCategoryEnumMap[instance.category]!,
      'status': _$MaintenanceStatusEnumMap[instance.status]!,
      'title': instance.title,
      'description': instance.description,
      'location': instance.location,
      'assignedToName': instance.assignedToName,
      'scheduledAt': instance.scheduledAt?.toIso8601String(),
      'fixedNote': instance.fixedNote,
      'completedAt': instance.completedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$MaintenanceCategoryEnumMap = {
  MaintenanceCategory.electrical: 'electrical',
  MaintenanceCategory.plumbing: 'plumbing',
  MaintenanceCategory.carpentry: 'carpentry',
  MaintenanceCategory.painting: 'painting',
  MaintenanceCategory.civil: 'civil',
  MaintenanceCategory.appliance: 'appliance',
  MaintenanceCategory.other: 'other',
};

const _$MaintenanceStatusEnumMap = {
  MaintenanceStatus.submitted: 'submitted',
  MaintenanceStatus.assigned: 'assigned',
  MaintenanceStatus.scheduled: 'scheduled',
  MaintenanceStatus.inProgress: 'inProgress',
  MaintenanceStatus.fixed: 'fixed',
  MaintenanceStatus.cannotFix: 'cannotFix',
};
