import 'package:json_annotation/json_annotation.dart';

part 'Pharmacies.g.dart';

@JsonSerializable()
class Pharmacie {
  @JsonKey(name: "id_pharmacie")
  String? idPharmacie;

  @JsonKey(name: "nom_pharmacie")
  String? nomPharmacie;

  @JsonKey(name: "pays_pharmacie")
  String? paysPharmacie;

  @JsonKey(name: "ville_pharmacie")
  String? villePharmacie;
  
  @JsonKey(name: "quartier_pharmacie")
  String? quartierPharmacie;

  @JsonKey(name: "numero_pharmacie")
  String? numeroPharmacie;

  @JsonKey(name: "localisation_pharmacie")
  String? localisationPharmacie;

  @JsonKey(name: "adresse_pharmacie")
  String? adressePharmacie;

  @JsonKey(name: "image_url_pharmacie")
  String? imageUrlPharmacie;

  @JsonKey(name: "horaire_pharmacie")
  String? horairePharmacie;

  @JsonKey(name: "statut_pharmacie")
  String? statutPharmacie;

  @JsonKey(name: "id_pharmacien")
  String? idPharmacien;

  @JsonKey(name: "nom_pharmacien")
  String? nomPharmacien;

 @JsonKey(name: "date_inscription")
  String? dateInscription;
  // the constructor

  Pharmacie();

  factory Pharmacie.fromJson(Map<String, dynamic> json) =>
      _$PharmacieFromJson(json);
  Map<String, dynamic> toJson() => _$PharmacieToJson(this);
}
