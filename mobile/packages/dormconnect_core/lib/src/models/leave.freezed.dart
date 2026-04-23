// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leave.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LeaveApplication _$LeaveApplicationFromJson(Map<String, dynamic> json) {
  return _LeaveApplication.fromJson(json);
}

/// @nodoc
mixin _$LeaveApplication {
  String get id => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  String? get studentName => throw _privateConstructorUsedError;
  String? get hostelId => throw _privateConstructorUsedError;
  LeaveType get leaveType => throw _privateConstructorUsedError;
  LeaveStatus get status => throw _privateConstructorUsedError;
  DateTime get fromDate => throw _privateConstructorUsedError;
  DateTime get toDate => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  String? get destination => throw _privateConstructorUsedError;
  String? get caretakerNote => throw _privateConstructorUsedError;
  bool get guardianConfirmed => throw _privateConstructorUsedError;
  String? get contactDuringLeave => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LeaveApplicationCopyWith<LeaveApplication> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaveApplicationCopyWith<$Res> {
  factory $LeaveApplicationCopyWith(
          LeaveApplication value, $Res Function(LeaveApplication) then) =
      _$LeaveApplicationCopyWithImpl<$Res, LeaveApplication>;
  @useResult
  $Res call(
      {String id,
      String studentId,
      String? studentName,
      String? hostelId,
      LeaveType leaveType,
      LeaveStatus status,
      DateTime fromDate,
      DateTime toDate,
      String reason,
      String? destination,
      String? caretakerNote,
      bool guardianConfirmed,
      String? contactDuringLeave,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$LeaveApplicationCopyWithImpl<$Res, $Val extends LeaveApplication>
    implements $LeaveApplicationCopyWith<$Res> {
  _$LeaveApplicationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? studentName = freezed,
    Object? hostelId = freezed,
    Object? leaveType = null,
    Object? status = null,
    Object? fromDate = null,
    Object? toDate = null,
    Object? reason = null,
    Object? destination = freezed,
    Object? caretakerNote = freezed,
    Object? guardianConfirmed = null,
    Object? contactDuringLeave = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      studentName: freezed == studentName
          ? _value.studentName
          : studentName // ignore: cast_nullable_to_non_nullable
              as String?,
      hostelId: freezed == hostelId
          ? _value.hostelId
          : hostelId // ignore: cast_nullable_to_non_nullable
              as String?,
      leaveType: null == leaveType
          ? _value.leaveType
          : leaveType // ignore: cast_nullable_to_non_nullable
              as LeaveType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LeaveStatus,
      fromDate: null == fromDate
          ? _value.fromDate
          : fromDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      toDate: null == toDate
          ? _value.toDate
          : toDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      destination: freezed == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String?,
      caretakerNote: freezed == caretakerNote
          ? _value.caretakerNote
          : caretakerNote // ignore: cast_nullable_to_non_nullable
              as String?,
      guardianConfirmed: null == guardianConfirmed
          ? _value.guardianConfirmed
          : guardianConfirmed // ignore: cast_nullable_to_non_nullable
              as bool,
      contactDuringLeave: freezed == contactDuringLeave
          ? _value.contactDuringLeave
          : contactDuringLeave // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LeaveApplicationImplCopyWith<$Res>
    implements $LeaveApplicationCopyWith<$Res> {
  factory _$$LeaveApplicationImplCopyWith(_$LeaveApplicationImpl value,
          $Res Function(_$LeaveApplicationImpl) then) =
      __$$LeaveApplicationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String studentId,
      String? studentName,
      String? hostelId,
      LeaveType leaveType,
      LeaveStatus status,
      DateTime fromDate,
      DateTime toDate,
      String reason,
      String? destination,
      String? caretakerNote,
      bool guardianConfirmed,
      String? contactDuringLeave,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$LeaveApplicationImplCopyWithImpl<$Res>
    extends _$LeaveApplicationCopyWithImpl<$Res, _$LeaveApplicationImpl>
    implements _$$LeaveApplicationImplCopyWith<$Res> {
  __$$LeaveApplicationImplCopyWithImpl(_$LeaveApplicationImpl _value,
      $Res Function(_$LeaveApplicationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? studentName = freezed,
    Object? hostelId = freezed,
    Object? leaveType = null,
    Object? status = null,
    Object? fromDate = null,
    Object? toDate = null,
    Object? reason = null,
    Object? destination = freezed,
    Object? caretakerNote = freezed,
    Object? guardianConfirmed = null,
    Object? contactDuringLeave = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$LeaveApplicationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      studentName: freezed == studentName
          ? _value.studentName
          : studentName // ignore: cast_nullable_to_non_nullable
              as String?,
      hostelId: freezed == hostelId
          ? _value.hostelId
          : hostelId // ignore: cast_nullable_to_non_nullable
              as String?,
      leaveType: null == leaveType
          ? _value.leaveType
          : leaveType // ignore: cast_nullable_to_non_nullable
              as LeaveType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LeaveStatus,
      fromDate: null == fromDate
          ? _value.fromDate
          : fromDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      toDate: null == toDate
          ? _value.toDate
          : toDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      destination: freezed == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String?,
      caretakerNote: freezed == caretakerNote
          ? _value.caretakerNote
          : caretakerNote // ignore: cast_nullable_to_non_nullable
              as String?,
      guardianConfirmed: null == guardianConfirmed
          ? _value.guardianConfirmed
          : guardianConfirmed // ignore: cast_nullable_to_non_nullable
              as bool,
      contactDuringLeave: freezed == contactDuringLeave
          ? _value.contactDuringLeave
          : contactDuringLeave // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LeaveApplicationImpl implements _LeaveApplication {
  const _$LeaveApplicationImpl(
      {required this.id,
      required this.studentId,
      this.studentName,
      this.hostelId,
      required this.leaveType,
      required this.status,
      required this.fromDate,
      required this.toDate,
      required this.reason,
      this.destination,
      this.caretakerNote,
      this.guardianConfirmed = false,
      this.contactDuringLeave,
      this.createdAt,
      this.updatedAt});

  factory _$LeaveApplicationImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaveApplicationImplFromJson(json);

  @override
  final String id;
  @override
  final String studentId;
  @override
  final String? studentName;
  @override
  final String? hostelId;
  @override
  final LeaveType leaveType;
  @override
  final LeaveStatus status;
  @override
  final DateTime fromDate;
  @override
  final DateTime toDate;
  @override
  final String reason;
  @override
  final String? destination;
  @override
  final String? caretakerNote;
  @override
  @JsonKey()
  final bool guardianConfirmed;
  @override
  final String? contactDuringLeave;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'LeaveApplication(id: $id, studentId: $studentId, studentName: $studentName, hostelId: $hostelId, leaveType: $leaveType, status: $status, fromDate: $fromDate, toDate: $toDate, reason: $reason, destination: $destination, caretakerNote: $caretakerNote, guardianConfirmed: $guardianConfirmed, contactDuringLeave: $contactDuringLeave, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaveApplicationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.studentName, studentName) ||
                other.studentName == studentName) &&
            (identical(other.hostelId, hostelId) ||
                other.hostelId == hostelId) &&
            (identical(other.leaveType, leaveType) ||
                other.leaveType == leaveType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.fromDate, fromDate) ||
                other.fromDate == fromDate) &&
            (identical(other.toDate, toDate) || other.toDate == toDate) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.caretakerNote, caretakerNote) ||
                other.caretakerNote == caretakerNote) &&
            (identical(other.guardianConfirmed, guardianConfirmed) ||
                other.guardianConfirmed == guardianConfirmed) &&
            (identical(other.contactDuringLeave, contactDuringLeave) ||
                other.contactDuringLeave == contactDuringLeave) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      studentId,
      studentName,
      hostelId,
      leaveType,
      status,
      fromDate,
      toDate,
      reason,
      destination,
      caretakerNote,
      guardianConfirmed,
      contactDuringLeave,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaveApplicationImplCopyWith<_$LeaveApplicationImpl> get copyWith =>
      __$$LeaveApplicationImplCopyWithImpl<_$LeaveApplicationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaveApplicationImplToJson(
      this,
    );
  }
}

abstract class _LeaveApplication implements LeaveApplication {
  const factory _LeaveApplication(
      {required final String id,
      required final String studentId,
      final String? studentName,
      final String? hostelId,
      required final LeaveType leaveType,
      required final LeaveStatus status,
      required final DateTime fromDate,
      required final DateTime toDate,
      required final String reason,
      final String? destination,
      final String? caretakerNote,
      final bool guardianConfirmed,
      final String? contactDuringLeave,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$LeaveApplicationImpl;

  factory _LeaveApplication.fromJson(Map<String, dynamic> json) =
      _$LeaveApplicationImpl.fromJson;

  @override
  String get id;
  @override
  String get studentId;
  @override
  String? get studentName;
  @override
  String? get hostelId;
  @override
  LeaveType get leaveType;
  @override
  LeaveStatus get status;
  @override
  DateTime get fromDate;
  @override
  DateTime get toDate;
  @override
  String get reason;
  @override
  String? get destination;
  @override
  String? get caretakerNote;
  @override
  bool get guardianConfirmed;
  @override
  String? get contactDuringLeave;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$LeaveApplicationImplCopyWith<_$LeaveApplicationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
