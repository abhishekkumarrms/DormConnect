// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HostelHealthImpl _$$HostelHealthImplFromJson(Map<String, dynamic> json) =>
    _$HostelHealthImpl(
      hostelId: json['hostelId'] as String,
      hostelName: json['hostelName'] as String,
      healthScore: (json['healthScore'] as num).toDouble(),
      totalStudents: (json['totalStudents'] as num).toInt(),
      currentOut: (json['currentOut'] as num).toInt(),
      complaintsPending: (json['complaintsPending'] as num).toInt(),
      maintenancePending: (json['maintenancePending'] as num).toInt(),
      pendingLeaves: (json['pendingLeaves'] as num?)?.toInt(),
      pendingEnrollments: (json['pendingEnrollments'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$HostelHealthImplToJson(_$HostelHealthImpl instance) =>
    <String, dynamic>{
      'hostelId': instance.hostelId,
      'hostelName': instance.hostelName,
      'healthScore': instance.healthScore,
      'totalStudents': instance.totalStudents,
      'currentOut': instance.currentOut,
      'complaintsPending': instance.complaintsPending,
      'maintenancePending': instance.maintenancePending,
      'pendingLeaves': instance.pendingLeaves,
      'pendingEnrollments': instance.pendingEnrollments,
    };

_$InstitutionOverviewImpl _$$InstitutionOverviewImplFromJson(
        Map<String, dynamic> json) =>
    _$InstitutionOverviewImpl(
      institutionName: json['institutionName'] as String,
      totalStudents: (json['totalStudents'] as num).toInt(),
      totalOut: (json['totalOut'] as num).toInt(),
      onLeaveToday: (json['onLeaveToday'] as num).toInt(),
      overdueReturns: (json['overdueReturns'] as num).toInt(),
      hostels: (json['hostels'] as List<dynamic>)
          .map((e) => HostelHealth.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$InstitutionOverviewImplToJson(
        _$InstitutionOverviewImpl instance) =>
    <String, dynamic>{
      'institutionName': instance.institutionName,
      'totalStudents': instance.totalStudents,
      'totalOut': instance.totalOut,
      'onLeaveToday': instance.onLeaveToday,
      'overdueReturns': instance.overdueReturns,
      'hostels': instance.hostels,
    };
