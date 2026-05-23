// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaveApplicationImpl _$$LeaveApplicationImplFromJson(
        Map<String, dynamic> json) =>
    _$LeaveApplicationImpl(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String?,
      hostelId: json['hostelId'] as String?,
      leaveType: $enumDecode(_$LeaveTypeEnumMap, json['leaveType']),
      status: $enumDecode(_$LeaveStatusEnumMap, json['status']),
      fromDate: DateTime.parse(json['fromDate'] as String),
      toDate: DateTime.parse(json['toDate'] as String),
      reason: json['reason'] as String,
      destination: json['destination'] as String?,
      caretakerNote: json['caretakerNote'] as String?,
      guardianConfirmed: json['guardianConfirmed'] as bool? ?? false,
      contactDuringLeave: json['contactDuringLeave'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$LeaveApplicationImplToJson(
        _$LeaveApplicationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'hostelId': instance.hostelId,
      'leaveType': _$LeaveTypeEnumMap[instance.leaveType]!,
      'status': _$LeaveStatusEnumMap[instance.status]!,
      'fromDate': instance.fromDate.toIso8601String(),
      'toDate': instance.toDate.toIso8601String(),
      'reason': instance.reason,
      'destination': instance.destination,
      'caretakerNote': instance.caretakerNote,
      'guardianConfirmed': instance.guardianConfirmed,
      'contactDuringLeave': instance.contactDuringLeave,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$LeaveTypeEnumMap = {
  LeaveType.home: 'home',
  LeaveType.medical: 'medical',
  LeaveType.personal: 'personal',
  LeaveType.academic: 'academic',
};

const _$LeaveStatusEnumMap = {
  LeaveStatus.submitted: 'submitted',
  LeaveStatus.underReview: 'underReview',
  LeaveStatus.guardianContacted: 'guardianContacted',
  LeaveStatus.approved: 'approved',
  LeaveStatus.rejected: 'rejected',
};
