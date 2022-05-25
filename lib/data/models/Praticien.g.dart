// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Praticien.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Praticien _$PraticienFromJson(Map<String, dynamic> json) {
  return Praticien()
    ..idPraticien = json['id_praticien'] as String?
    ..nomPraticien = json['nom_praticien'] as String?
    ..emailPraticien = json['email_praticien'] as String?
    ..numeroPraticien = json['numero_praticien'] as String?
    ..mdpPraticien = json['mdp_praticien'] as String?
    ..adressePraticien = json['adresse_praticien'] as String?
    ..imagePraticien = json['image_praticien'] as String?
    ..signaturePraticien = json['signature_praticien'] as String ?
    ..specialitePraticien = json['specialite_praticien'] as String?
    ..statutPraticien = json['statut_praticien'] as String?
    ..online = json['online'] as String?
    ..verifProf = json['verif_prof'] as String?;
}

Map<String, dynamic> _$PraticienToJson(Praticien instance) => <String, dynamic>{
      'id_praticien': instance.idPraticien,
      'nom_praticien': instance.nomPraticien,
      'email_praticien': instance.emailPraticien,
      'numero_praticien': instance.numeroPraticien,
      'mdp_praticien': instance.mdpPraticien,
      'adresse_praticien': instance.adressePraticien,
      'image_praticien': instance.imagePraticien,
      'signature_praticien' : instance.signaturePraticien,
      'specialite_praticien': instance.specialitePraticien,
      'statut_praticien': instance.statutPraticien,
      'online': instance.online,
      'verif_prof': instance.verifProf,
    };
