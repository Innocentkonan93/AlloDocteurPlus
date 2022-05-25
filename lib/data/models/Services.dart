import 'package:json_annotation/json_annotation.dart';

part 'Services.g.dart';

@JsonSerializable()
class Services {
  // create the keys for the model

  @JsonKey(name: "id_service")
  String? idService;

  @JsonKey(name: "nom_service")
  String? nomService;

  @JsonKey(name: "description_service")
  String? descriptionService;

  @JsonKey(name: "prix_service")
  String? prixService;

  @JsonKey(name: "departement_service")
  String? departementService;

  Services();

  factory Services.fromJson(Map<String, dynamic> json) =>
      _$ServicesFromJson(json);
  Map<String, dynamic> toJson() => _$ServicesToJson(this);
}
