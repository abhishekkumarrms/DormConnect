// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MovementLog _$MovementLogFromJson(Map<String, dynamic> json) {
  return _MovementLog.fromJson(json);
}

/// @nodoc
mixin _$MovementLog {
  String get id => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  String? get studentName => throw _privateConstructorUsedError;
  String? get roomNumber => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  MovementType get type => throw _privateConstructorUsedError;
  String? get destination => throw _privateConstructorUsedError;
  DateTime? get expectedReturn => throw _privateConstructorUsedError;
  DateTime? get actualReturn => throw _privateConstructorUsedError;
  bool get isOverdue => throw _privateConstructorUsedError;
  bool get isFlagged => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MovementLogCopyWith<MovementLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MovementLogCopyWith<$Res> {
  factory $MovementLogCopyWith(
          MovementLog value, $Res Function(MovementLog) then) =
      _$MovementLogCopyWithImpl<$Res, MovementLog>;
  @useResult
  $Res call(
      {String id,
      String studentId,
      String? studentName,
      String? roomNumber,
      String? photoUrl,
      MovementType type,
      String? destination,
      DateTime? expectedReturn,
      DateTime? actualReturn,
      bool isOverdue,
      bool isFlagged,
      String? note,
      DateTime? createdAt});
}

/// @nodoc
class _$MovementLogCopyWithImpl<$Res, $Val extends MovementLog>
    implements $MovementLogCopyWith<$Res> {
  _$MovementLogCopyWithImpl(this._value, this._then);

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
    Object? roomNumber = freezed,
    Object? photoUrl = freezed,
    Object? type = null,
    Object? destination = freezed,
    Object? expectedReturn = freezed,
    Object? actualReturn = freezed,
    Object? isOverdue = null,
    Object? isFlagged = null,
    Object? note = freezed,
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
      studentName: freezed == studentName
          ? _value.studentName
          : studentName // ignore: cast_nullable_to_non_nullable
              as String?,
      roomNumber: freezed == roomNumber
          ? _value.roomNumber
          : roomNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MovementType,
      destination: freezed == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String?,
      expectedReturn: freezed == expectedReturn
          ? _value.expectedReturn
          : expectedReturn // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualReturn: freezed == actualReturn
          ? _value.actualReturn
          : actualReturn // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isOverdue: null == isOverdue
          ? _value.isOverdue
          : isOverdue // ignore: cast_nullable_to_non_nullable
              as bool,
      isFlagged: null == isFlagged
          ? _value.isFlagged
          : isFlagged // ignore: cast_nullable_to_non_nullable
              as bool,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MovementLogImplCopyWith<$Res>
    implements $MovementLogCopyWith<$Res> {
  factory _$$MovementLogImplCopyWith(
          _$MovementLogImpl value, $Res Function(_$MovementLogImpl) then) =
      __$$MovementLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String studentId,
      String? studentName,
      String? roomNumber,
      String? photoUrl,
      MovementType type,
      String? destination,
      DateTime? expectedReturn,
      DateTime? actualReturn,
      bool isOverdue,
      bool isFlagged,
      String? note,
      DateTime? createdAt});
}

