// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ServicesType.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServicesType _$ServicesTypeFromJson(Map<String, dynamic> json) {
  return ServicesType()
    ..idServiceType = json['id_service_type'] as String?
    ..nomService = json['nom_service'] as String?;
}

Map<String, dynamic> _$ServicesTypeToJson(ServicesType instance) =>
    <String, dynamic>{
      'id_service_type': instance.idServiceType,
      'nom_service': instance.nomService,
    };
