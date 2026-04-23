// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mess.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MessMenu _$MessMenuFromJson(Map<String, dynamic> json) {
  return _MessMenu.fromJson(json);
}

/// @nodoc
mixin _$MessMenu {
  String get id => throw _privateConstructorUsedError;
  String get hostelId => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  String? get breakfast => throw _privateConstructorUsedError;
  String? get lunch => throw _privateConstructorUsedError;
  String? get snacks => throw _privateConstructorUsedError;
  String? get dinner => throw _privateConstructorUsedError;
  String? get postedByName => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessMenuCopyWith<MessMenu> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessMenuCopyWith<$Res> {
  factory $MessMenuCopyWith(MessMenu value, $Res Function(MessMenu) then) =
      _$MessMenuCopyWithImpl<$Res, MessMenu>;
  @useResult
  $Res call(
      {String id,
      String hostelId,
      String date,
      String? breakfast,
      String? lunch,
      String? snacks,
      String? dinner,
      String? postedByName,
      DateTime? createdAt});
}

/// @nodoc
class _$MessMenuCopyWithImpl<$Res, $Val extends MessMenu>
    implements $MessMenuCopyWith<$Res> {
  _$MessMenuCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hostelId = null,
    Object? date = null,
    Object? breakfast = freezed,
    Object? lunch = freezed,
    Object? snacks = freezed,
    Object? dinner = freezed,
    Object? postedByName = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      hostelId: null == hostelId
          ? _value.hostelId
          : hostelId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      breakfast: freezed == breakfast
          ? _value.breakfast
          : breakfast // ignore: cast_nullable_to_non_nullable
              as String?,
      lunch: freezed == lunch
          ? _value.lunch
          : lunch // ignore: cast_nullable_to_non_nullable
              as String?,
      snacks: freezed == snacks
          ? _value.snacks
          : snacks // ignore: cast_nullable_to_non_nullable
              as String?,
      dinner: freezed == dinner
          ? _value.dinner
          : dinner // ignore: cast_nullable_to_non_nullable
              as String?,
      postedByName: freezed == postedByName
          ? _value.postedByName
          : postedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessMenuImplCopyWith<$Res>
    implements $MessMenuCopyWith<$Res> {
  factory _$$MessMenuImplCopyWith(
          _$MessMenuImpl value, $Res Function(_$MessMenuImpl) then) =
      __$$MessMenuImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String hostelId,
      String date,
      String? breakfast,
      String? lunch,
      String? snacks,
      String? dinner,
      String? postedByName,
      DateTime? createdAt});
}

