import 'package:freezed_annotation/freezed_annotation.dart';

part 'maintenance.freezed.dart';
part 'maintenance.g.dart';

enum MaintenanceCategory {
  electrical, plumbing, carpentry, painting, civil, appliance, other
}

enum MaintenanceStatus {
  submitted, assigned, scheduled, inProgress, fixed, cannotFix
}

@freezed
class MaintenanceRequest with _$MaintenanceRequest {
  const factory MaintenanceRequest({
    required String id,
    required String hostelId,
    required String reportedById,
    String? reportedByName,
    String? roomNumber,
    required MaintenanceCategory category,
    required MaintenanceStatus status,
    required String title,
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
