import 'package:json_annotation/json_annotation.dart';

part 'ServicesType.g.dart';

@JsonSerializable()
class ServicesType {
  @JsonKey(name: "id_service_type")
  String? idServiceType;

  @JsonKey(name: "nom_service")
  String? nomService;

  // the constructor

  ServicesType();

  factory ServicesType.fromJson(Map<String, dynamic> json) =>
      _$ServicesTypeFromJson(json);
  Map<String, dynamic> toJson() => _$ServicesTypeToJson(this);
}
