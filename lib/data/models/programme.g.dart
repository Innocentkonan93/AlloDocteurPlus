// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'programme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Programme _$ProgrammeFromJson(Map<String, dynamic> json) {
  return Programme()
    ..idProgrammePharmacie = json['id_programme_pharmacie'] as String?
    ..idPharmacie = json['id_pharmacie'] as String?
    ..debutGarde = json['debut_garde'] as String?
    ..finGarde = json['fin_garde'] as String?
    ..statut = json['statut'] as String?
    ..createdAt = json['created_at'] as String?;
}

Map<String, dynamic> _$ProgrammeToJson(Programme instance) => <String, dynamic>{
      'id_programme_pharmacie': instance.idProgrammePharmacie,
      'id_pharmacie': instance.idPharmacie,
      'debut_garde': instance.debutGarde,
      'fin_garde': instance.finGarde,
      'statut': instance.statut,
      'created_at': instance.createdAt,
    };
