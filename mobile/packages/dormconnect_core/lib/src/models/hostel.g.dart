// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hostel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HostelImpl _$$HostelImplFromJson(Map<String, dynamic> json) => _$HostelImpl(
      id: json['id'] as String,
      institutionId: json['institution_id'] as String,
      name: json['name'] as String,
      gender: json['gender'] as String?,
      totalRooms: (json['total_rooms'] as num?)?.toInt(),
      totalCapacity: (json['total_capacity'] as num?)?.toInt(),
      currentOccupancy: (json['current_occupancy'] as num?)?.toInt(),
      healthScore: (json['health_score'] as num?)?.toDouble(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$HostelImplToJson(_$HostelImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'institution_id': instance.institutionId,
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('gender', instance.gender);
  writeNotNull('total_rooms', instance.totalRooms);
  writeNotNull('total_capacity', instance.totalCapacity);
  writeNotNull('current_occupancy', instance.currentOccupancy);
  writeNotNull('health_score', instance.healthScore);
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  return val;
}

_$InstitutionImpl _$$InstitutionImplFromJson(Map<String, dynamic> json) =>
    _$InstitutionImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      logoUrl: json['logo_url'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$InstitutionImplToJson(_$InstitutionImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('address', instance.address);
  writeNotNull('logo_url', instance.logoUrl);
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  return val;
}
