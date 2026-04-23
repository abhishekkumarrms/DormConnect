// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Student _$StudentFromJson(Map<String, dynamic> json) {
  return _Student.fromJson(json);
}

/// @nodoc
mixin _$Student {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get rollNumber => throw _privateConstructorUsedError;
  String? get roomNumber => throw _privateConstructorUsedError;
  String get hostelId => throw _privateConstructorUsedError;
  String? get hostelName => throw _privateConstructorUsedError;
  String? get guardianName => throw _privateConstructorUsedError;
  String? get guardianPhone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get profilePhoto => throw _privateConstructorUsedError;
  String? get course => throw _privateConstructorUsedError;
  int? get year => throw _privateConstructorUsedError;
  String? get feeReceiptUrl => throw _privateConstructorUsedError;
  EnrollmentStatus get enrollmentStatus => throw _privateConstructorUsedError;
  StudentStatus get currentStatus => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StudentCopyWith<Student> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentCopyWith<$Res> {
  factory $StudentCopyWith(Student value, $Res Function(Student) then) =
      _$StudentCopyWithImpl<$Res, Student>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      String phone,
      String rollNumber,
      String? roomNumber,
      String hostelId,
      String? hostelName,
      String? guardianName,
      String? guardianPhone,
      String? email,
      String? profilePhoto,
      String? course,
      int? year,
      String? feeReceiptUrl,
      EnrollmentStatus enrollmentStatus,
      StudentStatus currentStatus,
      DateTime? createdAt});
}

/// @nodoc
class _$StudentCopyWithImpl<$Res, $Val extends Student>
    implements $StudentCopyWith<$Res> {
  _$StudentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? phone = null,
    Object? rollNumber = null,
    Object? roomNumber = freezed,
    Object? hostelId = null,
    Object? hostelName = freezed,
    Object? guardianName = freezed,
    Object? guardianPhone = freezed,
    Object? email = freezed,
    Object? profilePhoto = freezed,
    Object? course = freezed,
    Object? year = freezed,
    Object? feeReceiptUrl = freezed,
    Object? enrollmentStatus = null,
    Object? currentStatus = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      rollNumber: null == rollNumber
          ? _value.rollNumber
          : rollNumber // ignore: cast_nullable_to_non_nullable
              as String,
      roomNumber: freezed == roomNumber
          ? _value.roomNumber
          : roomNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      hostelId: null == hostelId
          ? _value.hostelId
          : hostelId // ignore: cast_nullable_to_non_nullable
              as String,
      hostelName: freezed == hostelName
          ? _value.hostelName
          : hostelName // ignore: cast_nullable_to_non_nullable
              as String?,
      guardianName: freezed == guardianName
          ? _value.guardianName
          : guardianName // ignore: cast_nullable_to_non_nullable
              as String?,
      guardianPhone: freezed == guardianPhone
          ? _value.guardianPhone
          : guardianPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePhoto: freezed == profilePhoto
          ? _value.profilePhoto
          : profilePhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      course: freezed == course
          ? _value.course
          : course // ignore: cast_nullable_to_non_nullable
              as String?,
      year: freezed == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int?,
      feeReceiptUrl: freezed == feeReceiptUrl
          ? _value.feeReceiptUrl
          : feeReceiptUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      enrollmentStatus: null == enrollmentStatus
          ? _value.enrollmentStatus
          : enrollmentStatus // ignore: cast_nullable_to_non_nullable
              as EnrollmentStatus,
      currentStatus: null == currentStatus
          ? _value.currentStatus
          : currentStatus // ignore: cast_nullable_to_non_nullable
              as StudentStatus,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StudentImplCopyWith<$Res> implements $StudentCopyWith<$Res> {
  factory _$$StudentImplCopyWith(
          _$StudentImpl value, $Res Function(_$StudentImpl) then) =
      __$$StudentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      String phone,
      String rollNumber,
      String? roomNumber,
      String hostelId,
      String? hostelName,
      String? guardianName,
      String? guardianPhone,
      String? email,
      String? profilePhoto,
      String? course,
      int? year,
      String? feeReceiptUrl,
      EnrollmentStatus enrollmentStatus,
      StudentStatus currentStatus,
      DateTime? createdAt});
}

