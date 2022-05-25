// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserActivites.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserActivites _$UserActivitesFromJson(Map<String, dynamic> json) {
  return UserActivites()
    ..idActivite = json['id_activite'] as String?
    ..activite = json['activite'] as String?
    ..acteurActivite = json['acteur_activite'] as String?
    ..dateActivite = json['date_activite'] as String?;
}

Map<String, dynamic> _$UserActivitesToJson(UserActivites instance) =>
    <String, dynamic>{
      'id_activite': instance.idActivite,
      'activite': instance.activite,
      'acteur_activite': instance.acteurActivite,
      'date_activite': instance.dateActivite,
    };
