// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HostelHealthImpl _$$HostelHealthImplFromJson(Map<String, dynamic> json) =>
    _$HostelHealthImpl(
      hostelId: json['hostel_id'] as String,
      hostelName: json['hostel_name'] as String,
      healthScore: (json['health_score'] as num).toDouble(),
      totalStudents: (json['total_students'] as num).toInt(),
      currentOut: (json['current_out'] as num).toInt(),
      complaintsPending: (json['complaints_pending'] as num).toInt(),
      maintenancePending: (json['maintenance_pending'] as num).toInt(),
      pendingLeaves: (json['pending_leaves'] as num?)?.toInt(),
      pendingEnrollments: (json['pending_enrollments'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$HostelHealthImplToJson(_$HostelHealthImpl instance) {
  final val = <String, dynamic>{
    'hostel_id': instance.hostelId,
    'hostel_name': instance.hostelName,
    'health_score': instance.healthScore,
    'total_students': instance.totalStudents,
    'current_out': instance.currentOut,
    'complaints_pending': instance.complaintsPending,
    'maintenance_pending': instance.maintenancePending,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('pending_leaves', instance.pendingLeaves);
  writeNotNull('pending_enrollments', instance.pendingEnrollments);
  return val;
}

_$InstitutionOverviewImpl _$$InstitutionOverviewImplFromJson(
        Map<String, dynamic> json) =>
    _$InstitutionOverviewImpl(
      institutionName: json['institution_name'] as String,
      totalStudents: (json['total_students'] as num).toInt(),
      totalOut: (json['total_out'] as num).toInt(),
      onLeaveToday: (json['on_leave_today'] as num).toInt(),
      overdueReturns: (json['overdue_returns'] as num).toInt(),
      hostels: (json['hostels'] as List<dynamic>)
          .map((e) => HostelHealth.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$InstitutionOverviewImplToJson(
        _$InstitutionOverviewImpl instance) =>
    <String, dynamic>{
      'institution_name': instance.institutionName,
      'total_students': instance.totalStudents,
      'total_out': instance.totalOut,
      'on_leave_today': instance.onLeaveToday,
      'overdue_returns': instance.overdueReturns,
      'hostels': instance.hostels.map((e) => e.toJson()).toList(),
    };
