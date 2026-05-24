import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave.freezed.dart';
part 'leave.g.dart';

enum LeaveType {
  @JsonValue('HOME') home,
  @JsonValue('MEDICAL') medical,
  @JsonValue('PERSONAL') personal,
  @JsonValue('ACADEMIC') academic,
}

enum LeaveStatus {
  @JsonValue('SUBMITTED') submitted,
  @JsonValue('UNDER_REVIEW') underReview,
  @JsonValue('GUARDIAN_CONTACTED') guardianContacted,
  @JsonValue('APPROVED') approved,
  @JsonValue('REJECTED') rejected,
}

@freezed
class LeaveApplication with _$LeaveApplication {
  const factory LeaveApplication({
    required String id,
    String? studentId,
    String? studentName,
    String? hostelId,
    required LeaveType leaveType,
    required LeaveStatus status,
    required DateTime fromDate,
    required DateTime toDate,
    required String reason,
    String? destination,
    String? caretakerNote,
    @Default(false) bool guardianConfirmed,
    String? contactDuringLeave,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _LeaveApplication;

  factory LeaveApplication.fromJson(Map<String, dynamic> json) =>
      _$LeaveApplicationFromJson(json);
}
