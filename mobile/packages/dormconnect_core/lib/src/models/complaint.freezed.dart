// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'complaint.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ComplaintUpdate _$ComplaintUpdateFromJson(Map<String, dynamic> json) {
  return _ComplaintUpdate.fromJson(json);
}

/// @nodoc
mixin _$ComplaintUpdate {
  String get updatedByName => throw _privateConstructorUsedError;
  String? get oldStatus => throw _privateConstructorUsedError;
  String? get newStatus => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ComplaintUpdateCopyWith<ComplaintUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ComplaintUpdateCopyWith<$Res> {
  factory $ComplaintUpdateCopyWith(
          ComplaintUpdate value, $Res Function(ComplaintUpdate) then) =
      _$ComplaintUpdateCopyWithImpl<$Res, ComplaintUpdate>;
  @useResult
  $Res call(
      {String updatedByName,
      String? oldStatus,
      String? newStatus,
      String? note,
      DateTime? createdAt});
}

/// @nodoc
class _$ComplaintUpdateCopyWithImpl<$Res, $Val extends ComplaintUpdate>
    implements $ComplaintUpdateCopyWith<$Res> {
  _$ComplaintUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? updatedByName = null,
    Object? oldStatus = freezed,
    Object? newStatus = freezed,
    Object? note = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      updatedByName: null == updatedByName
          ? _value.updatedByName
          : updatedByName // ignore: cast_nullable_to_non_nullable
              as String,
      oldStatus: freezed == oldStatus
          ? _value.oldStatus
          : oldStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      newStatus: freezed == newStatus
          ? _value.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$ComplaintUpdateImplCopyWith<$Res>
    implements $ComplaintUpdateCopyWith<$Res> {
  factory _$$ComplaintUpdateImplCopyWith(_$ComplaintUpdateImpl value,
          $Res Function(_$ComplaintUpdateImpl) then) =
      __$$ComplaintUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String updatedByName,
      String? oldStatus,
      String? newStatus,
      String? note,
      DateTime? createdAt});
}

