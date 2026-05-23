import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics.freezed.dart';
part 'analytics.g.dart';

@freezed
class HostelHealth with _$HostelHealth {
  const factory HostelHealth({
    required String hostelId,
    required String hostelName,
    required double healthScore,
    required int totalStudents,
    required int currentOut,
    required int complaintsPending,
    required int maintenancePending,
    int? pendingLeaves,
    int? pendingEnrollments,
  }) = _HostelHealth;

  factory HostelHealth.fromJson(Map<String, dynamic> json) =>
      _$HostelHealthFromJson(json);
}

@freezed
class InstitutionOverview with _$InstitutionOverview {
  const factory InstitutionOverview({
    required String institutionName,
    required int totalStudents,
    required int totalOut,
    required int onLeaveToday,
    required int overdueReturns,
    required List<HostelHealth> hostels,
  }) = _InstitutionOverview;

  factory InstitutionOverview.fromJson(Map<String, dynamic> json) =>
      _$InstitutionOverviewFromJson(json);
}
