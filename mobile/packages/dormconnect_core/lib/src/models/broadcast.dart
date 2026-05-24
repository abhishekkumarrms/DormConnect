import 'package:freezed_annotation/freezed_annotation.dart';

part 'broadcast.freezed.dart';
part 'broadcast.g.dart';

enum BroadcastCategory {
  @JsonValue('GENERAL') general,
  @JsonValue('IMPORTANT') important,
  @JsonValue('MESS') mess,
  @JsonValue('HOLIDAY') holiday,
  @JsonValue('EVENT') event,
}

@freezed
class Broadcast with _$Broadcast {
  const factory Broadcast({
    required String id,
    required String title,
    required String body,
    required BroadcastCategory category,
    String? sentByName,
    String? hostelId,
    DateTime? createdAt,
  }) = _Broadcast;

  factory Broadcast.fromJson(Map<String, dynamic> json) =>
      _$BroadcastFromJson(json);
}

@freezed
class Notice with _$Notice {
  const factory Notice({
    required String id,
    required String title,
    required String body,
    String? category,
    @Default(false) bool isPinned,
    String? postedByName,
    String? hostelId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Notice;

  factory Notice.fromJson(Map<String, dynamic> json) =>
      _$NoticeFromJson(json);
}
