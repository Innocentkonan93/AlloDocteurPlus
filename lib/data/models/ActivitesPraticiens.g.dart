// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ActivitesPraticiens.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivitesPraticiens _$ActivitesPraticiensFromJson(Map<String, dynamic> json) {
  return ActivitesPraticiens()
    ..idActivites = json['id_activites'] as String?
    ..activite = json['activite'] as String?
    ..nomPraticien = json['nom_praticien'] as String ?
    ..specialitePraticien = json['specialite_praticien'] as String ?
    ..emailPraticien = json['email_praticien'] as String?
    ..nomDocument = json['nom_document'] as String ?
    ..fileName = json['file_name'] as String?
    ..dateActivite = json['date_activite'] as String?;
}

Map<String, dynamic> _$ActivitesPraticiensToJson(ActivitesPraticiens instance) =>
    <String, dynamic>{
      'id_activites': instance.idActivites,
      'activite': instance.activite,
      'nom_praticien': instance.nomPraticien,
      'specialite_praticien': instance.specialitePraticien,
      'email_praticien': instance.emailPraticien,
      'nom_document' : instance.nomDocument,
      'file_name': instance.fileName,
      'date_activite': instance.dateActivite,
    };
