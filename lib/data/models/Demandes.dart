import 'package:json_annotation/json_annotation.dart';

part 'Demandes.g.dart';

@JsonSerializable()
class UserDemande {
  // create the keys for the model



  @JsonKey(name: "id_demande")
  String? idDemande;

  @JsonKey(name: "type_demande")
  String? typeDemande;

  @JsonKey(name: "description")
  String? description;

  @JsonKey(name: "departement_service")
  String? departementService;

  @JsonKey(name: "email_utilisateur")
  String? emailUtilisateur;

  @JsonKey(name: "status_demande")
  String? statusDemande;

  @JsonKey(name: "email_praticien")
  String? emailPraticien;

  @JsonKey(name: "tarif_demande")
  String? tarifDemande;

  @JsonKey(name: "fichier_demande")
  String? fichierDemande;

  @JsonKey(name: "date_demande")
  String? dateDemande;



  // the constructor

  UserDemande();

  factory UserDemande.fromJson(Map<String, dynamic> json) => _$UserDemandeFromJson(json);
  Map<String, dynamic> toJson() => _$UserDemandeToJson(this);
}
