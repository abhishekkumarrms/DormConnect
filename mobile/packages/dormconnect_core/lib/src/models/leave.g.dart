// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaveApplicationImpl _$$LeaveApplicationImplFromJson(
        Map<String, dynamic> json) =>
    _$LeaveApplicationImpl(
      id: json['id'] as String,
      studentId: json['student_id'] as String?,
      studentName: json['student_name'] as String?,
      hostelId: json['hostel_id'] as String?,
      leaveType: $enumDecode(_$LeaveTypeEnumMap, json['leave_type']),
      status: $enumDecode(_$LeaveStatusEnumMap, json['status']),
      fromDate: DateTime.parse(json['from_date'] as String),
      toDate: DateTime.parse(json['to_date'] as String),
      reason: json['reason'] as String,
      destination: json['destination'] as String?,
      caretakerNote: json['caretaker_note'] as String?,
      guardianConfirmed: json['guardian_confirmed'] as bool? ?? false,
      contactDuringLeave: json['contact_during_leave'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$LeaveApplicationImplToJson(
    _$LeaveApplicationImpl instance) {
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
  writeNotNull('hostel_id', instance.hostelId);
  val['leave_type'] = _$LeaveTypeEnumMap[instance.leaveType]!;
  val['status'] = _$LeaveStatusEnumMap[instance.status]!;
  val['from_date'] = instance.fromDate.toIso8601String();
  val['to_date'] = instance.toDate.toIso8601String();
  val['reason'] = instance.reason;
  writeNotNull('destination', instance.destination);
  writeNotNull('caretaker_note', instance.caretakerNote);
  val['guardian_confirmed'] = instance.guardianConfirmed;
  writeNotNull('contact_during_leave', instance.contactDuringLeave);
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  return val;
}

const _$LeaveTypeEnumMap = {
  LeaveType.home: 'HOME',
  LeaveType.medical: 'MEDICAL',
  LeaveType.personal: 'PERSONAL',
  LeaveType.academic: 'ACADEMIC',
};

const _$LeaveStatusEnumMap = {
  LeaveStatus.submitted: 'SUBMITTED',
  LeaveStatus.underReview: 'UNDER_REVIEW',
  LeaveStatus.guardianContacted: 'GUARDIAN_CONTACTED',
  LeaveStatus.approved: 'APPROVED',
  LeaveStatus.rejected: 'REJECTED',
};