/// @nodoc
class __$$StudentImplCopyWithImpl<$Res>
    extends _$StudentCopyWithImpl<$Res, _$StudentImpl>
    implements _$$StudentImplCopyWith<$Res> {
  __$$StudentImplCopyWithImpl(
      _$StudentImpl _value, $Res Function(_$StudentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? phone = null,
    Object? rollNumber = null,
    Object? roomNumber = freezed,
    Object? hostelId = null,
    Object? hostelName = freezed,
    Object? guardianName = freezed,
    Object? guardianPhone = freezed,
    Object? email = freezed,
    Object? profilePhoto = freezed,
    Object? course = freezed,
    Object? year = freezed,
    Object? feeReceiptUrl = freezed,
    Object? enrollmentStatus = null,
    Object? currentStatus = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$StudentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      rollNumber: null == rollNumber
          ? _value.rollNumber
          : rollNumber // ignore: cast_nullable_to_non_nullable
              as String,
      roomNumber: freezed == roomNumber
          ? _value.roomNumber
          : roomNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      hostelId: null == hostelId
          ? _value.hostelId
          : hostelId // ignore: cast_nullable_to_non_nullable
              as String,
      hostelName: freezed == hostelName
          ? _value.hostelName
          : hostelName // ignore: cast_nullable_to_non_nullable
              as String?,
      guardianName: freezed == guardianName
          ? _value.guardianName
          : guardianName // ignore: cast_nullable_to_non_nullable
              as String?,
      guardianPhone: freezed == guardianPhone
          ? _value.guardianPhone
          : guardianPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePhoto: freezed == profilePhoto
          ? _value.profilePhoto
          : profilePhoto // ignore: cast_nullable_to_non_nullable
              as String?,
      course: freezed == course
          ? _value.course
          : course // ignore: cast_nullable_to_non_nullable
              as String?,
      year: freezed == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int?,
      feeReceiptUrl: freezed == feeReceiptUrl
          ? _value.feeReceiptUrl
          : feeReceiptUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      enrollmentStatus: null == enrollmentStatus
          ? _value.enrollmentStatus
          : enrollmentStatus // ignore: cast_nullable_to_non_nullable
              as EnrollmentStatus,
      currentStatus: null == currentStatus
          ? _value.currentStatus
          : currentStatus // ignore: cast_nullable_to_non_nullable
              as StudentStatus,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentImpl implements _Student {
  const _$StudentImpl(
      {required this.id,
      required this.userId,
      required this.name,
      required this.phone,
      required this.rollNumber,
      this.roomNumber,
      required this.hostelId,
      this.hostelName,
      this.guardianName,
      this.guardianPhone,
      this.email,
      this.profilePhoto,
      this.course,
      this.year,
      this.feeReceiptUrl,
      this.enrollmentStatus = EnrollmentStatus.pending,
      this.currentStatus = StudentStatus.inHostel,
      this.createdAt});

  factory _$StudentImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String name;
  @override
  final String phone;
  @override
  final String rollNumber;
  @override
  final String? roomNumber;
  @override
  final String hostelId;
  @override
  final String? hostelName;
  @override
  final String? guardianName;
  @override
  final String? guardianPhone;
  @override
  final String? email;
  @override
  final String? profilePhoto;
  @override
  final String? course;
  @override
  final int? year;
  @override
  final String? feeReceiptUrl;
  @override
  @JsonKey()
  final EnrollmentStatus enrollmentStatus;
  @override
  @JsonKey()
  final StudentStatus currentStatus;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Student(id: $id, userId: $userId, name: $name, phone: $phone, rollNumber: $rollNumber, roomNumber: $roomNumber, hostelId: $hostelId, hostelName: $hostelName, guardianName: $guardianName, guardianPhone: $guardianPhone, email: $email, profilePhoto: $profilePhoto, course: $course, year: $year, feeReceiptUrl: $feeReceiptUrl, enrollmentStatus: $enrollmentStatus, currentStatus: $currentStatus, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.rollNumber, rollNumber) ||
                other.rollNumber == rollNumber) &&
            (identical(other.roomNumber, roomNumber) ||
                other.roomNumber == roomNumber) &&
            (identical(other.hostelId, hostelId) ||
                other.hostelId == hostelId) &&
            (identical(other.hostelName, hostelName) ||
                other.hostelName == hostelName) &&
            (identical(other.guardianName, guardianName) ||
                other.guardianName == guardianName) &&
            (identical(other.guardianPhone, guardianPhone) ||
                other.guardianPhone == guardianPhone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.profilePhoto, profilePhoto) ||
                other.profilePhoto == profilePhoto) &&
            (identical(other.course, course) || other.course == course) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.feeReceiptUrl, feeReceiptUrl) ||
                other.feeReceiptUrl == feeReceiptUrl) &&
            (identical(other.enrollmentStatus, enrollmentStatus) ||
                other.enrollmentStatus == enrollmentStatus) &&
            (identical(other.currentStatus, currentStatus) ||
                other.currentStatus == currentStatus) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      name,
      phone,
      rollNumber,
      roomNumber,
      hostelId,
      hostelName,
      guardianName,
      guardianPhone,
      email,
      profilePhoto,
      course,
      year,
      feeReceiptUrl,
      enrollmentStatus,
      currentStatus,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentImplCopyWith<_$StudentImpl> get copyWith =>
      __$$StudentImplCopyWithImpl<_$StudentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentImplToJson(
      this,
    );
  }
}

abstract class _Student implements Student {
  const factory _Student(
      {required final String id,
      required final String userId,
      required final String name,
      required final String phone,
      required final String rollNumber,
      final String? roomNumber,
      required final String hostelId,
      final String? hostelName,
      final String? guardianName,
      final String? guardianPhone,
      final String? email,
      final String? profilePhoto,
      final String? course,
      final int? year,
      final String? feeReceiptUrl,
      final EnrollmentStatus enrollmentStatus,
      final StudentStatus currentStatus,
      final DateTime? createdAt}) = _$StudentImpl;

  factory _Student.fromJson(Map<String, dynamic> json) = _$StudentImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get name;
  @override
  String get phone;
  @override
  String get rollNumber;
  @override
  String? get roomNumber;
  @override
  String get hostelId;
  @override
  String? get hostelName;
  @override
  String? get guardianName;
  @override
  String? get guardianPhone;
  @override
  String? get email;
  @override
  String? get profilePhoto;
  @override
  String? get course;
  @override
  int? get year;
  @override
  String? get feeReceiptUrl;
  @override
  EnrollmentStatus get enrollmentStatus;
  @override
  StudentStatus get currentStatus;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$StudentImplCopyWith<_$StudentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
