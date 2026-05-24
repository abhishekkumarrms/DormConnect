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
      sentByName: json['sent_by_name'] as String?,
      hostelId: json['hostel_id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$BroadcastImplToJson(_$BroadcastImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'title': instance.title,
    'body': instance.body,
    'category': _$BroadcastCategoryEnumMap[instance.category]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('sent_by_name', instance.sentByName);
  writeNotNull('hostel_id', instance.hostelId);
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  return val;
}

const _$BroadcastCategoryEnumMap = {
  BroadcastCategory.general: 'GENERAL',
  BroadcastCategory.important: 'IMPORTANT',
  BroadcastCategory.mess: 'MESS',
  BroadcastCategory.holiday: 'HOLIDAY',
  BroadcastCategory.event: 'EVENT',
};

_$NoticeImpl _$$NoticeImplFromJson(Map<String, dynamic> json) => _$NoticeImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      category: json['category'] as String?,
      isPinned: json['is_pinned'] as bool? ?? false,
      postedByName: json['posted_by_name'] as String?,
      hostelId: json['hostel_id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$NoticeImplToJson(_$NoticeImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'title': instance.title,
    'body': instance.body,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('category', instance.category);
  val['is_pinned'] = instance.isPinned;
  writeNotNull('posted_by_name', instance.postedByName);
  writeNotNull('hostel_id', instance.hostelId);
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  return val;
}
