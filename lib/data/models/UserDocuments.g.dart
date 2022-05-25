// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserDocuments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDocuments _$UserDocumentsFromJson(Map<String, dynamic> json) {
  return UserDocuments()
    ..idDocument = json['id_document'] as String?
    ..nomDocument = json['nom_document'] as String?
    ..fileName = json['file_name'] as String?
    ..emailUtilisateur = json['email_utilisateur'] as String?
    ..dateEnreg = json['date_enreg'] as String?;
}

Map<String, dynamic> _$UserDocumentsToJson(UserDocuments instance) =>
    <String, dynamic>{
      'id_document': instance.idDocument,
      'nom_document': instance.nomDocument,
      'file_name': instance.fileName,
      'email_utilisateur': instance.emailUtilisateur,
      'date_enreg': instance.dateEnreg,
    };
