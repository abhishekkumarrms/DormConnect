// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'broadcast.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Broadcast _$BroadcastFromJson(Map<String, dynamic> json) {
  return _Broadcast.fromJson(json);
}

/// @nodoc
mixin _$Broadcast {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  BroadcastCategory get category => throw _privateConstructorUsedError;
  String get sentByName => throw _privateConstructorUsedError;
  String? get hostelId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BroadcastCopyWith<Broadcast> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BroadcastCopyWith<$Res> {
  factory $BroadcastCopyWith(Broadcast value, $Res Function(Broadcast) then) =
      _$BroadcastCopyWithImpl<$Res, Broadcast>;
  @useResult
  $Res call(
      {String id,
      String title,
      String body,
      BroadcastCategory category,
      String sentByName,
      String? hostelId,
      DateTime? createdAt});
}

/// @nodoc
class _$BroadcastCopyWithImpl<$Res, $Val extends Broadcast>
    implements $BroadcastCopyWith<$Res> {
  _$BroadcastCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? category = null,
    Object? sentByName = null,
    Object? hostelId = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as BroadcastCategory,
      sentByName: null == sentByName
          ? _value.sentByName
          : sentByName // ignore: cast_nullable_to_non_nullable
              as String,
      hostelId: freezed == hostelId
          ? _value.hostelId
          : hostelId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BroadcastImplCopyWith<$Res>
    implements $BroadcastCopyWith<$Res> {
  factory _$$BroadcastImplCopyWith(
          _$BroadcastImpl value, $Res Function(_$BroadcastImpl) then) =
      __$$BroadcastImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String body,
      BroadcastCategory category,
      String sentByName,
      String? hostelId,
      DateTime? createdAt});
}

