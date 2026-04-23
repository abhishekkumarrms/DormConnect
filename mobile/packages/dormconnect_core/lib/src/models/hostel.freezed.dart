// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hostel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Hostel _$HostelFromJson(Map<String, dynamic> json) {
  return _Hostel.fromJson(json);
}

/// @nodoc
mixin _$Hostel {
  String get id => throw _privateConstructorUsedError;
  String get institutionId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  int? get totalRooms => throw _privateConstructorUsedError;
  int? get totalCapacity => throw _privateConstructorUsedError;
  int? get currentOccupancy => throw _privateConstructorUsedError;
  double? get healthScore => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HostelCopyWith<Hostel> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HostelCopyWith<$Res> {
  factory $HostelCopyWith(Hostel value, $Res Function(Hostel) then) =
      _$HostelCopyWithImpl<$Res, Hostel>;
  @useResult
  $Res call(
      {String id,
      String institutionId,
      String name,
      String? gender,
      int? totalRooms,
      int? totalCapacity,
      int? currentOccupancy,
      double? healthScore,
      DateTime? createdAt});
}

/// @nodoc
class _$HostelCopyWithImpl<$Res, $Val extends Hostel>
    implements $HostelCopyWith<$Res> {
  _$HostelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? institutionId = null,
    Object? name = null,
    Object? gender = freezed,
    Object? totalRooms = freezed,
    Object? totalCapacity = freezed,
    Object? currentOccupancy = freezed,
    Object? healthScore = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      institutionId: null == institutionId
          ? _value.institutionId
          : institutionId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      totalRooms: freezed == totalRooms
          ? _value.totalRooms
          : totalRooms // ignore: cast_nullable_to_non_nullable
              as int?,
      totalCapacity: freezed == totalCapacity
          ? _value.totalCapacity
          : totalCapacity // ignore: cast_nullable_to_non_nullable
              as int?,
      currentOccupancy: freezed == currentOccupancy
          ? _value.currentOccupancy
          : currentOccupancy // ignore: cast_nullable_to_non_nullable
              as int?,
      healthScore: freezed == healthScore
          ? _value.healthScore
          : healthScore // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HostelImplCopyWith<$Res> implements $HostelCopyWith<$Res> {
  factory _$$HostelImplCopyWith(
          _$HostelImpl value, $Res Function(_$HostelImpl) then) =
      __$$HostelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String institutionId,
      String name,
      String? gender,
      int? totalRooms,
      int? totalCapacity,
      int? currentOccupancy,
      double? healthScore,
      DateTime? createdAt});
}

/// @nodoc
class __$$HostelImplCopyWithImpl<$Res>
    extends _$HostelCopyWithImpl<$Res, _$HostelImpl>
    implements _$$HostelImplCopyWith<$Res> {
  __$$HostelImplCopyWithImpl(
      _$HostelImpl _value, $Res Function(_$HostelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? institutionId = null,
    Object? name = null,
    Object? gender = freezed,
    Object? totalRooms = freezed,
    Object? totalCapacity = freezed,
    Object? currentOccupancy = freezed,
    Object? healthScore = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$HostelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      institutionId: null == institutionId
          ? _value.institutionId
          : institutionId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      totalRooms: freezed == totalRooms
          ? _value.totalRooms
          : totalRooms // ignore: cast_nullable_to_non_nullable
              as int?,
      totalCapacity: freezed == totalCapacity
          ? _value.totalCapacity
          : totalCapacity // ignore: cast_nullable_to_non_nullable
              as int?,
      currentOccupancy: freezed == currentOccupancy
          ? _value.currentOccupancy
          : currentOccupancy // ignore: cast_nullable_to_non_nullable
              as int?,
      healthScore: freezed == healthScore
          ? _value.healthScore
          : healthScore // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HostelImpl implements _Hostel {
  const _$HostelImpl(
      {required this.id,
      required this.institutionId,
      required this.name,
      this.gender,
      this.totalRooms,
      this.totalCapacity,
      this.currentOccupancy,
      this.healthScore,
      this.createdAt});

  factory _$HostelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HostelImplFromJson(json);

  @override
  final String id;
  @override
  final String institutionId;
  @override
  final String name;
  @override
  final String? gender;
  @override
  final int? totalRooms;
  @override
  final int? totalCapacity;
  @override
  final int? currentOccupancy;
  @override
  final double? healthScore;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Hostel(id: $id, institutionId: $institutionId, name: $name, gender: $gender, totalRooms: $totalRooms, totalCapacity: $totalCapacity, currentOccupancy: $currentOccupancy, healthScore: $healthScore, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HostelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.institutionId, institutionId) ||
                other.institutionId == institutionId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.totalRooms, totalRooms) ||
                other.totalRooms == totalRooms) &&
            (identical(other.totalCapacity, totalCapacity) ||
                other.totalCapacity == totalCapacity) &&
            (identical(other.currentOccupancy, currentOccupancy) ||
                other.currentOccupancy == currentOccupancy) &&
            (identical(other.healthScore, healthScore) ||
                other.healthScore == healthScore) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, institutionId, name, gender,
      totalRooms, totalCapacity, currentOccupancy, healthScore, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HostelImplCopyWith<_$HostelImpl> get copyWith =>
      __$$HostelImplCopyWithImpl<_$HostelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HostelImplToJson(
      this,
    );
  }
}

