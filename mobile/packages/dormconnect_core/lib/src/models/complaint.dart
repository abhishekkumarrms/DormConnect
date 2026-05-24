import 'package:freezed_annotation/freezed_annotation.dart';

part 'complaint.freezed.dart';
part 'complaint.g.dart';

enum ComplaintCategory {
  @JsonValue('FOOD') food,
  @JsonValue('STAFF_BEHAVIOR') staffBehavior,
  @JsonValue('SECURITY') security,
  @JsonValue('ENVIRONMENT') environment,
  @JsonValue('RAGGING') ragging,
  @JsonValue('OTHER') other,
}

enum ComplaintStatus {
  @JsonValue('SUBMITTED') submitted,
  @JsonValue('ACCEPTED') accepted,
  @JsonValue('IN_PROGRESS') inProgress,
  @JsonValue('RESOLVED') resolved,
  @JsonValue('REJECTED') rejected,
  @JsonValue('ESCALATED') escalated,
  @JsonValue('REOPENED') reopened,
}

@freezed
class ComplaintUpdate with _$ComplaintUpdate {
  const factory ComplaintUpdate({
    required String updatedByName,
    String? oldStatus,
    String? newStatus,
    String? note,
    DateTime? createdAt,
  }) = _ComplaintUpdate;

  factory ComplaintUpdate.fromJson(Map<String, dynamic> json) =>
      _$ComplaintUpdateFromJson(json);
}

@freezed
class Complaint with _$Complaint {
  const factory Complaint({
    required String id,
    String? studentId,
    String? studentName,
    String? roomNumber,
    required ComplaintCategory category,
    required ComplaintStatus status,
    required String description,
    String? photoUrl,
    String? assignedToName,
    @Default([]) List<ComplaintUpdate> updates,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Complaint;

  factory Complaint.fromJson(Map<String, dynamic> json) =>
      _$ComplaintFromJson(json);
}
