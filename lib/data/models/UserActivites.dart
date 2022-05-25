import 'package:json_annotation/json_annotation.dart';

part 'UserActivites.g.dart';

@JsonSerializable()
class UserActivites {
  // create the keys for the model
  @JsonKey(name: "id_activite")
  String? idActivite;

  @JsonKey(name: "activite")
  String? activite;

  @JsonKey(name: "acteur_activite")
  String? acteurActivite;

  @JsonKey(name: "date_activite")
  String? dateActivite;

  // the constructor

  UserActivites();

  factory UserActivites.fromJson(Map<String, dynamic> json) =>
      _$UserActivitesFromJson(json);
  Map<String, dynamic> toJson() => _$UserActivitesToJson(this);
}
