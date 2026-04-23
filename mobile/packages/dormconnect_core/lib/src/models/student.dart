import 'package:freezed_annotation/freezed_annotation.dart';

part 'student.freezed.dart';
part 'student.g.dart';

enum EnrollmentStatus { pending, active, inactive, checkedOut }
enum StudentStatus { inHostel, outHostel }

@freezed
class Student with _$Student {
  const factory Student({
    required String id,
    required String userId,
    required String name,
    required String phone,
    required String rollNumber,
    String? roomNumber,
    required String hostelId,
    String? hostelName,
    String? guardianName,
    String? guardianPhone,
    String? email,
    String? profilePhoto,
    String? course,
    int? year,
    String? feeReceiptUrl,
    @Default(EnrollmentStatus.pending) EnrollmentStatus enrollmentStatus,
    @Default(StudentStatus.inHostel) StudentStatus currentStatus,
    DateTime? createdAt,
  }) = _Student;

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
}
