// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'broadcast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BroadcastImpl _$$BroadcastImplFromJson(Map<String, dynamic> json) =>
    _$BroadcastImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      category: $enumDecode(_$BroadcastCategoryEnumMap, json['category']),
      sentByName: json['sentByName'] as String,
      hostelId: json['hostelId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$BroadcastImplToJson(_$BroadcastImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'category': _$BroadcastCategoryEnumMap[instance.category]!,
      'sentByName': instance.sentByName,
      'hostelId': instance.hostelId,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$BroadcastCategoryEnumMap = {
  BroadcastCategory.general: 'general',
  BroadcastCategory.important: 'important',
  BroadcastCategory.mess: 'mess',
  BroadcastCategory.holiday: 'holiday',
  BroadcastCategory.event: 'event',
};

_$NoticeImpl _$$NoticeImplFromJson(Map<String, dynamic> json) => _$NoticeImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      category: json['category'] as String?,
      isPinned: json['isPinned'] as bool? ?? false,
      postedByName: json['postedByName'] as String,
      hostelId: json['hostelId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$NoticeImplToJson(_$NoticeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'category': instance.category,
      'isPinned': instance.isPinned,
      'postedByName': instance.postedByName,
      'hostelId': instance.hostelId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
