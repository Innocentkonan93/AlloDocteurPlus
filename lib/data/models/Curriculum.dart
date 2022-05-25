import 'package:json_annotation/json_annotation.dart';

part 'Curriculums.g.dart';

@JsonSerializable()
class Curriculums {
  // create the keys for the model

  @JsonKey(name: "id_curriculum")
  String? idCurriculum;

  @JsonKey(name: "id_praticien")
  String? idPraticien;

  @JsonKey(name: "formation")
  String? formation;

  @JsonKey(name: "lieu_diplome")
  String? lieuDiplome;

  @JsonKey(name: "date_diplome")
  String? dateDiplome;

  @JsonKey(name: "date_enrg")
  String? dateEnrg;

  // the constructor
  Curriculums();

  factory Curriculums.fromJson(Map<String, dynamic> json) =>
      _$CurriculumsFromJson(json);
  Map<String, dynamic> toJson() => _$CurriculumsToJson(this);
}
