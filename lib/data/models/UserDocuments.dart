import 'package:json_annotation/json_annotation.dart';

part 'UserDocuments.g.dart';

@JsonSerializable()
class UserDocuments {
  // create the keys for the model
  @JsonKey(name: "id_document")
  String? idDocument;

  @JsonKey(name: "nom_document")
  String? nomDocument;

  @JsonKey(name: "file_name")
  String? fileName;

  @JsonKey(name: "email_utilisateur")
  String? emailUtilisateur;

  @JsonKey(name: "date_enreg")
  String? dateEnreg;

  // the constructor

  UserDocuments();

  factory UserDocuments.fromJson(Map<String, dynamic> json) =>
      _$UserDocumentsFromJson(json);
  Map<String, dynamic> toJson() => _$UserDocumentsToJson(this);
}