/// @nodoc
class __$$MovementLogImplCopyWithImpl<$Res>
    extends _$MovementLogCopyWithImpl<$Res, _$MovementLogImpl>
    implements _$$MovementLogImplCopyWith<$Res> {
  __$$MovementLogImplCopyWithImpl(
      _$MovementLogImpl _value, $Res Function(_$MovementLogImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? studentName = freezed,
    Object? roomNumber = freezed,
    Object? photoUrl = freezed,
    Object? type = null,
    Object? destination = freezed,
    Object? expectedReturn = freezed,
    Object? actualReturn = freezed,
    Object? isOverdue = null,
    Object? isFlagged = null,
    Object? note = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$MovementLogImpl(
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
      roomNumber: freezed == roomNumber
          ? _value.roomNumber
          : roomNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MovementType,
      destination: freezed == destination
          ? _value.destination
          : destination // ignore: cast_nullable_to_non_nullable
              as String?,
      expectedReturn: freezed == expectedReturn
          ? _value.expectedReturn
          : expectedReturn // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actualReturn: freezed == actualReturn
          ? _value.actualReturn
          : actualReturn // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isOverdue: null == isOverdue
          ? _value.isOverdue
          : isOverdue // ignore: cast_nullable_to_non_nullable
              as bool,
      isFlagged: null == isFlagged
          ? _value.isFlagged
          : isFlagged // ignore: cast_nullable_to_non_nullable
              as bool,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
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
class _$MovementLogImpl implements _MovementLog {
  const _$MovementLogImpl(
      {required this.id,
      required this.studentId,
      this.studentName,
      this.roomNumber,
      this.photoUrl,
      required this.type,
      this.destination,
      this.expectedReturn,
      this.actualReturn,
      this.isOverdue = false,
      this.isFlagged = false,
      this.note,
      this.createdAt});

  factory _$MovementLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$MovementLogImplFromJson(json);

  @override
  final String id;
  @override
  final String studentId;
  @override
  final String? studentName;
  @override
  final String? roomNumber;
  @override
  final String? photoUrl;
  @override
  final MovementType type;
  @override
  final String? destination;
  @override
  final DateTime? expectedReturn;
  @override
  final DateTime? actualReturn;
  @override
  @JsonKey()
  final bool isOverdue;
  @override
  @JsonKey()
  final bool isFlagged;
  @override
  final String? note;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'MovementLog(id: $id, studentId: $studentId, studentName: $studentName, roomNumber: $roomNumber, photoUrl: $photoUrl, type: $type, destination: $destination, expectedReturn: $expectedReturn, actualReturn: $actualReturn, isOverdue: $isOverdue, isFlagged: $isFlagged, note: $note, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MovementLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.studentName, studentName) ||
                other.studentName == studentName) &&
            (identical(other.roomNumber, roomNumber) ||
                other.roomNumber == roomNumber) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.expectedReturn, expectedReturn) ||
                other.expectedReturn == expectedReturn) &&
            (identical(other.actualReturn, actualReturn) ||
                other.actualReturn == actualReturn) &&
            (identical(other.isOverdue, isOverdue) ||
                other.isOverdue == isOverdue) &&
            (identical(other.isFlagged, isFlagged) ||
                other.isFlagged == isFlagged) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      studentId,
      studentName,
      roomNumber,
      photoUrl,
      type,
      destination,
      expectedReturn,
      actualReturn,
      isOverdue,
      isFlagged,
      note,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MovementLogImplCopyWith<_$MovementLogImpl> get copyWith =>
      __$$MovementLogImplCopyWithImpl<_$MovementLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MovementLogImplToJson(
      this,
    );
  }
}

abstract class _MovementLog implements MovementLog {
  const factory _MovementLog(
      {required final String id,
      required final String studentId,
      final String? studentName,
      final String? roomNumber,
      final String? photoUrl,
      required final MovementType type,
      final String? destination,
      final DateTime? expectedReturn,
      final DateTime? actualReturn,
      final bool isOverdue,
      final bool isFlagged,
      final String? note,
      final DateTime? createdAt}) = _$MovementLogImpl;

  factory _MovementLog.fromJson(Map<String, dynamic> json) =
      _$MovementLogImpl.fromJson;

