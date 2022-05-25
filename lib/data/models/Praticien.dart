import 'package:json_annotation/json_annotation.dart';

part 'Praticien.g.dart';

@JsonSerializable()
class Praticien {
  @JsonKey(name: "id_praticien")
  String? idPraticien;

  @JsonKey(name: "nom_praticien")
  String? nomPraticien;

  @JsonKey(name: "email_praticien")
  String? emailPraticien;

  @JsonKey(name: "numero_praticien")
  String? numeroPraticien;

  @JsonKey(name: "mdp_praticien")
  String? mdpPraticien;

  @JsonKey(name: "adresse_praticien")
  String? adressePraticien;

  @JsonKey(name: "image_praticien")
  String? imagePraticien;

  @JsonKey(name: "signature_praticien")
  String? signaturePraticien;

  @JsonKey(name: "specialite_praticien")
  String? specialitePraticien;

  @JsonKey(name: "statut_praticien")
  String? statutPraticien;

  @JsonKey(name: "online")
  String? online;

  @JsonKey(name: "verif_prof")
  String? verifProf;

  // the constructor

  Praticien();

  factory Praticien.fromJson(Map<String, dynamic> json) =>
      _$PraticienFromJson(json);
  Map<String, dynamic> toJson() => _$PraticienToJson(this);
}
