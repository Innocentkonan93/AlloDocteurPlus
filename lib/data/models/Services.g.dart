// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Services.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Services _$ServicesFromJson(Map<String, dynamic> json) {
  return Services()
    ..idService = json['id_service'] as String?
    ..nomService = json['nom_service'] as String?
    ..descriptionService = json['description_service'] as String?
    ..prixService = json['prix_service'] as String?
    ..departementService = json['departement_service'] as String?;
}

Map<String, dynamic> _$ServicesToJson(Services instance) => <String, dynamic>{
      'id_service': instance.idService,
      'nom_service': instance.nomService,
      'description_service': instance.descriptionService,
      'prix_service': instance.prixService,
      'departement_service': instance.departementService,
    };
