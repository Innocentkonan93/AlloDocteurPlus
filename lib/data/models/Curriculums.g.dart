// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Curriculum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Curriculums _$CurriculumsFromJson(Map<String, dynamic> json) {
  return Curriculums()
    ..idCurriculum = json['id_curriculum'] as String?
    ..idPraticien = json['id_praticien'] as String?
    ..formation = json['formation'] as String?
    ..dateDiplome = json['date_diplome'] as String?
    ..lieuDiplome = json['lieu_diplome'] as String?
    ..dateEnrg = json['date_enrg'] as String?;
}

Map<String, dynamic> _$CurriculumsToJson(Curriculums instance) =>
    <String, dynamic>{
      'id_curriculum': instance.idCurriculum,
      'id_praticien': instance.idPraticien,
      'formation': instance.formation,
      'date_diplome': instance.dateDiplome,
      'lieu_diplome': instance.lieuDiplome,
      'date_enrg': instance.dateEnrg,
    };
