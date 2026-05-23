// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hostel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HostelImpl _$$HostelImplFromJson(Map<String, dynamic> json) => _$HostelImpl(
      id: json['id'] as String,
      institutionId: json['institutionId'] as String,
      name: json['name'] as String,
      gender: json['gender'] as String?,
      totalRooms: (json['totalRooms'] as num?)?.toInt(),
      totalCapacity: (json['totalCapacity'] as num?)?.toInt(),
      currentOccupancy: (json['currentOccupancy'] as num?)?.toInt(),
      healthScore: (json['healthScore'] as num?)?.toDouble(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$HostelImplToJson(_$HostelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'institutionId': instance.institutionId,
      'name': instance.name,
      'gender': instance.gender,
      'totalRooms': instance.totalRooms,
      'totalCapacity': instance.totalCapacity,
      'currentOccupancy': instance.currentOccupancy,
      'healthScore': instance.healthScore,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$InstitutionImpl _$$InstitutionImplFromJson(Map<String, dynamic> json) =>
    _$InstitutionImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      logoUrl: json['logoUrl'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$InstitutionImplToJson(_$InstitutionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'logoUrl': instance.logoUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
