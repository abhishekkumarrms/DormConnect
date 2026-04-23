// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visitor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Visitor _$VisitorFromJson(Map<String, dynamic> json) {
  return _Visitor.fromJson(json);
}

/// @nodoc
mixin _$Visitor {
  String get id => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  String get visitorName => throw _privateConstructorUsedError;
  String? get relation => throw _privateConstructorUsedError;
  String get visitorPhone => throw _privateConstructorUsedError;
  String? get purpose => throw _privateConstructorUsedError;
  DateTime? get expectedAt => throw _privateConstructorUsedError;
  int? get expectedDurationHours => throw _privateConstructorUsedError;
  VisitorStatus get status => throw _privateConstructorUsedError;
  String? get approvedById => throw _privateConstructorUsedError;
  DateTime? get entryTime => throw _privateConstructorUsedError;
  DateTime? get exitTime => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VisitorCopyWith<Visitor> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VisitorCopyWith<$Res> {
  factory $VisitorCopyWith(Visitor value, $Res Function(Visitor) then) =
      _$VisitorCopyWithImpl<$Res, Visitor>;
  @useResult
  $Res call(
      {String id,
      String studentId,
      String visitorName,
      String? relation,
      String visitorPhone,
      String? purpose,
      DateTime? expectedAt,
      int? expectedDurationHours,
      VisitorStatus status,
      String? approvedById,
      DateTime? entryTime,
      DateTime? exitTime,
      DateTime? createdAt});
}

/// @nodoc
class _$VisitorCopyWithImpl<$Res, $Val extends Visitor>
    implements $VisitorCopyWith<$Res> {
  _$VisitorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? visitorName = null,
    Object? relation = freezed,
    Object? visitorPhone = null,
    Object? purpose = freezed,
    Object? expectedAt = freezed,
    Object? expectedDurationHours = freezed,
    Object? status = null,
    Object? approvedById = freezed,
    Object? entryTime = freezed,
    Object? exitTime = freezed,
    Object? createdAt = freezed,
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
      visitorName: null == visitorName
          ? _value.visitorName
          : visitorName // ignore: cast_nullable_to_non_nullable
              as String,
      relation: freezed == relation
          ? _value.relation
          : relation // ignore: cast_nullable_to_non_nullable
              as String?,
      visitorPhone: null == visitorPhone
          ? _value.visitorPhone
          : visitorPhone // ignore: cast_nullable_to_non_nullable
              as String,
      purpose: freezed == purpose
          ? _value.purpose
          : purpose // ignore: cast_nullable_to_non_nullable
              as String?,
      expectedAt: freezed == expectedAt
          ? _value.expectedAt
          : expectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expectedDurationHours: freezed == expectedDurationHours
          ? _value.expectedDurationHours
          : expectedDurationHours // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as VisitorStatus,
      approvedById: freezed == approvedById
          ? _value.approvedById
          : approvedById // ignore: cast_nullable_to_non_nullable
              as String?,
      entryTime: freezed == entryTime
          ? _value.entryTime
          : entryTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      exitTime: freezed == exitTime
          ? _value.exitTime
          : exitTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VisitorImplCopyWith<$Res> implements $VisitorCopyWith<$Res> {
  factory _$$VisitorImplCopyWith(
          _$VisitorImpl value, $Res Function(_$VisitorImpl) then) =
      __$$VisitorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String studentId,
      String visitorName,
      String? relation,
      String visitorPhone,
      String? purpose,
      DateTime? expectedAt,
      int? expectedDurationHours,
      VisitorStatus status,
      String? approvedById,
      DateTime? entryTime,
      DateTime? exitTime,
      DateTime? createdAt});
}

