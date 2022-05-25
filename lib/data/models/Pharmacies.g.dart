// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Pharmacies.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pharmacie _$PharmacieFromJson(Map<String, dynamic> json) {
  return Pharmacie()
    ..idPharmacie = json['id_pharmacie'] as String?
    ..nomPharmacie = json['nom_pharmacie'] as String?
    ..paysPharmacie = json['pays_pharmacie'] as String?
    ..villePharmacie = json['ville_pharmacie'] as String ?
    ..quartierPharmacie = json['quartier_pharmacie'] as String ?
    ..numeroPharmacie = json['numero_pharmacie'] as String?
    ..localisationPharmacie = json['localisation_pharmacie'] as String?
    ..adressePharmacie = json['adresse_pharmacie'] as String?
    ..imageUrlPharmacie = json['image_url_pharmacie'] as String ?
    ..horairePharmacie = json['horaire_pharmacie'] as String?
    ..statutPharmacie = json['statut_pharmacie'] as String?
    ..idPharmacien = json['id_pharmacien'] as String?
    ..nomPharmacien = json['nom_pharmacien'] as String?
    ..dateInscription = json['date_inscription'] as String?;
}

Map<String, dynamic> _$PharmacieToJson(Pharmacie instance) => <String, dynamic>{
      'id_pharmacie': instance.idPharmacie,
      'nom_pharmacie': instance.nomPharmacie,
      'pays_pharmacie': instance.paysPharmacie,
      'ville_pharmacie': instance.villePharmacie,
      'quartier_pharmacie': instance.quartierPharmacie,
      'numero_pharmacie': instance.numeroPharmacie,
      'localisation_pharmacie': instance.localisationPharmacie,
      'adresse_pharmacie': instance.adressePharmacie,
      'image_url_pharmacie' : instance.imageUrlPharmacie,
      'horaire_pharmacie': instance.horairePharmacie,
      'statut_pharmacie': instance.statutPharmacie,
      'id_pharmacien': instance.idPharmacien,
      'nom_pharmacien': instance.nomPharmacien,
      'date_inscription': instance.dateInscription,
    };