/// @nodoc
class __$$MessMenuImplCopyWithImpl<$Res>
    extends _$MessMenuCopyWithImpl<$Res, _$MessMenuImpl>
    implements _$$MessMenuImplCopyWith<$Res> {
  __$$MessMenuImplCopyWithImpl(
      _$MessMenuImpl _value, $Res Function(_$MessMenuImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hostelId = null,
    Object? date = null,
    Object? breakfast = freezed,
    Object? lunch = freezed,
    Object? snacks = freezed,
    Object? dinner = freezed,
    Object? postedByName = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$MessMenuImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      hostelId: null == hostelId
          ? _value.hostelId
          : hostelId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      breakfast: freezed == breakfast
          ? _value.breakfast
          : breakfast // ignore: cast_nullable_to_non_nullable
              as String?,
      lunch: freezed == lunch
          ? _value.lunch
          : lunch // ignore: cast_nullable_to_non_nullable
              as String?,
      snacks: freezed == snacks
          ? _value.snacks
          : snacks // ignore: cast_nullable_to_non_nullable
              as String?,
      dinner: freezed == dinner
          ? _value.dinner
          : dinner // ignore: cast_nullable_to_non_nullable
              as String?,
      postedByName: freezed == postedByName
          ? _value.postedByName
          : postedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessMenuImpl implements _MessMenu {
  const _$MessMenuImpl(
      {required this.id,
      required this.hostelId,
      required this.date,
      this.breakfast,
      this.lunch,
      this.snacks,
      this.dinner,
      this.postedByName,
      this.createdAt});

  factory _$MessMenuImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessMenuImplFromJson(json);

  @override
  final String id;
  @override
  final String hostelId;
  @override
  final String date;
  @override
  final String? breakfast;
  @override
  final String? lunch;
  @override
  final String? snacks;
  @override
  final String? dinner;
  @override
  final String? postedByName;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'MessMenu(id: $id, hostelId: $hostelId, date: $date, breakfast: $breakfast, lunch: $lunch, snacks: $snacks, dinner: $dinner, postedByName: $postedByName, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessMenuImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.hostelId, hostelId) ||
                other.hostelId == hostelId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.breakfast, breakfast) ||
                other.breakfast == breakfast) &&
            (identical(other.lunch, lunch) || other.lunch == lunch) &&
            (identical(other.snacks, snacks) || other.snacks == snacks) &&
            (identical(other.dinner, dinner) || other.dinner == dinner) &&
            (identical(other.postedByName, postedByName) ||
                other.postedByName == postedByName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, hostelId, date, breakfast,
      lunch, snacks, dinner, postedByName, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessMenuImplCopyWith<_$MessMenuImpl> get copyWith =>
      __$$MessMenuImplCopyWithImpl<_$MessMenuImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessMenuImplToJson(
      this,
    );
  }
}

abstract class _MessMenu implements MessMenu {
  const factory _MessMenu(
      {required final String id,
      required final String hostelId,
      required final String date,
      final String? breakfast,
      final String? lunch,
      final String? snacks,
      final String? dinner,
      final String? postedByName,
      final DateTime? createdAt}) = _$MessMenuImpl;

  factory _MessMenu.fromJson(Map<String, dynamic> json) =
      _$MessMenuImpl.fromJson;

  @override
  String get id;
  @override
  String get hostelId;
  @override
  String get date;
  @override
  String? get breakfast;
  @override
  String? get lunch;
  @override
  String? get snacks;
  @override
  String? get dinner;
  @override
  String? get postedByName;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$MessMenuImplCopyWith<_$MessMenuImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MessOff _$MessOffFromJson(Map<String, dynamic> json) {
  return _MessOff.fromJson(json);
}

/// @nodoc
mixin _$MessOff {
  String get id => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  DateTime get fromDate => throw _privateConstructorUsedError;
  DateTime get toDate => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  bool get isApproved => throw _privateConstructorUsedError;
  bool? get isAutoGenerated => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessOffCopyWith<MessOff> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessOffCopyWith<$Res> {
  factory $MessOffCopyWith(MessOff value, $Res Function(MessOff) then) =
      _$MessOffCopyWithImpl<$Res, MessOff>;
  @useResult
  $Res call(
      {String id,
      String studentId,
      DateTime fromDate,
      DateTime toDate,
      String? reason,
      bool isApproved,
      bool? isAutoGenerated,
      DateTime? createdAt});
}

/// @nodoc
class _$MessOffCopyWithImpl<$Res, $Val extends MessOff>
    implements $MessOffCopyWith<$Res> {
  _$MessOffCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? fromDate = null,
    Object? toDate = null,
    Object? reason = freezed,
    Object? isApproved = null,
    Object? isAutoGenerated = freezed,
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
      fromDate: null == fromDate
          ? _value.fromDate
          : fromDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      toDate: null == toDate
          ? _value.toDate
          : toDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      isAutoGenerated: freezed == isAutoGenerated
          ? _value.isAutoGenerated
          : isAutoGenerated // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessOffImplCopyWith<$Res> implements $MessOffCopyWith<$Res> {
  factory _$$MessOffImplCopyWith(
          _$MessOffImpl value, $Res Function(_$MessOffImpl) then) =
      __$$MessOffImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String studentId,
      DateTime fromDate,
      DateTime toDate,
      String? reason,
      bool isApproved,
      bool? isAutoGenerated,
      DateTime? createdAt});
}

/// @nodoc
class __$$MessOffImplCopyWithImpl<$Res>
    extends _$MessOffCopyWithImpl<$Res, _$MessOffImpl>
    implements _$$MessOffImplCopyWith<$Res> {
  __$$MessOffImplCopyWithImpl(
      _$MessOffImpl _value, $Res Function(_$MessOffImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? fromDate = null,
    Object? toDate = null,
    Object? reason = freezed,
    Object? isApproved = null,
    Object? isAutoGenerated = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$MessOffImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      fromDate: null == fromDate
          ? _value.fromDate
          : fromDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      toDate: null == toDate
          ? _value.toDate
          : toDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      isAutoGenerated: freezed == isAutoGenerated
          ? _value.isAutoGenerated
          : isAutoGenerated // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessOffImpl implements _MessOff {
  const _$MessOffImpl(
      {required this.id,
      required this.studentId,
      required this.fromDate,
      required this.toDate,
      this.reason,
      this.isApproved = false,
      this.isAutoGenerated,
      this.createdAt});

  factory _$MessOffImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessOffImplFromJson(json);

  @override
  final String id;
  @override
  final String studentId;
  @override
  final DateTime fromDate;
  @override
  final DateTime toDate;
  @override
  final String? reason;
  @override
  @JsonKey()
  final bool isApproved;
  @override
  final bool? isAutoGenerated;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'MessOff(id: $id, studentId: $studentId, fromDate: $fromDate, toDate: $toDate, reason: $reason, isApproved: $isApproved, isAutoGenerated: $isAutoGenerated, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessOffImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.fromDate, fromDate) ||
                other.fromDate == fromDate) &&
            (identical(other.toDate, toDate) || other.toDate == toDate) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.isApproved, isApproved) ||
                other.isApproved == isApproved) &&
            (identical(other.isAutoGenerated, isAutoGenerated) ||
                other.isAutoGenerated == isAutoGenerated) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, studentId, fromDate, toDate,
      reason, isApproved, isAutoGenerated, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessOffImplCopyWith<_$MessOffImpl> get copyWith =>
      __$$MessOffImplCopyWithImpl<_$MessOffImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessOffImplToJson(
      this,
    );
  }
}

abstract class _MessOff implements MessOff {
  const factory _MessOff(
      {required final String id,
      required final String studentId,
      required final DateTime fromDate,
      required final DateTime toDate,
      final String? reason,
      final bool isApproved,
      final bool? isAutoGenerated,
      final DateTime? createdAt}) = _$MessOffImpl;

  factory _MessOff.fromJson(Map<String, dynamic> json) = _$MessOffImpl.fromJson;

  @override
  String get id;
  @override
  String get studentId;
  @override
  DateTime get fromDate;
  @override
  DateTime get toDate;
  @override
  String? get reason;
  @override
  bool get isApproved;
  @override
  bool? get isAutoGenerated;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$MessOffImplCopyWith<_$MessOffImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