/// @nodoc
class __$$VisitorImplCopyWithImpl<$Res>
    extends _$VisitorCopyWithImpl<$Res, _$VisitorImpl>
    implements _$$VisitorImplCopyWith<$Res> {
  __$$VisitorImplCopyWithImpl(
      _$VisitorImpl _value, $Res Function(_$VisitorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? visitorName = null,
    Object? relation = freezed,
    Object? visitorPhone = null,
    Object? purpose = freezed,
    Object? expectedAt = freezed,
    Object? expectedDurationHours = freezed,
    Object? status = null,
    Object? approvedById = freezed,
    Object? entryTime = freezed,
    Object? exitTime = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$VisitorImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      visitorName: null == visitorName
          ? _value.visitorName
          : visitorName // ignore: cast_nullable_to_non_nullable
              as String,
      relation: freezed == relation
          ? _value.relation
          : relation // ignore: cast_nullable_to_non_nullable
              as String?,
      visitorPhone: null == visitorPhone
          ? _value.visitorPhone
          : visitorPhone // ignore: cast_nullable_to_non_nullable
              as String,
      purpose: freezed == purpose
          ? _value.purpose
          : purpose // ignore: cast_nullable_to_non_nullable
              as String?,
      expectedAt: freezed == expectedAt
          ? _value.expectedAt
          : expectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expectedDurationHours: freezed == expectedDurationHours
          ? _value.expectedDurationHours
          : expectedDurationHours // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as VisitorStatus,
      approvedById: freezed == approvedById
          ? _value.approvedById
          : approvedById // ignore: cast_nullable_to_non_nullable
              as String?,
      entryTime: freezed == entryTime
          ? _value.entryTime
          : entryTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      exitTime: freezed == exitTime
          ? _value.exitTime
          : exitTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VisitorImpl implements _Visitor {
  const _$VisitorImpl(
      {required this.id,
      required this.studentId,
      required this.visitorName,
      this.relation,
      required this.visitorPhone,
      this.purpose,
      this.expectedAt,
      this.expectedDurationHours,
      this.status = VisitorStatus.requested,
      this.approvedById,
      this.entryTime,
      this.exitTime,
      this.createdAt});

  factory _$VisitorImpl.fromJson(Map<String, dynamic> json) =>
      _$$VisitorImplFromJson(json);

  @override
  final String id;
  @override
  final String studentId;
  @override
  final String visitorName;
  @override
  final String? relation;
  @override
  final String visitorPhone;
  @override
  final String? purpose;
  @override
  final DateTime? expectedAt;
  @override
  final int? expectedDurationHours;
  @override
  @JsonKey()
  final VisitorStatus status;
  @override
  final String? approvedById;
  @override
  final DateTime? entryTime;
  @override
  final DateTime? exitTime;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Visitor(id: $id, studentId: $studentId, visitorName: $visitorName, relation: $relation, visitorPhone: $visitorPhone, purpose: $purpose, expectedAt: $expectedAt, expectedDurationHours: $expectedDurationHours, status: $status, approvedById: $approvedById, entryTime: $entryTime, exitTime: $exitTime, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VisitorImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.visitorName, visitorName) ||
                other.visitorName == visitorName) &&
            (identical(other.relation, relation) ||
                other.relation == relation) &&
            (identical(other.visitorPhone, visitorPhone) ||
                other.visitorPhone == visitorPhone) &&
            (identical(other.purpose, purpose) || other.purpose == purpose) &&
            (identical(other.expectedAt, expectedAt) ||
                other.expectedAt == expectedAt) &&
            (identical(other.expectedDurationHours, expectedDurationHours) ||
                other.expectedDurationHours == expectedDurationHours) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.approvedById, approvedById) ||
                other.approvedById == approvedById) &&
            (identical(other.entryTime, entryTime) ||
                other.entryTime == entryTime) &&
            (identical(other.exitTime, exitTime) ||
                other.exitTime == exitTime) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      studentId,
      visitorName,
      relation,
      visitorPhone,
      purpose,
      expectedAt,
      expectedDurationHours,
      status,
      approvedById,
      entryTime,
      exitTime,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VisitorImplCopyWith<_$VisitorImpl> get copyWith =>
      __$$VisitorImplCopyWithImpl<_$VisitorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VisitorImplToJson(
      this,
    );
  }
}

abstract class _Visitor implements Visitor {
  const factory _Visitor(
      {required final String id,
      required final String studentId,
      required final String visitorName,
      final String? relation,
      required final String visitorPhone,
      final String? purpose,
      final DateTime? expectedAt,
      final int? expectedDurationHours,
      final VisitorStatus status,
      final String? approvedById,
      final DateTime? entryTime,
      final DateTime? exitTime,
      final DateTime? createdAt}) = _$VisitorImpl;

  factory _Visitor.fromJson(Map<String, dynamic> json) = _$VisitorImpl.fromJson;

  @override
  String get id;
  @override
  String get studentId;
  @override
  String get visitorName;
  @override
  String? get relation;
  @override
  String get visitorPhone;
  @override
  String? get purpose;
  @override
  DateTime? get expectedAt;
  @override
  int? get expectedDurationHours;
  @override
  VisitorStatus get status;
  @override
  String? get approvedById;
  @override
  DateTime? get entryTime;
  @override
  DateTime? get exitTime;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$VisitorImplCopyWith<_$VisitorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
