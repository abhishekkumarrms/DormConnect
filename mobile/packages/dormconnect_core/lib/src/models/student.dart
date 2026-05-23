import 'package:freezed_annotation/freezed_annotation.dart';

part 'student.freezed.dart';
part 'student.g.dart';

enum EnrollmentStatus { pending, active, inactive, checkedOut }
enum StudentStatus { inHostel, outHostel }

@freezed
class Student with _$Student {
  const factory Student({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    required String phone,
    @JsonKey(name: 'roll_number') required String rollNumber,
    @JsonKey(name: 'room_number') String? roomNumber,
    @JsonKey(name: 'hostel_id') required String hostelId,
    @JsonKey(name: 'hostel_name') String? hostelName,
    @JsonKey(name: 'guardian_name') String? guardianName,
    @JsonKey(name: 'guardian_phone') String? guardianPhone,
    @JsonKey(name: 'guardian_relation') String? guardianRelation,
    String? email,
    @JsonKey(name: 'profile_photo') String? profilePhoto,
    String? course,
    int? year,
    @JsonKey(name: 'enrollment_status')
    @Default(EnrollmentStatus.pending)
    EnrollmentStatus enrollmentStatus,
    @JsonKey(name: 'current_status')
    @Default(StudentStatus.inHostel)
    StudentStatus currentStatus,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Student;

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
}
