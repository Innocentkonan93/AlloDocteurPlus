import 'package:json_annotation/json_annotation.dart';

part 'Departement.g.dart';

@JsonSerializable()
class Departement {
  @JsonKey(name: "id_departement_service")
  String? idDepartementService;

  @JsonKey(name: "departement_service")
  String? departementService;

  @JsonKey(name: "departement_image")
  String? departementImage;

  // the constructor

  Departement();

  factory Departement.fromJson(Map<String, dynamic> json) =>
      _$DepartementFromJson(json);
  Map<String, dynamic> toJson() => _$DepartementToJson(this);
}
