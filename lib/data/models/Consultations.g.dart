// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Consultations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Consultations _$ConsultationsFromJson(Map<String, dynamic> json) {
  return Consultations()
    ..idConsultation = json['id_consultation'] as String?
    ..emailPatient = json['email_patient'] as String?
    ..emailPraticien = json['email_praticien'] as String?
    ..statutConsultation = json['statut_consultation'] as String?
    ..ordonnanceConsultation = json['ordonnance_consultation'] as String?
    ..fichierConsultation = json['fichier_consultation'] as String?
    ..idDemande = json['id_demande'] as String?
    ..dateModification = json['date_modification'] as String?
    ..dateConsultation = json['date_consultation'] as String?;
}

Map<String, dynamic> _$ConsultationsToJson(Consultations instance) =>
    <String, dynamic>{
      'id_consultation': instance.idConsultation,
      'email_patient': instance.emailPatient,
      'email_praticien': instance.emailPraticien,
      'statut_consultation': instance.statutConsultation,
      'ordonnance_consultation': instance.ordonnanceConsultation,
      'fichier_consultation': instance.fichierConsultation,
      'id_demande': instance.idDemande,
      'date_modification' : instance.dateModification,
      'date_consultation': instance.dateConsultation,
    };
