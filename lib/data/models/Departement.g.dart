// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Departement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Departement _$DepartementFromJson(Map<String, dynamic> json) {
  return Departement()
    ..idDepartementService = json['id_departement_service'] as String?
    ..departementService = json['departement_service'] as String?
    ..departementImage = json['departement_image'] as String?;
}

Map<String, dynamic> _$DepartementToJson(Departement instance) =>
    <String, dynamic>{
      'id_departement_service': instance.idDepartementService,
      'departement_service': instance.departementService,
      'departement_image' : instance.departementImage
    };
