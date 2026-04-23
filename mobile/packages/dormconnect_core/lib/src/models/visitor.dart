import 'package:freezed_annotation/freezed_annotation.dart';

part 'visitor.freezed.dart';
part 'visitor.g.dart';

enum VisitorStatus { requested, approved, rejected, inside, exited }

@freezed
class Visitor with _$Visitor {
  const factory Visitor({
    required String id,
    required String studentId,
    required String visitorName,
    String? relation,
    required String visitorPhone,
    String? purpose,
    DateTime? expectedAt,
    int? expectedDurationHours,
    @Default(VisitorStatus.requested) VisitorStatus status,
    String? approvedById,
    DateTime? entryTime,
    DateTime? exitTime,
    DateTime? createdAt,
  }) = _Visitor;

  factory Visitor.fromJson(Map<String, dynamic> json) =>
      _$VisitorFromJson(json);
}
