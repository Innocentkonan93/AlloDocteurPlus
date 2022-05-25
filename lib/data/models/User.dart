import 'package:json_annotation/json_annotation.dart';

part 'User.g.dart';

@JsonSerializable()
class User {
  // create the keys for the model
  @JsonKey(name: "id_utilisateur")
  String? idUtilisateur;

  @JsonKey(name: "nom_utilisateur")
  String? nomUtilisateur;

  @JsonKey(name: "email_utilisateur")
  String? emailUtilisateur;

  @JsonKey(name: "numero_utilisateur")
  String? numeroUtilisateur;

  @JsonKey(name: "mdp_utilisateur")
  String? mdpUtilisateur;

  @JsonKey(name: "age_utilisateur")
  String? ageUtilisateur;

  @JsonKey(name: "taille_utilisateur")
  String? tailleUtilisateur;

  @JsonKey(name: "poids_utilisateur")
  String? poidsUtilisateur;

  @JsonKey(name: "gs_utilisateur")
  String? gsUtilisateur;

  @JsonKey(name: "dossier_utilisateur")
  String? dossierUtilisateur;

  @JsonKey(name: "image_utilisateur")
  String? imageUtilisateur;

  @JsonKey(name: "adresse_utilisateur")
  String? adresseUtilisateur;

  

  @JsonKey(name: "status")
  String? status;

  @JsonKey(name: "pin_utilisateur")
  String? pinUtilisateur;

  @JsonKey(name: "created_at")
  String? createdAt;

  // the constructor

  User();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