abstract class _Hostel implements Hostel {
  const factory _Hostel(
      {required final String id,
      required final String institutionId,
      required final String name,
      final String? gender,
      final int? totalRooms,
      final int? totalCapacity,
      final int? currentOccupancy,
      final double? healthScore,
      final DateTime? createdAt}) = _$HostelImpl;

  factory _Hostel.fromJson(Map<String, dynamic> json) = _$HostelImpl.fromJson;

  @override
  String get id;
  @override
  String get institutionId;
  @override
  String get name;
  @override
  String? get gender;
  @override
  int? get totalRooms;
  @override
  int? get totalCapacity;
  @override
  int? get currentOccupancy;
  @override
  double? get healthScore;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$HostelImplCopyWith<_$HostelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Institution _$InstitutionFromJson(Map<String, dynamic> json) {
  return _Institution.fromJson(json);
}

/// @nodoc
mixin _$Institution {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InstitutionCopyWith<Institution> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstitutionCopyWith<$Res> {
  factory $InstitutionCopyWith(
          Institution value, $Res Function(Institution) then) =
      _$InstitutionCopyWithImpl<$Res, Institution>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? address,
      String? logoUrl,
      DateTime? createdAt});
}

/// @nodoc
class _$InstitutionCopyWithImpl<$Res, $Val extends Institution>
    implements $InstitutionCopyWith<$Res> {
  _$InstitutionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = freezed,
    Object? logoUrl = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InstitutionImplCopyWith<$Res>
    implements $InstitutionCopyWith<$Res> {
  factory _$$InstitutionImplCopyWith(
          _$InstitutionImpl value, $Res Function(_$InstitutionImpl) then) =
      __$$InstitutionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? address,
      String? logoUrl,
      DateTime? createdAt});
}

/// @nodoc
class __$$InstitutionImplCopyWithImpl<$Res>
    extends _$InstitutionCopyWithImpl<$Res, _$InstitutionImpl>
    implements _$$InstitutionImplCopyWith<$Res> {
  __$$InstitutionImplCopyWithImpl(
      _$InstitutionImpl _value, $Res Function(_$InstitutionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = freezed,
    Object? logoUrl = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$InstitutionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
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
class _$InstitutionImpl implements _Institution {
  const _$InstitutionImpl(
      {required this.id,
      required this.name,
      this.address,
      this.logoUrl,
      this.createdAt});

  factory _$InstitutionImpl.fromJson(Map<String, dynamic> json) =>
      _$$InstitutionImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? address;
  @override
  final String? logoUrl;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Institution(id: $id, name: $name, address: $address, logoUrl: $logoUrl, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstitutionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, address, logoUrl, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InstitutionImplCopyWith<_$InstitutionImpl> get copyWith =>
      __$$InstitutionImplCopyWithImpl<_$InstitutionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InstitutionImplToJson(
      this,
    );
  }
}

abstract class _Institution implements Institution {
  const factory _Institution(
      {required final String id,
      required final String name,
      final String? address,
      final String? logoUrl,
      final DateTime? createdAt}) = _$InstitutionImpl;

  factory _Institution.fromJson(Map<String, dynamic> json) =
      _$InstitutionImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get address;
  @override
  String? get logoUrl;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$InstitutionImplCopyWith<_$InstitutionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
