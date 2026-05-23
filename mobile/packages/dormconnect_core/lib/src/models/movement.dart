import 'package:freezed_annotation/freezed_annotation.dart';

part 'movement.freezed.dart';
part 'movement.g.dart';

enum MovementType { out, in_, manual }

@freezed
class MovementLog with _$MovementLog {
  const factory MovementLog({
    required String id,
    required String studentId,
    String? studentName,
    String? roomNumber,
    String? photoUrl,
    required MovementType type,
    String? destination,
    DateTime? expectedReturn,
    DateTime? actualReturn,
    @Default(false) bool isOverdue,
    @Default(false) bool isFlagged,
    String? note,
    DateTime? createdAt,
  }) = _MovementLog;

  factory MovementLog.fromJson(Map<String, dynamic> json) =>
      _$MovementLogFromJson(json);
}

@freezed
class GateOtp with _$GateOtp {
  const factory GateOtp({
    required String otp,
    required int expiresInSeconds,
    required String studentId,
    String? movementType,
  }) = _GateOtp;

  factory GateOtp.fromJson(Map<String, dynamic> json) =>
      _$GateOtpFromJson(json);
}

@freezed
class LiveRequest with _$LiveRequest {
  const factory LiveRequest({
    required String studentId,
    required String otp,
    required String studentName,
    String? roomNumber,
    String? rollNumber,
    String? photoUrl,
    required int secondsRemaining,
  }) = _LiveRequest;

  factory LiveRequest.fromJson(Map<String, dynamic> json) =>
      _$LiveRequestFromJson(json);
}
