import 'package:freezed_annotation/freezed_annotation.dart';

part 'sos.freezed.dart';
part 'sos.g.dart';

enum SosStatus { triggered, responded, resolved }

@freezed
class SosAlert with _$SosAlert {
  const factory SosAlert({
    required String id,
    required String studentId,
    String? studentName,
    String? roomNumber,
    String? hostelName,
    String? message,
    String? location,
    @Default(SosStatus.triggered) SosStatus status,
    String? respondedById,
    String? responseNote,
    DateTime? respondedAt,
    DateTime? triggeredAt,
    DateTime? createdAt,
  }) = _SosAlert;

  factory SosAlert.fromJson(Map<String, dynamic> json) =>
      _$SosAlertFromJson(json);
}