  @override
  String get id;
  @override
  String get studentId;
  @override
  String? get studentName;
  @override
  String? get roomNumber;
  @override
  String? get photoUrl;
  @override
  MovementType get type;
  @override
  String? get destination;
  @override
  DateTime? get expectedReturn;
  @override
  DateTime? get actualReturn;
  @override
  bool get isOverdue;
  @override
  bool get isFlagged;
  @override
  String? get note;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$MovementLogImplCopyWith<_$MovementLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GateOtp _$GateOtpFromJson(Map<String, dynamic> json) {
  return _GateOtp.fromJson(json);
}

/// @nodoc
mixin _$GateOtp {
  String get otp => throw _privateConstructorUsedError;
  int get expiresInSeconds => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  String? get movementType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GateOtpCopyWith<GateOtp> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GateOtpCopyWith<$Res> {
  factory $GateOtpCopyWith(GateOtp value, $Res Function(GateOtp) then) =
      _$GateOtpCopyWithImpl<$Res, GateOtp>;
  @useResult
  $Res call(
      {String otp,
      int expiresInSeconds,
      String studentId,
      String? movementType});
}

/// @nodoc
class _$GateOtpCopyWithImpl<$Res, $Val extends GateOtp>
    implements $GateOtpCopyWith<$Res> {
  _$GateOtpCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? otp = null,
    Object? expiresInSeconds = null,
    Object? studentId = null,
    Object? movementType = freezed,
  }) {
    return _then(_value.copyWith(
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
      expiresInSeconds: null == expiresInSeconds
          ? _value.expiresInSeconds
          : expiresInSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      movementType: freezed == movementType
          ? _value.movementType
          : movementType // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GateOtpImplCopyWith<$Res> implements $GateOtpCopyWith<$Res> {
  factory _$$GateOtpImplCopyWith(
          _$GateOtpImpl value, $Res Function(_$GateOtpImpl) then) =
      __$$GateOtpImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String otp,
      int expiresInSeconds,
      String studentId,
      String? movementType});
}

/// @nodoc
class __$$GateOtpImplCopyWithImpl<$Res>
    extends _$GateOtpCopyWithImpl<$Res, _$GateOtpImpl>
    implements _$$GateOtpImplCopyWith<$Res> {
  __$$GateOtpImplCopyWithImpl(
      _$GateOtpImpl _value, $Res Function(_$GateOtpImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? otp = null,
    Object? expiresInSeconds = null,
    Object? studentId = null,
    Object? movementType = freezed,
  }) {
    return _then(_$GateOtpImpl(
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
      expiresInSeconds: null == expiresInSeconds
          ? _value.expiresInSeconds
          : expiresInSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      movementType: freezed == movementType
          ? _value.movementType
          : movementType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GateOtpImpl implements _GateOtp {
  const _$GateOtpImpl(
      {required this.otp,
      required this.expiresInSeconds,
      required this.studentId,
      this.movementType});

  factory _$GateOtpImpl.fromJson(Map<String, dynamic> json) =>
      _$$GateOtpImplFromJson(json);

  @override
  final String otp;
  @override
  final int expiresInSeconds;
  @override
  final String studentId;
  @override
  final String? movementType;

  @override
  String toString() {
    return 'GateOtp(otp: $otp, expiresInSeconds: $expiresInSeconds, studentId: $studentId, movementType: $movementType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GateOtpImpl &&
            (identical(other.otp, otp) || other.otp == otp) &&
            (identical(other.expiresInSeconds, expiresInSeconds) ||
                other.expiresInSeconds == expiresInSeconds) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.movementType, movementType) ||
                other.movementType == movementType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, otp, expiresInSeconds, studentId, movementType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GateOtpImplCopyWith<_$GateOtpImpl> get copyWith =>
      __$$GateOtpImplCopyWithImpl<_$GateOtpImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GateOtpImplToJson(
      this,
    );
  }
}

abstract class _GateOtp implements GateOtp {
  const factory _GateOtp(
      {required final String otp,
      required final int expiresInSeconds,
      required final String studentId,
      final String? movementType}) = _$GateOtpImpl;

  factory _GateOtp.fromJson(Map<String, dynamic> json) = _$GateOtpImpl.fromJson;

  @override
  String get otp;
  @override
  int get expiresInSeconds;
  @override
  String get studentId;
  @override
  String? get movementType;
  @override
  @JsonKey(ignore: true)
  _$$GateOtpImplCopyWith<_$GateOtpImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LiveRequest _$LiveRequestFromJson(Map<String, dynamic> json) {
  return _LiveRequest.fromJson(json);
}

/// @nodoc
mixin _$LiveRequest {
  String get studentId => throw _privateConstructorUsedError;
  String get otp => throw _privateConstructorUsedError;
  String get studentName => throw _privateConstructorUsedError;
  String? get roomNumber => throw _privateConstructorUsedError;
  String? get rollNumber => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  int get secondsRemaining => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LiveRequestCopyWith<LiveRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LiveRequestCopyWith<$Res> {
  factory $LiveRequestCopyWith(
          LiveRequest value, $Res Function(LiveRequest) then) =
      _$LiveRequestCopyWithImpl<$Res, LiveRequest>;
  @useResult
  $Res call(
      {String studentId,
      String otp,
      String studentName,
      String? roomNumber,
      String? rollNumber,
      String? photoUrl,
      int secondsRemaining});
}

/// @nodoc
class _$LiveRequestCopyWithImpl<$Res, $Val extends LiveRequest>
    implements $LiveRequestCopyWith<$Res> {
  _$LiveRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentId = null,
    Object? otp = null,
    Object? studentName = null,
    Object? roomNumber = freezed,
    Object? rollNumber = freezed,
    Object? photoUrl = freezed,
    Object? secondsRemaining = null,
  }) {
    return _then(_value.copyWith(
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
      studentName: null == studentName
          ? _value.studentName
          : studentName // ignore: cast_nullable_to_non_nullable
              as String,
      roomNumber: freezed == roomNumber
          ? _value.roomNumber
          : roomNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      rollNumber: freezed == rollNumber
          ? _value.rollNumber
          : rollNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      secondsRemaining: null == secondsRemaining
          ? _value.secondsRemaining
          : secondsRemaining // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LiveRequestImplCopyWith<$Res>
    implements $LiveRequestCopyWith<$Res> {
  factory _$$LiveRequestImplCopyWith(
          _$LiveRequestImpl value, $Res Function(_$LiveRequestImpl) then) =
      __$$LiveRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String studentId,
      String otp,
      String studentName,
      String? roomNumber,
      String? rollNumber,
      String? photoUrl,
      int secondsRemaining});
}

/// @nodoc
class __$$LiveRequestImplCopyWithImpl<$Res>
    extends _$LiveRequestCopyWithImpl<$Res, _$LiveRequestImpl>
    implements _$$LiveRequestImplCopyWith<$Res> {
  __$$LiveRequestImplCopyWithImpl(
      _$LiveRequestImpl _value, $Res Function(_$LiveRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentId = null,
    Object? otp = null,
    Object? studentName = null,
    Object? roomNumber = freezed,
    Object? rollNumber = freezed,
    Object? photoUrl = freezed,
    Object? secondsRemaining = null,
  }) {
    return _then(_$LiveRequestImpl(
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
      studentName: null == studentName
          ? _value.studentName
          : studentName // ignore: cast_nullable_to_non_nullable
              as String,
      roomNumber: freezed == roomNumber
          ? _value.roomNumber
          : roomNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      rollNumber: freezed == rollNumber
          ? _value.rollNumber
          : rollNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      secondsRemaining: null == secondsRemaining
          ? _value.secondsRemaining
          : secondsRemaining // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LiveRequestImpl implements _LiveRequest {
  const _$LiveRequestImpl(
      {required this.studentId,
      required this.otp,
      required this.studentName,
      this.roomNumber,
      this.rollNumber,
      this.photoUrl,
      required this.secondsRemaining});

  factory _$LiveRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$LiveRequestImplFromJson(json);

  @override
  final String studentId;
  @override
  final String otp;
  @override
  final String studentName;
  @override
  final String? roomNumber;
  @override
  final String? rollNumber;
  @override
  final String? photoUrl;
  @override
  final int secondsRemaining;

  @override
  String toString() {
    return 'LiveRequest(studentId: $studentId, otp: $otp, studentName: $studentName, roomNumber: $roomNumber, rollNumber: $rollNumber, photoUrl: $photoUrl, secondsRemaining: $secondsRemaining)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LiveRequestImpl &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.otp, otp) || other.otp == otp) &&
            (identical(other.studentName, studentName) ||
                other.studentName == studentName) &&
            (identical(other.roomNumber, roomNumber) ||
                other.roomNumber == roomNumber) &&
            (identical(other.rollNumber, rollNumber) ||
                other.rollNumber == rollNumber) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.secondsRemaining, secondsRemaining) ||
                other.secondsRemaining == secondsRemaining));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, studentId, otp, studentName,
      roomNumber, rollNumber, photoUrl, secondsRemaining);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LiveRequestImplCopyWith<_$LiveRequestImpl> get copyWith =>
      __$$LiveRequestImplCopyWithImpl<_$LiveRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LiveRequestImplToJson(
      this,
    );
  }
}

abstract class _LiveRequest implements LiveRequest {
  const factory _LiveRequest(
      {required final String studentId,
      required final String otp,
      required final String studentName,
      final String? roomNumber,
      final String? rollNumber,
      final String? photoUrl,
      required final int secondsRemaining}) = _$LiveRequestImpl;

  factory _LiveRequest.fromJson(Map<String, dynamic> json) =
      _$LiveRequestImpl.fromJson;

  @override
  String get studentId;
  @override
  String get otp;
  @override
  String get studentName;
  @override
  String? get roomNumber;
  @override
  String? get rollNumber;
  @override
  String? get photoUrl;
  @override
  int get secondsRemaining;
  @override
  @JsonKey(ignore: true)
  _$$LiveRequestImplCopyWith<_$LiveRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
