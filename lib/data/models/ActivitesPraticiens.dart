import 'package:json_annotation/json_annotation.dart';

part 'ActivitesPraticiens.g.dart';

@JsonSerializable()
class ActivitesPraticiens {
  // create the keys for the model

  @JsonKey(name: "id_activites")
  String? idActivites;

  @JsonKey(name: "activite")
  String? activite;

  @JsonKey(name: "nom_praticien")
  String? nomPraticien;

  @JsonKey(name: "specialite_praticien")
  String? specialitePraticien;

  @JsonKey(name: "email_praticien")
  String? emailPraticien;

  @JsonKey(name: "nom_document")
  String? nomDocument;

  @JsonKey(name: "file_name")
  String? fileName;

  @JsonKey(name: "date_activite")
  String? dateActivite;

  // the constructor

  ActivitesPraticiens();

  factory ActivitesPraticiens.fromJson(Map<String, dynamic> json) =>
      _$ActivitesPraticiensFromJson(json);
  Map<String, dynamic> toJson() => _$ActivitesPraticiensToJson(this);
}