/// @nodoc
class __$$ComplaintUpdateImplCopyWithImpl<$Res>
    extends _$ComplaintUpdateCopyWithImpl<$Res, _$ComplaintUpdateImpl>
    implements _$$ComplaintUpdateImplCopyWith<$Res> {
  __$$ComplaintUpdateImplCopyWithImpl(
      _$ComplaintUpdateImpl _value, $Res Function(_$ComplaintUpdateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? updatedByName = null,
    Object? oldStatus = freezed,
    Object? newStatus = freezed,
    Object? note = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$ComplaintUpdateImpl(
      updatedByName: null == updatedByName
          ? _value.updatedByName
          : updatedByName // ignore: cast_nullable_to_non_nullable
              as String,
      oldStatus: freezed == oldStatus
          ? _value.oldStatus
          : oldStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      newStatus: freezed == newStatus
          ? _value.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$ComplaintUpdateImpl implements _ComplaintUpdate {
  const _$ComplaintUpdateImpl(
      {required this.updatedByName,
      this.oldStatus,
      this.newStatus,
      this.note,
      this.createdAt});

  factory _$ComplaintUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ComplaintUpdateImplFromJson(json);

  @override
  final String updatedByName;
  @override
  final String? oldStatus;
  @override
  final String? newStatus;
  @override
  final String? note;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ComplaintUpdate(updatedByName: $updatedByName, oldStatus: $oldStatus, newStatus: $newStatus, note: $note, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ComplaintUpdateImpl &&
            (identical(other.updatedByName, updatedByName) ||
                other.updatedByName == updatedByName) &&
            (identical(other.oldStatus, oldStatus) ||
                other.oldStatus == oldStatus) &&
            (identical(other.newStatus, newStatus) ||
                other.newStatus == newStatus) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, updatedByName, oldStatus, newStatus, note, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ComplaintUpdateImplCopyWith<_$ComplaintUpdateImpl> get copyWith =>
      __$$ComplaintUpdateImplCopyWithImpl<_$ComplaintUpdateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ComplaintUpdateImplToJson(
      this,
    );
  }
}

abstract class _ComplaintUpdate implements ComplaintUpdate {
  const factory _ComplaintUpdate(
      {required final String updatedByName,
      final String? oldStatus,
      final String? newStatus,
      final String? note,
      final DateTime? createdAt}) = _$ComplaintUpdateImpl;

  factory _ComplaintUpdate.fromJson(Map<String, dynamic> json) =
      _$ComplaintUpdateImpl.fromJson;

  @override
  String get updatedByName;
  @override
  String? get oldStatus;
  @override
  String? get newStatus;
  @override
  String? get note;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$ComplaintUpdateImplCopyWith<_$ComplaintUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Complaint _$ComplaintFromJson(Map<String, dynamic> json) {
  return _Complaint.fromJson(json);
}

/// @nodoc
mixin _$Complaint {
  String get id => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  String? get studentName => throw _privateConstructorUsedError;
  String? get roomNumber => throw _privateConstructorUsedError;
  ComplaintCategory get category => throw _privateConstructorUsedError;
  ComplaintStatus get status => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String? get assignedToName => throw _privateConstructorUsedError;
  List<ComplaintUpdate> get updates => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ComplaintCopyWith<Complaint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ComplaintCopyWith<$Res> {
  factory $ComplaintCopyWith(Complaint value, $Res Function(Complaint) then) =
      _$ComplaintCopyWithImpl<$Res, Complaint>;
  @useResult
  $Res call(
      {String id,
      String studentId,
      String? studentName,
      String? roomNumber,
      ComplaintCategory category,
      ComplaintStatus status,
      String description,
      String? photoUrl,
      String? assignedToName,
      List<ComplaintUpdate> updates,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ComplaintCopyWithImpl<$Res, $Val extends Complaint>
    implements $ComplaintCopyWith<$Res> {
  _$ComplaintCopyWithImpl(this._value, this._then);

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
    Object? category = null,
    Object? status = null,
    Object? description = null,
    Object? photoUrl = freezed,
    Object? assignedToName = freezed,
    Object? updates = null,
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
      roomNumber: freezed == roomNumber
          ? _value.roomNumber
          : roomNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ComplaintCategory,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ComplaintStatus,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedToName: freezed == assignedToName
          ? _value.assignedToName
          : assignedToName // ignore: cast_nullable_to_non_nullable
              as String?,
      updates: null == updates
          ? _value.updates
          : updates // ignore: cast_nullable_to_non_nullable
              as List<ComplaintUpdate>,
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
abstract class _$$ComplaintImplCopyWith<$Res>
    implements $ComplaintCopyWith<$Res> {
  factory _$$ComplaintImplCopyWith(
          _$ComplaintImpl value, $Res Function(_$ComplaintImpl) then) =
      __$$ComplaintImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String studentId,
      String? studentName,
      String? roomNumber,
      ComplaintCategory category,
      ComplaintStatus status,
      String description,
      String? photoUrl,
      String? assignedToName,
      List<ComplaintUpdate> updates,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ComplaintImplCopyWithImpl<$Res>
    extends _$ComplaintCopyWithImpl<$Res, _$ComplaintImpl>
    implements _$$ComplaintImplCopyWith<$Res> {
  __$$ComplaintImplCopyWithImpl(
      _$ComplaintImpl _value, $Res Function(_$ComplaintImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? studentName = freezed,
    Object? roomNumber = freezed,
    Object? category = null,
    Object? status = null,
    Object? description = null,
    Object? photoUrl = freezed,
    Object? assignedToName = freezed,
    Object? updates = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ComplaintImpl(
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
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ComplaintCategory,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ComplaintStatus,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedToName: freezed == assignedToName
          ? _value.assignedToName
          : assignedToName // ignore: cast_nullable_to_non_nullable
              as String?,
      updates: null == updates
          ? _value._updates
          : updates // ignore: cast_nullable_to_non_nullable
              as List<ComplaintUpdate>,
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
class _$ComplaintImpl implements _Complaint {
  const _$ComplaintImpl(
      {required this.id,
      required this.studentId,
      this.studentName,
      this.roomNumber,
      required this.category,
      required this.status,
      required this.description,
      this.photoUrl,
      this.assignedToName,
      final List<ComplaintUpdate> updates = const [],
      this.createdAt,
      this.updatedAt})
      : _updates = updates;

  factory _$ComplaintImpl.fromJson(Map<String, dynamic> json) =>
      _$$ComplaintImplFromJson(json);

  @override
  final String id;
  @override
  final String studentId;
  @override
  final String? studentName;
  @override
  final String? roomNumber;
  @override
  final ComplaintCategory category;
  @override
  final ComplaintStatus status;
  @override
  final String description;
  @override
  final String? photoUrl;
  @override
  final String? assignedToName;
  final List<ComplaintUpdate> _updates;
  @override
  @JsonKey()
  List<ComplaintUpdate> get updates {
    if (_updates is EqualUnmodifiableListView) return _updates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_updates);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Complaint(id: $id, studentId: $studentId, studentName: $studentName, roomNumber: $roomNumber, category: $category, status: $status, description: $description, photoUrl: $photoUrl, assignedToName: $assignedToName, updates: $updates, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ComplaintImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.studentName, studentName) ||
                other.studentName == studentName) &&
            (identical(other.roomNumber, roomNumber) ||
                other.roomNumber == roomNumber) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.assignedToName, assignedToName) ||
                other.assignedToName == assignedToName) &&
            const DeepCollectionEquality().equals(other._updates, _updates) &&
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
      roomNumber,
      category,
      status,
      description,
      photoUrl,
      assignedToName,
      const DeepCollectionEquality().hash(_updates),
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ComplaintImplCopyWith<_$ComplaintImpl> get copyWith =>
      __$$ComplaintImplCopyWithImpl<_$ComplaintImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ComplaintImplToJson(
      this,
    );
  }
}

abstract class _Complaint implements Complaint {
  const factory _Complaint(
      {required final String id,
      required final String studentId,
      final String? studentName,
      final String? roomNumber,
      required final ComplaintCategory category,
      required final ComplaintStatus status,
      required final String description,
      final String? photoUrl,
      final String? assignedToName,
      final List<ComplaintUpdate> updates,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ComplaintImpl;

  factory _Complaint.fromJson(Map<String, dynamic> json) =
      _$ComplaintImpl.fromJson;

  @override
  String get id;
  @override
  String get studentId;
  @override
  String? get studentName;
  @override
  String? get roomNumber;
  @override
  ComplaintCategory get category;
  @override
  ComplaintStatus get status;
  @override
  String get description;
  @override
  String? get photoUrl;
  @override
  String? get assignedToName;
  @override
  List<ComplaintUpdate> get updates;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ComplaintImplCopyWith<_$ComplaintImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
