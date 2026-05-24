import 'package:freezed_annotation/freezed_annotation.dart';

part 'maintenance.freezed.dart';
part 'maintenance.g.dart';

enum MaintenanceCategory {
  @JsonValue('ELECTRICAL') electrical,
  @JsonValue('PLUMBING') plumbing,
  @JsonValue('FURNITURE') furniture,
  @JsonValue('INTERNET') internet,
  @JsonValue('CLEANLINESS') cleanliness,
  @JsonValue('OTHER') other,
}

enum MaintenanceStatus {
  @JsonValue('SUBMITTED') submitted,
  @JsonValue('ASSIGNED') assigned,
  @JsonValue('SCHEDULED') scheduled,
  @JsonValue('IN_PROGRESS') inProgress,
  @JsonValue('FIXED') fixed,
  @JsonValue('CANNOT_FIX') cannotFix,
}

@freezed
class MaintenanceRequest with _$MaintenanceRequest {
  const factory MaintenanceRequest({
    required String id,
    String? hostelId,
    String? reportedById,
    String? reportedByName,
    String? roomNumber,
    required MaintenanceCategory category,
    required MaintenanceStatus status,
    String? title,
    required String description,
    String? location,
    String? assignedToName,
    DateTime? scheduledAt,
    String? fixedNote,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MaintenanceRequest;

  factory MaintenanceRequest.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceRequestFromJson(json);
}
