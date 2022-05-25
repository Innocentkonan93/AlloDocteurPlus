// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..idUtilisateur = json['id_utilisateur'] as String?
    ..nomUtilisateur = json['nom_utilisateur'] as String?
    ..emailUtilisateur = json['email_utilisateur'] as String?
    ..numeroUtilisateur = json['numero_utilisateur'] as String?
    ..mdpUtilisateur = json['mdp_utilisateur'] as String?
    ..ageUtilisateur = json['age_utilisateur'] as String?
    ..tailleUtilisateur = json['taille_utilisateur'] as String?
    ..poidsUtilisateur = json['poids_utilisateur'] as String?
    ..gsUtilisateur = json['gs_utilisateur'] as String?
    ..dossierUtilisateur = json['dossier_utilisateur'] as String?
    ..imageUtilisateur = json['image_utilisateur'] as String?
    ..adresseUtilisateur = json['adresse_utilisateur'] as String?
    ..status = json['status'] as String?
    ..pinUtilisateur = json['pin_utilisateur'] as String ?
    ..createdAt = json['created_at'] as String?;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id_utilisateur': instance.idUtilisateur,
      'nom_utilisateur': instance.nomUtilisateur,
      'email_utilisateur': instance.emailUtilisateur,
      'numero_utilisateur': instance.numeroUtilisateur,
      'mdp_utilisateur': instance.mdpUtilisateur,
      'age_utilisateur': instance.ageUtilisateur,
      'taille_utilisateur': instance.tailleUtilisateur,
      'poids_utilisateur': instance.poidsUtilisateur,
      'gs_utilisateur': instance.gsUtilisateur,
      'dossier_utilisateur': instance.dossierUtilisateur,
      'image_utilisateur': instance.imageUtilisateur,
      'adresse_utilisateur': instance.adresseUtilisateur,
      'status': instance.status,
      'pin_utilisateur' : instance.pinUtilisateur,
      'created_at': instance.createdAt,
    };
