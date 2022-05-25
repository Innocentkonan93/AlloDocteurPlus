import 'package:json_annotation/json_annotation.dart';

part 'Consultations.g.dart';

@JsonSerializable()
class Consultations {
  // create the keys for the model

  @JsonKey(name: "id_consultation")
  String? idConsultation;

  @JsonKey(name: "email_patient")
  String? emailPatient;

  @JsonKey(name: "email_praticien")
  String? emailPraticien;

  @JsonKey(name: "statut_consultation")
  String? statutConsultation;

  @JsonKey(name: "ordonnance_consultation")
  String? ordonnanceConsultation;

  @JsonKey(name: "fichier_consultation")
  String? fichierConsultation;

  @JsonKey(name: "id_demande")
  String? idDemande;

  @JsonKey(name: "date_modification")
  String? dateModification;

  @JsonKey(name: "date_consultation")
  String? dateConsultation;

  // the constructor

  Consultations();

  factory Consultations.fromJson(Map<String, dynamic> json) =>
      _$ConsultationsFromJson(json);
  Map<String, dynamic> toJson() => _$ConsultationsToJson(this);
}
