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
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'roll_number')
  String get rollNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'room_number')
  String? get roomNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'hostel_id')
  String get hostelId => throw _privateConstructorUsedError;
  @JsonKey(name: 'hostel_name')
  String? get hostelName => throw _privateConstructorUsedError;
  @JsonKey(name: 'guardian_name')
  String? get guardianName => throw _privateConstructorUsedError;
  @JsonKey(name: 'guardian_phone')
  String? get guardianPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'guardian_relation')
  String? get guardianRelation => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_photo')
  String? get profilePhoto => throw _privateConstructorUsedError;
  String? get course => throw _privateConstructorUsedError;
  int? get year => throw _privateConstructorUsedError;
  @JsonKey(name: 'enrollment_status')
  EnrollmentStatus get enrollmentStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_status')
  StudentStatus get currentStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
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
      @JsonKey(name: 'user_id') String userId,
      String name,
      String phone,
      @JsonKey(name: 'roll_number') String rollNumber,
      @JsonKey(name: 'room_number') String? roomNumber,
      @JsonKey(name: 'hostel_id') String hostelId,
      @JsonKey(name: 'hostel_name') String? hostelName,
      @JsonKey(name: 'guardian_name') String? guardianName,
      @JsonKey(name: 'guardian_phone') String? guardianPhone,
      @JsonKey(name: 'guardian_relation') String? guardianRelation,
      String? email,
      @JsonKey(name: 'profile_photo') String? profilePhoto,
      String? course,
      int? year,
      @JsonKey(name: 'enrollment_status') EnrollmentStatus enrollmentStatus,
      @JsonKey(name: 'current_status') StudentStatus currentStatus,
      @JsonKey(name: 'created_at') DateTime? createdAt});
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
    Object? guardianRelation = freezed,
    Object? email = freezed,
    Object? profilePhoto = freezed,
    Object? course = freezed,
    Object? year = freezed,
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
      guardianRelation: freezed == guardianRelation
          ? _value.guardianRelation
          : guardianRelation // ignore: cast_nullable_to_non_nullable
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
      @JsonKey(name: 'user_id') String userId,
      String name,
      String phone,
      @JsonKey(name: 'roll_number') String rollNumber,
      @JsonKey(name: 'room_number') String? roomNumber,
      @JsonKey(name: 'hostel_id') String hostelId,
      @JsonKey(name: 'hostel_name') String? hostelName,
      @JsonKey(name: 'guardian_name') String? guardianName,
      @JsonKey(name: 'guardian_phone') String? guardianPhone,
      @JsonKey(name: 'guardian_relation') String? guardianRelation,
      String? email,
      @JsonKey(name: 'profile_photo') String? profilePhoto,
      String? course,
      int? year,
      @JsonKey(name: 'enrollment_status') EnrollmentStatus enrollmentStatus,
      @JsonKey(name: 'current_status') StudentStatus currentStatus,
      @JsonKey(name: 'created_at') DateTime? createdAt});
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
    Object? guardianRelation = freezed,
    Object? email = freezed,
    Object? profilePhoto = freezed,
    Object? course = freezed,
    Object? year = freezed,
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
      guardianRelation: freezed == guardianRelation
          ? _value.guardianRelation
          : guardianRelation // ignore: cast_nullable_to_non_nullable
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
      @JsonKey(name: 'user_id') required this.userId,
      required this.name,
      required this.phone,
      @JsonKey(name: 'roll_number') required this.rollNumber,
      @JsonKey(name: 'room_number') this.roomNumber,
      @JsonKey(name: 'hostel_id') required this.hostelId,
      @JsonKey(name: 'hostel_name') this.hostelName,
      @JsonKey(name: 'guardian_name') this.guardianName,
      @JsonKey(name: 'guardian_phone') this.guardianPhone,
      @JsonKey(name: 'guardian_relation') this.guardianRelation,
      this.email,
      @JsonKey(name: 'profile_photo') this.profilePhoto,
      this.course,
      this.year,
      @JsonKey(name: 'enrollment_status')
      this.enrollmentStatus = EnrollmentStatus.pending,
      @JsonKey(name: 'current_status')
      this.currentStatus = StudentStatus.inHostel,
      @JsonKey(name: 'created_at') this.createdAt});

  factory _$StudentImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String name;
  @override
  final String phone;
  @override
  @JsonKey(name: 'roll_number')
  final String rollNumber;
  @override
  @JsonKey(name: 'room_number')
  final String? roomNumber;
  @override
  @JsonKey(name: 'hostel_id')
  final String hostelId;
  @override
  @JsonKey(name: 'hostel_name')
  final String? hostelName;
  @override
  @JsonKey(name: 'guardian_name')
  final String? guardianName;
  @override
  @JsonKey(name: 'guardian_phone')
  final String? guardianPhone;
  @override
  @JsonKey(name: 'guardian_relation')
  final String? guardianRelation;
  @override
  final String? email;
  @override
  @JsonKey(name: 'profile_photo')
  final String? profilePhoto;
  @override
  final String? course;
  @override
  final int? year;
  @override
  @JsonKey(name: 'enrollment_status')
  final EnrollmentStatus enrollmentStatus;
  @override
  @JsonKey(name: 'current_status')
  final StudentStatus currentStatus;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Student(id: $id, userId: $userId, name: $name, phone: $phone, rollNumber: $rollNumber, roomNumber: $roomNumber, hostelId: $hostelId, hostelName: $hostelName, guardianName: $guardianName, guardianPhone: $guardianPhone, guardianRelation: $guardianRelation, email: $email, profilePhoto: $profilePhoto, course: $course, year: $year, enrollmentStatus: $enrollmentStatus, currentStatus: $currentStatus, createdAt: $createdAt)';
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
            (identical(other.guardianRelation, guardianRelation) ||
                other.guardianRelation == guardianRelation) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.profilePhoto, profilePhoto) ||
                other.profilePhoto == profilePhoto) &&
            (identical(other.course, course) || other.course == course) &&
            (identical(other.year, year) || other.year == year) &&
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
      guardianRelation,
      email,
      profilePhoto,
      course,
      year,
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
      @JsonKey(name: 'user_id') required final String userId,
      required final String name,
      required final String phone,
      @JsonKey(name: 'roll_number') required final String rollNumber,
      @JsonKey(name: 'room_number') final String? roomNumber,
      @JsonKey(name: 'hostel_id') required final String hostelId,
      @JsonKey(name: 'hostel_name') final String? hostelName,
      @JsonKey(name: 'guardian_name') final String? guardianName,
      @JsonKey(name: 'guardian_phone') final String? guardianPhone,
      @JsonKey(name: 'guardian_relation') final String? guardianRelation,
      final String? email,
      @JsonKey(name: 'profile_photo') final String? profilePhoto,
      final String? course,
      final int? year,
      @JsonKey(name: 'enrollment_status')
      final EnrollmentStatus enrollmentStatus,
      @JsonKey(name: 'current_status') final StudentStatus currentStatus,
      @JsonKey(name: 'created_at') final DateTime? createdAt}) = _$StudentImpl;

  factory _Student.fromJson(Map<String, dynamic> json) = _$StudentImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get name;
  @override
  String get phone;
  @override
  @JsonKey(name: 'roll_number')
  String get rollNumber;
  @override
  @JsonKey(name: 'room_number')
  String? get roomNumber;
  @override
  @JsonKey(name: 'hostel_id')
  String get hostelId;
  @override
  @JsonKey(name: 'hostel_name')
  String? get hostelName;
  @override
  @JsonKey(name: 'guardian_name')
  String? get guardianName;
  @override
  @JsonKey(name: 'guardian_phone')
  String? get guardianPhone;
  @override
  @JsonKey(name: 'guardian_relation')
  String? get guardianRelation;
  @override
  String? get email;
  @override
  @JsonKey(name: 'profile_photo')
  String? get profilePhoto;
  @override
  String? get course;
  @override
  int? get year;
  @override
  @JsonKey(name: 'enrollment_status')
  EnrollmentStatus get enrollmentStatus;
  @override
  @JsonKey(name: 'current_status')
  StudentStatus get currentStatus;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$StudentImplCopyWith<_$StudentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