/// @nodoc
class __$$BroadcastImplCopyWithImpl<$Res>
    extends _$BroadcastCopyWithImpl<$Res, _$BroadcastImpl>
    implements _$$BroadcastImplCopyWith<$Res> {
  __$$BroadcastImplCopyWithImpl(
      _$BroadcastImpl _value, $Res Function(_$BroadcastImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? category = null,
    Object? sentByName = null,
    Object? hostelId = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$BroadcastImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as BroadcastCategory,
      sentByName: null == sentByName
          ? _value.sentByName
          : sentByName // ignore: cast_nullable_to_non_nullable
              as String,
      hostelId: freezed == hostelId
          ? _value.hostelId
          : hostelId // ignore: cast_nullable_to_non_nullable
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
class _$BroadcastImpl implements _Broadcast {
  const _$BroadcastImpl(
      {required this.id,
      required this.title,
      required this.body,
      required this.category,
      required this.sentByName,
      this.hostelId,
      this.createdAt});

  factory _$BroadcastImpl.fromJson(Map<String, dynamic> json) =>
      _$$BroadcastImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String body;
  @override
  final BroadcastCategory category;
  @override
  final String sentByName;
  @override
  final String? hostelId;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Broadcast(id: $id, title: $title, body: $body, category: $category, sentByName: $sentByName, hostelId: $hostelId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BroadcastImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.sentByName, sentByName) ||
                other.sentByName == sentByName) &&
            (identical(other.hostelId, hostelId) ||
                other.hostelId == hostelId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, body, category, sentByName, hostelId, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BroadcastImplCopyWith<_$BroadcastImpl> get copyWith =>
      __$$BroadcastImplCopyWithImpl<_$BroadcastImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BroadcastImplToJson(
      this,
    );
  }
}

abstract class _Broadcast implements Broadcast {
  const factory _Broadcast(
      {required final String id,
      required final String title,
      required final String body,
      required final BroadcastCategory category,
      required final String sentByName,
      final String? hostelId,
      final DateTime? createdAt}) = _$BroadcastImpl;

  factory _Broadcast.fromJson(Map<String, dynamic> json) =
      _$BroadcastImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get body;
  @override
  BroadcastCategory get category;
  @override
  String get sentByName;
  @override
  String? get hostelId;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$BroadcastImplCopyWith<_$BroadcastImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Notice _$NoticeFromJson(Map<String, dynamic> json) {
  return _Notice.fromJson(json);
}

/// @nodoc
mixin _$Notice {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  bool get isPinned => throw _privateConstructorUsedError;
  String get postedByName => throw _privateConstructorUsedError;
  String? get hostelId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NoticeCopyWith<Notice> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoticeCopyWith<$Res> {
  factory $NoticeCopyWith(Notice value, $Res Function(Notice) then) =
      _$NoticeCopyWithImpl<$Res, Notice>;
  @useResult
  $Res call(
      {String id,
      String title,
      String body,
      String? category,
      bool isPinned,
      String postedByName,
      String? hostelId,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$NoticeCopyWithImpl<$Res, $Val extends Notice>
    implements $NoticeCopyWith<$Res> {
  _$NoticeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? category = freezed,
    Object? isPinned = null,
    Object? postedByName = null,
    Object? hostelId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      postedByName: null == postedByName
          ? _value.postedByName
          : postedByName // ignore: cast_nullable_to_non_nullable
              as String,
      hostelId: freezed == hostelId
          ? _value.hostelId
          : hostelId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$NoticeImplCopyWith<$Res> implements $NoticeCopyWith<$Res> {
  factory _$$NoticeImplCopyWith(
          _$NoticeImpl value, $Res Function(_$NoticeImpl) then) =
      __$$NoticeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String body,
      String? category,
      bool isPinned,
      String postedByName,
      String? hostelId,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$NoticeImplCopyWithImpl<$Res>
    extends _$NoticeCopyWithImpl<$Res, _$NoticeImpl>
    implements _$$NoticeImplCopyWith<$Res> {
  __$$NoticeImplCopyWithImpl(
      _$NoticeImpl _value, $Res Function(_$NoticeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? category = freezed,
    Object? isPinned = null,
    Object? postedByName = null,
    Object? hostelId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$NoticeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      postedByName: null == postedByName
          ? _value.postedByName
          : postedByName // ignore: cast_nullable_to_non_nullable
              as String,
      hostelId: freezed == hostelId
          ? _value.hostelId
          : hostelId // ignore: cast_nullable_to_non_nullable
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
class _$NoticeImpl implements _Notice {
  const _$NoticeImpl(
      {required this.id,
      required this.title,
      required this.body,
      this.category,
      this.isPinned = false,
      required this.postedByName,
      this.hostelId,
      this.createdAt,
      this.updatedAt});

  factory _$NoticeImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoticeImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String body;
  @override
  final String? category;
  @override
  @JsonKey()
  final bool isPinned;
  @override
  final String postedByName;
  @override
  final String? hostelId;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Notice(id: $id, title: $title, body: $body, category: $category, isPinned: $isPinned, postedByName: $postedByName, hostelId: $hostelId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoticeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned) &&
            (identical(other.postedByName, postedByName) ||
                other.postedByName == postedByName) &&
            (identical(other.hostelId, hostelId) ||
                other.hostelId == hostelId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, body, category,
      isPinned, postedByName, hostelId, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NoticeImplCopyWith<_$NoticeImpl> get copyWith =>
      __$$NoticeImplCopyWithImpl<_$NoticeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoticeImplToJson(
      this,
    );
  }
}

abstract class _Notice implements Notice {
  const factory _Notice(
      {required final String id,
      required final String title,
      required final String body,
      final String? category,
      final bool isPinned,
      required final String postedByName,
      final String? hostelId,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$NoticeImpl;

  factory _Notice.fromJson(Map<String, dynamic> json) = _$NoticeImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get body;
  @override
  String? get category;
  @override
  bool get isPinned;
  @override
  String get postedByName;
  @override
  String? get hostelId;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$NoticeImplCopyWith<_$NoticeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
