import 'package:json_annotation/json_annotation.dart';

part 'programme.g.dart';

@JsonSerializable()
class Programme {
  @JsonKey(name: "id_programme_pharmacie")
  String? idProgrammePharmacie;

  @JsonKey(name: "id_Pharmacie")
  String? idPharmacie;

 @JsonKey(name: "debut_garde")
  String? debutGarde;

@JsonKey(name: "fin_garde")
  String? finGarde;

  @JsonKey(name: "statut")
  String? statut;

  @JsonKey(name: "created_at")
  String? createdAt;
  // the constructor

  Programme();

  factory Programme.fromJson(Map<String, dynamic> json) =>
      _$ProgrammeFromJson(json);
  Map<String, dynamic> toJson() => _$ProgrammeToJson(this);
}
