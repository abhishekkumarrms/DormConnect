// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'maintenance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MaintenanceRequest _$MaintenanceRequestFromJson(Map<String, dynamic> json) {
  return _MaintenanceRequest.fromJson(json);
}

/// @nodoc
mixin _$MaintenanceRequest {
  String get id => throw _privateConstructorUsedError;
  String get hostelId => throw _privateConstructorUsedError;
  String get reportedById => throw _privateConstructorUsedError;
  String? get reportedByName => throw _privateConstructorUsedError;
  String? get roomNumber => throw _privateConstructorUsedError;
  MaintenanceCategory get category => throw _privateConstructorUsedError;
  MaintenanceStatus get status => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get assignedToName => throw _privateConstructorUsedError;
  DateTime? get scheduledAt => throw _privateConstructorUsedError;
  String? get fixedNote => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MaintenanceRequestCopyWith<MaintenanceRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MaintenanceRequestCopyWith<$Res> {
  factory $MaintenanceRequestCopyWith(
          MaintenanceRequest value, $Res Function(MaintenanceRequest) then) =
      _$MaintenanceRequestCopyWithImpl<$Res, MaintenanceRequest>;
  @useResult
  $Res call(
      {String id,
      String hostelId,
      String reportedById,
      String? reportedByName,
      String? roomNumber,
      MaintenanceCategory category,
      MaintenanceStatus status,
      String title,
      String description,
      String? location,
      String? assignedToName,
      DateTime? scheduledAt,
      String? fixedNote,
      DateTime? completedAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$MaintenanceRequestCopyWithImpl<$Res, $Val extends MaintenanceRequest>
    implements $MaintenanceRequestCopyWith<$Res> {
  _$MaintenanceRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hostelId = null,
    Object? reportedById = null,
    Object? reportedByName = freezed,
    Object? roomNumber = freezed,
    Object? category = null,
    Object? status = null,
    Object? title = null,
    Object? description = null,
    Object? location = freezed,
    Object? assignedToName = freezed,
    Object? scheduledAt = freezed,
    Object? fixedNote = freezed,
    Object? completedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      reportedById: null == reportedById
          ? _value.reportedById
          : reportedById // ignore: cast_nullable_to_non_nullable
              as String,
      reportedByName: freezed == reportedByName
          ? _value.reportedByName
          : reportedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      roomNumber: freezed == roomNumber
          ? _value.roomNumber
          : roomNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as MaintenanceCategory,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MaintenanceStatus,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedToName: freezed == assignedToName
          ? _value.assignedToName
          : assignedToName // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduledAt: freezed == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      fixedNote: freezed == fixedNote
          ? _value.fixedNote
          : fixedNote // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
abstract class _$$MaintenanceRequestImplCopyWith<$Res>
    implements $MaintenanceRequestCopyWith<$Res> {
  factory _$$MaintenanceRequestImplCopyWith(_$MaintenanceRequestImpl value,
          $Res Function(_$MaintenanceRequestImpl) then) =
      __$$MaintenanceRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String hostelId,
      String reportedById,
      String? reportedByName,
      String? roomNumber,
      MaintenanceCategory category,
      MaintenanceStatus status,
      String title,
      String description,
      String? location,
      String? assignedToName,
      DateTime? scheduledAt,
      String? fixedNote,
      DateTime? completedAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$MaintenanceRequestImplCopyWithImpl<$Res>
    extends _$MaintenanceRequestCopyWithImpl<$Res, _$MaintenanceRequestImpl>
    implements _$$MaintenanceRequestImplCopyWith<$Res> {
  __$$MaintenanceRequestImplCopyWithImpl(_$MaintenanceRequestImpl _value,
      $Res Function(_$MaintenanceRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hostelId = null,
    Object? reportedById = null,
    Object? reportedByName = freezed,
    Object? roomNumber = freezed,
    Object? category = null,
    Object? status = null,
    Object? title = null,
    Object? description = null,
    Object? location = freezed,
    Object? assignedToName = freezed,
    Object? scheduledAt = freezed,
    Object? fixedNote = freezed,
    Object? completedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$MaintenanceRequestImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      hostelId: null == hostelId
          ? _value.hostelId
          : hostelId // ignore: cast_nullable_to_non_nullable
              as String,
      reportedById: null == reportedById
          ? _value.reportedById
          : reportedById // ignore: cast_nullable_to_non_nullable
              as String,
      reportedByName: freezed == reportedByName
          ? _value.reportedByName
          : reportedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      roomNumber: freezed == roomNumber
          ? _value.roomNumber
          : roomNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as MaintenanceCategory,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MaintenanceStatus,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedToName: freezed == assignedToName
          ? _value.assignedToName
          : assignedToName // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduledAt: freezed == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      fixedNote: freezed == fixedNote
          ? _value.fixedNote
          : fixedNote // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
class _$MaintenanceRequestImpl implements _MaintenanceRequest {
  const _$MaintenanceRequestImpl(
      {required this.id,
      required this.hostelId,
      required this.reportedById,
      this.reportedByName,
      this.roomNumber,
      required this.category,
      required this.status,
      required this.title,
      required this.description,
      this.location,
      this.assignedToName,
      this.scheduledAt,
      this.fixedNote,
      this.completedAt,
      this.createdAt,
      this.updatedAt});

  factory _$MaintenanceRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$MaintenanceRequestImplFromJson(json);

  @override
  final String id;
  @override
  final String hostelId;
  @override
  final String reportedById;
  @override
  final String? reportedByName;
  @override
  final String? roomNumber;
  @override
  final MaintenanceCategory category;
  @override
  final MaintenanceStatus status;
  @override
  final String title;
  @override
  final String description;
  @override
  final String? location;
  @override
  final String? assignedToName;
  @override
  final DateTime? scheduledAt;
  @override
  final String? fixedNote;
  @override
  final DateTime? completedAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'MaintenanceRequest(id: $id, hostelId: $hostelId, reportedById: $reportedById, reportedByName: $reportedByName, roomNumber: $roomNumber, category: $category, status: $status, title: $title, description: $description, location: $location, assignedToName: $assignedToName, scheduledAt: $scheduledAt, fixedNote: $fixedNote, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MaintenanceRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.hostelId, hostelId) ||
                other.hostelId == hostelId) &&
            (identical(other.reportedById, reportedById) ||
                other.reportedById == reportedById) &&
            (identical(other.reportedByName, reportedByName) ||
                other.reportedByName == reportedByName) &&
            (identical(other.roomNumber, roomNumber) ||
                other.roomNumber == roomNumber) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.assignedToName, assignedToName) ||
                other.assignedToName == assignedToName) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.fixedNote, fixedNote) ||
                other.fixedNote == fixedNote) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
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
      hostelId,
      reportedById,
      reportedByName,
      roomNumber,
      category,
      status,
      title,
      description,
      location,
      assignedToName,
      scheduledAt,
      fixedNote,
      completedAt,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MaintenanceRequestImplCopyWith<_$MaintenanceRequestImpl> get copyWith =>
      __$$MaintenanceRequestImplCopyWithImpl<_$MaintenanceRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MaintenanceRequestImplToJson(
      this,
    );
  }
}

abstract class _MaintenanceRequest implements MaintenanceRequest {
  const factory _MaintenanceRequest(
      {required final String id,
      required final String hostelId,
      required final String reportedById,
      final String? reportedByName,
      final String? roomNumber,
      required final MaintenanceCategory category,
      required final MaintenanceStatus status,
      required final String title,
      required final String description,
      final String? location,
      final String? assignedToName,
      final DateTime? scheduledAt,
      final String? fixedNote,
      final DateTime? completedAt,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$MaintenanceRequestImpl;

  factory _MaintenanceRequest.fromJson(Map<String, dynamic> json) =
      _$MaintenanceRequestImpl.fromJson;

  @override
  String get id;
  @override
  String get hostelId;
  @override
  String get reportedById;
  @override
  String? get reportedByName;
  @override
  String? get roomNumber;
  @override
  MaintenanceCategory get category;
  @override
  MaintenanceStatus get status;
  @override
  String get title;
  @override
  String get description;
  @override
  String? get location;
  @override
  String? get assignedToName;
  @override
  DateTime? get scheduledAt;
  @override
  String? get fixedNote;
  @override
  DateTime? get completedAt;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$MaintenanceRequestImplCopyWith<_$MaintenanceRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
