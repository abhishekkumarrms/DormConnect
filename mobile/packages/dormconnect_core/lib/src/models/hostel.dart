import 'package:freezed_annotation/freezed_annotation.dart';

part 'hostel.freezed.dart';
part 'hostel.g.dart';

@freezed
class Hostel with _$Hostel {
  const factory Hostel({
    required String id,
    required String institutionId,
    required String name,
    String? gender,
    int? totalRooms,
    int? totalCapacity,
    int? currentOccupancy,
    double? healthScore,
    DateTime? createdAt,
  }) = _Hostel;

  factory Hostel.fromJson(Map<String, dynamic> json) => _$HostelFromJson(json);
}

@freezed
class Institution with _$Institution {
  const factory Institution({
    required String id,
    required String name,
    String? address,
    String? logoUrl,
    DateTime? createdAt,
  }) = _Institution;

  factory Institution.fromJson(Map<String, dynamic> json) =>
      _$InstitutionFromJson(json);
}
