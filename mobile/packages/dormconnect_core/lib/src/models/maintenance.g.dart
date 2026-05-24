// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MaintenanceRequestImpl _$$MaintenanceRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$MaintenanceRequestImpl(
      id: json['id'] as String,
      hostelId: json['hostel_id'] as String?,
      reportedById: json['reported_by_id'] as String?,
      reportedByName: json['reported_by_name'] as String?,
      roomNumber: json['room_number'] as String?,
      category: $enumDecode(_$MaintenanceCategoryEnumMap, json['category']),
      status: $enumDecode(_$MaintenanceStatusEnumMap, json['status']),
      title: json['title'] as String?,
      description: json['description'] as String,
      location: json['location'] as String?,
      assignedToName: json['assigned_to_name'] as String?,
      scheduledAt: json['scheduled_at'] == null
          ? null
          : DateTime.parse(json['scheduled_at'] as String),
      fixedNote: json['fixed_note'] as String?,
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$MaintenanceRequestImplToJson(
    _$MaintenanceRequestImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('hostel_id', instance.hostelId);
  writeNotNull('reported_by_id', instance.reportedById);
  writeNotNull('reported_by_name', instance.reportedByName);
  writeNotNull('room_number', instance.roomNumber);
  val['category'] = _$MaintenanceCategoryEnumMap[instance.category]!;
  val['status'] = _$MaintenanceStatusEnumMap[instance.status]!;
  writeNotNull('title', instance.title);
  val['description'] = instance.description;
  writeNotNull('location', instance.location);
  writeNotNull('assigned_to_name', instance.assignedToName);
  writeNotNull('scheduled_at', instance.scheduledAt?.toIso8601String());
  writeNotNull('fixed_note', instance.fixedNote);
  writeNotNull('completed_at', instance.completedAt?.toIso8601String());
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  return val;
}

const _$MaintenanceCategoryEnumMap = {
  MaintenanceCategory.electrical: 'ELECTRICAL',
  MaintenanceCategory.plumbing: 'PLUMBING',
  MaintenanceCategory.furniture: 'FURNITURE',
  MaintenanceCategory.internet: 'INTERNET',
  MaintenanceCategory.cleanliness: 'CLEANLINESS',
  MaintenanceCategory.other: 'OTHER',
};

const _$MaintenanceStatusEnumMap = {
  MaintenanceStatus.submitted: 'SUBMITTED',
  MaintenanceStatus.assigned: 'ASSIGNED',
  MaintenanceStatus.scheduled: 'SCHEDULED',
  MaintenanceStatus.inProgress: 'IN_PROGRESS',
  MaintenanceStatus.fixed: 'FIXED',
  MaintenanceStatus.cannotFix: 'CANNOT_FIX',
};
