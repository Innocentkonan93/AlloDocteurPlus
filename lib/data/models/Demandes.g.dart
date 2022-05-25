// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Demandes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDemande _$UserDemandeFromJson(Map<String, dynamic> json) {
  return UserDemande()
    ..idDemande = json['id_demande'] as String?
    ..typeDemande = json['type_demande'] as String?
    ..description = json['description'] as String?
    ..departementService = json['departement_service'] as String?
    ..emailUtilisateur = json['email_utilisateur'] as String?
    ..statusDemande = json['status_demande'] as String?
    ..emailPraticien = json['email_praticien'] as String?
    ..tarifDemande = json['tarif_demande'] as String?
    ..fichierDemande = json['fichier_demande'] as String?
    ..dateDemande = json['date_demande'] as String?;
}

Map<String, dynamic> _$UserDemandeToJson(UserDemande instance) =>
    <String, dynamic>{
      'id_demande': instance.idDemande,
      'type_demande': instance.typeDemande,
      'description': instance.description,
      'departement_service': instance.departementService,
      'email_utilisateur': instance.emailUtilisateur,
      'status_demande': instance.statusDemande,
      'email_praticien': instance.emailPraticien,
      'tarif_demande': instance.tarifDemande,
      'fichier_demande': instance.fichierDemande,
      'date_demande': instance.dateDemande,
    };
