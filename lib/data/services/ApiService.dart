// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_allo_docteur_plus/data/models/Pharmacies.dart';

import '../models/ActivitesPraticiens.dart';

import '../models/Curriculum.dart';
import 'package:path/path.dart';
import '../models/Consultations.dart';
import '../models/Demandes.dart';
import '../models/Departement.dart';
import '../models/HTTPResponse.dart';
import '../models/Praticien.dart';
import '../models/Services.dart';
import '../models/ServicesType.dart';
import '../models/User.dart';
import '../models/UserActivites.dart';
import '../models/UserDocuments.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../models/programme.dart';

class ApiService {
  // Get current user

  static Future<dynamic> getCurrentUser(String userID) async {
    Uri url = Uri.http(
      'allodocteurplus.com',
      '/api/getSingleUtilisateur.php?id_utilisateur=$userID',
    );

    try {
      var response = await get(url);
      if (response.statusCode == 200) {
        print('Utilisateur récupéré via ${url.path}');
        var body = jsonDecode(response.body);
        List<User> _user = [];
        body.forEach((e) {
          User user = User.fromJson(e);
          _user.add(user);
          // print(body);
        });
        return HTTPResponse(
          true,
          _user,
          responseCode: response.statusCode,
          message: 'utilisateurs récupéreé ${response.body.length}',
        );
      } else {}
    } on SocketException {
      print('Vérifier votre connexion internet');
    } on FormatException {
      print("Mauvaise réponse du server, réessayez");
      return HTTPResponse(false, [],
          message: 'Mauvaise réponse du server, réessayez');
    } catch (e) {
      print("Une erreur est survenue, réessayez");
      return HTTPResponse(false, [],
          message: 'Une erreur est survenue, réessayez');
    }
  }

  // Get current user

  static Future<dynamic> getCurrentPraticien(String praticienID) async {
    Uri url = Uri.http(
      'allodocteurplus.com',
      '/api/getSinglePraticien.php?id_praticien=$praticienID',
    );

    try {
      var response = await get(url);
      if (response.statusCode == 200) {
        print('Praticien récupéré via ${url.path}');
        var body = jsonDecode(response.body);
        List<Praticien> _praticien = [];
        body.forEach((e) {
          Praticien user = Praticien.fromJson(e);
          _praticien.add(user);
          // print(body);
        });
        return HTTPResponse(
          true,
          _praticien,
          responseCode: response.statusCode,
          message: 'Praticien récupéré ${response.body.length}',
        );
      } else {}
    } on SocketException {
      print('Vérifier votre connexion internet');
    } on FormatException {
      print("Mauvaise réponse du server, réessayez");
      return HTTPResponse(false, [],
          message: 'Mauvaise réponse du server, réessayez');
    } catch (e) {
      print("Une erreur est survenue, réessayez");
      return HTTPResponse(false, [],
          message: 'Une erreur est survenue, réessayez');
    }
  }

  // all users
  static Future<HTTPResponse<List<User>>> getAllUtilisateurs() async {
    Uri url = Uri.http('allodocteurplus.com', '/api/getAllUtilisateurs.php');
    // String url = 'http://bad-event.com/pharma/getVille.php';
    try {
      var response = await get(url);
      if (response.statusCode == 200) {
        print('Utilisateur récupéré via ${url.path}');
        var body = jsonDecode(response.body);
        List<User> _user = [];
        body.forEach((e) {
          User user = User.fromJson(e);
          _user.add(user);
        });
        return HTTPResponse(
          true,
          _user,
          responseCode: response.statusCode,
          message: 'utilisateurs récupéreé ${response.body.length}',
        );
      } else {
        print('utilisateur non récupérés');
        return HTTPResponse(
          false,
          [],
          message: 'Erreur du server',
          responseCode: response.statusCode,
        );
      }
    } on SocketException {
      print('Vérifier votre connexion internet');
      return HTTPResponse(false, [],
          message: 'Vérifier votre connexion internet');
    } on FormatException {
      print("Mauvaise réponse du server, réessayez");
      return HTTPResponse(false, [],
          message: 'Mauvaise réponse du server, réessayez');
    } catch (e) {
      print("Une erreur est survenue, réessayez");
      return HTTPResponse(false, [],
          message: 'Une erreur est survenue, réessayez');
    }
  }

  // all demandes
  static Future<HTTPResponse<List<UserDemande>>> getAllDemandes() async {
    Uri url = Uri.http('allodocteurplus.com', '/api/getAllDemandes.php');
    // String url = 'http://bad-event.com/pharma/getVille.php';
    try {
      var response = await get(url);
      if (response.statusCode == 200) {
        print('Les demandes récupérées via ${url.path}');
        var body = jsonDecode(response.body);

        // print(response.body);
        List<UserDemande> _userDemande = [];
        body.forEach((e) {
          UserDemande userDemande = UserDemande.fromJson(e);
          _userDemande.add(userDemande);
        });
        return HTTPResponse(
          true,
          _userDemande,
          responseCode: response.statusCode,
          message: 'demandes récupéreé ${response.body.length}',
        );
      } else {
        print('utilisateur non récupérés');
        return HTTPResponse(
          false,
          [],
          message: 'Erreur du server',
          responseCode: response.statusCode,
        );
      }
    } on SocketException {
      print('Vérifier votre connexion internet');
      return HTTPResponse(false, [],
          message: 'Vérifier votre connexion internet');
    } on FormatException {
      return HTTPResponse(false, [],
          message: 'Mauvaise réponse du server, réessayez');
    } catch (e) {
      return HTTPResponse(false, [],
          message: 'Une erreur est survenue, réessayez');
    }
  }

// all consultations
  static Future<HTTPResponse<List<Consultations>>> getAllConsultations() async {
    Uri url = Uri.http('allodocteurplus.com', '/api/getAllConsultations.php');
    // String url = 'http://bad-event.com/pharma/getVille.php';
    try {
      var response = await get(url);
      if (response.statusCode == 200) {
        print('Les consultations récupérées via ${url.path}');
        var body = jsonDecode(response.body);

        // print(response.body);
        List<Consultations> _userConsultations = [];
        body.forEach((e) {
          Consultations userConsultations = Consultations.fromJson(e);
          _userConsultations.add(userConsultations);
        });
        return HTTPResponse(
          true,
          _userConsultations,
          responseCode: response.statusCode,
          message: 'consultations récupéreé ${response.body.length}',
        );
      } else {
        print('utilisateur non récupérés');
        return HTTPResponse(
          false,
          [],
          message: 'Erreur du server',
          responseCode: response.statusCode,
        );
      }
    } on SocketException {
      print('Vérifier votre connexion internet');
      return HTTPResponse(false, [],
          message: 'Vérifier votre connexion internet');
    } on FormatException {
      return HTTPResponse(false, [],
          message: 'Mauvaise réponse du server, réessayez');
    } catch (e) {
      return HTTPResponse(false, [],
          message: 'Une erreur est survenue, réessayez');
    }
  }

// all activites
  static Future<HTTPResponse<List<UserActivites>>> getAllActivites() async {
    Uri url = Uri.http('allodocteurplus.com', '/api/getAllActivites.php');
    try {
      var response = await get(url);
      if (response.statusCode == 200) {
        print('Les historiques(activites) récupérées via ${url.path}');
        var body = jsonDecode(response.body);

        // print(response.body);
        List<UserActivites> _userActivites = [];
        body.forEach((e) {
          UserActivites userConsultations = UserActivites.fromJson(e);
          _userActivites.add(userConsultations);
        });
        return HTTPResponse(
          true,
          _userActivites,
          responseCode: response.statusCode,
          message:
              'Les historiques(activites) récupéreé ${response.body.length}',
        );
      } else {
        print('Les historiques(activites) non récupérés');
        return HTTPResponse(
          false,
          [],
          message: 'Erreur du server',
          responseCode: response.statusCode,
        );
      }
    } on SocketException {
      print('Vérifier votre connexion internet');
      return HTTPResponse(false, [],
          message: 'Vérifier votre connexion internet');
    } on FormatException {
      return HTTPResponse(false, [],
          message: 'Mauvaise réponse du server, réessayez');
    } catch (e) {
      return HTTPResponse(false, [],
          message: 'Une erreur est survenue, réessayez');
    }
  }

  // all activites praticiens
  static Future<HTTPResponse<List<ActivitesPraticiens>>>
      getAllActivitesPraticiens() async {
    Uri url =
        Uri.http('allodocteurplus.com', '/api/getAllActivitesPraticiens.php');
    try {
      var response = await get(url);
      if (response.statusCode == 200) {
        print('Les prescriptions (praticiens) récupérées via ${url.path}');
        var body = jsonDecode(response.body);

        // print(response.body);
        List<ActivitesPraticiens> _praticiensActivites = [];
        body.forEach((e) {
          ActivitesPraticiens activitesPraticiens =
              ActivitesPraticiens.fromJson(e);
          _praticiensActivites.add(activitesPraticiens);
        });
        return HTTPResponse(
          true,
          _praticiensActivites,
          responseCode: response.statusCode,
          message:
              'Les prescriptions (praticiens) récupéreé ${response.body.length}',
        );
      } else {
        print('Les prescriptions (praticiens) non récupérés');
        return HTTPResponse(
          false,
          [],
          message: 'Erreur du server',
          responseCode: response.statusCode,
        );
      }
    } on SocketException {
      print('Vérifier votre connexion internet');
      return HTTPResponse(false, [],
          message: 'Vérifier votre connexion internet');
    } on FormatException {
      return HTTPResponse(false, [],
          message: 'Mauvaise réponse du server, réessayez');
    } catch (e) {
      return HTTPResponse(false, [],
          message: 'Une erreur est survenue, réessayez');
    }
  }

  // all services type
  static Future<HTTPResponse<List<ServicesType>>> getAllServicesType() async {
    Uri url = Uri.http('allodocteurplus.com', '/api/getAllServicesType.php');

    try {
      var response = await get(url);
      if (response.statusCode == 200) {
        print('Les types de services récupérés via ${url.path}');
        var body = jsonDecode(response.body);

        // print(response.body);
        List<ServicesType> _serviceType = [];
        body.forEach((e) {
          ServicesType servicesType = ServicesType.fromJson(e);
          _serviceType.add(servicesType);
        });
        return HTTPResponse(
          true,
          _serviceType,
          responseCode: response.statusCode,
          message: 'types récupérés ${response.body.length}',
        );
      } else {
        print('type de services non récupérés');
        return HTTPResponse(
          false,
          [],
          message: 'Erreur du server',
          responseCode: response.statusCode,
        );
      }
    } on SocketException {
      print('Vérifier votre connexion internet');
      return HTTPResponse(false, [],
          message: 'Vérifier votre connexion internet');
    } on FormatException {
      return HTTPResponse(false, [],
          message: 'Mauvaise réponse du server, réessayez');
    } catch (e) {
      return HTTPResponse(false, [],
          message: 'Une erreur est survenue, réessayez');
    }
  }

  // all services
  static Future<HTTPResponse<List<Services>>> getAllServices() async {
    Uri url = Uri.http('allodocteurplus.com', '/api/getAllServices.php');

    try {
      var response = await get(url);
      if (response.statusCode == 200) {
        print('Les  services récupérés via ${url.path}');
        var body = jsonDecode(response.body);

        // print(response.body);
        List<Services> _services = [];
        body.forEach((e) {
          Services servicesType = Services.fromJson(e);
          _services.add(servicesType);
        });
        return HTTPResponse(
          true,
          _services,
          responseCode: response.statusCode,
          message: 'services récupérés ${response.body.length}',
        );
      } else {
        print('services non récupérés');
        return HTTPResponse(
          false,
          [],
          message: 'Erreur du server',
          responseCode: response.statusCode,
        );
      }
    } on SocketException {
      print('Vérifier votre connexion internet');
      return HTTPResponse(false, [],
          message: 'Vérifier votre connexion internet');
    } on FormatException {
      return HTTPResponse(false, [],
          message: 'Mauvaise réponse du server, réessayez');
    } catch (e) {
      return HTTPResponse(false, [],
          message: 'Une erreur est survenue, réessayez');
    }
  }
  // Get all departement

  static Future<HTTPResponse<List<Departement>>> getAllDepartement() async {
    Uri url = Uri.http('allodocteurplus.com', '/api/getAllDepartements.php');

    try {
      var response = await get(url);
      if (response.statusCode == 200) {
        print('Les departement récupérés via ${url.path}');
        var body = jsonDecode(response.body);

        // print(response.body);
        List<Departement> _departements = [];
        body.forEach((e) {
          Departement departement = Departement.fromJson(e);
          _departements.add(departement);
        });
        return HTTPResponse(
          true,
          _departements,
          responseCode: response.statusCode,
          message: 'departement récupérés ${response.body.length}',
        );
      } else {
        print('departement de services non récupérés');
        return HTTPResponse(
          false,
          [],
          message: 'Erreur du server',
          responseCode: response.statusCode,
        );
      }
    } on SocketException {
      print('Vérifier votre connexion internet');
      return HTTPResponse(false, [],
          message: 'Vérifier votre connexion internet');
    } on FormatException {
      return HTTPResponse(false, [],
          message: 'Mauvaise réponse du server, réessayez');
    } catch (e) {
      return HTTPResponse(false, [],
          message: 'Une erreur est survenue, réessayez');
    }
  }

  // Get all praticiens

  static Future<HTTPResponse<List<Praticien>>> getAllPraticien() async {
    Uri url = Uri.http('allodocteurplus.com', '/api/getAllPraticiens.php');

    try {
      var response = await get(url);
      if (response.statusCode == 200) {
        print('Les departement récupérés via ${url.path}');
        var body = jsonDecode(response.body);
        // print(response.body);
        List<Praticien> _praticiens = [];
        body.forEach((e) {
          Praticien praticien = Praticien.fromJson(e);
          _praticiens.add(praticien);
        });
        return HTTPResponse(
          true,
          _praticiens,
          responseCode: response.statusCode,
          message: 'departement récupérés ${response.body.length}',
        );
      } else {
        print('departement de services non récupérés');
        return HTTPResponse(
          false,
          [],
          message: 'Erreur du server',
          responseCode: response.statusCode,
        );
      }
    } on SocketException {
      print('Vérifier votre connexion internet');
      return HTTPResponse(false, [],
          message: 'Vérifier votre connexion internet');
    } on FormatException {
      return HTTPResponse(false, [],
          message: 'Mauvaise réponse du server, réessayez');
    } catch (e) {
      return HTTPResponse(false, [],
          message: 'Une erreur est survenue, réessayez');
    }
  }
// get all praticien curriculul

  static Future<HTTPResponse<List<Curriculums>>>
      getAllPraticienCurriculum() async {
    Uri url = Uri.http('allodocteurplus.com', '/api/getAllcurriculum.php');

    try {
      var response = await get(url);
      if (response.statusCode == 200) {
        print('Les curriculums récupérés via ${url.path}');
        var body = jsonDecode(response.body);

        // print(response.body);
        List<Curriculums> _curriculums = [];
        body.forEach((e) {
          Curriculums curriculums = Curriculums.fromJson(e);
          _curriculums.add(curriculums);
        });
        return HTTPResponse(
          true,
          _curriculums,
          responseCode: response.statusCode,
          message: 'curriculum récupérés ${response.body.length}',
        );
      } else {
        print('curriculum non récupérés');
        return HTTPResponse(
          false,
          [],
          message: 'Erreur du server',
          responseCode: response.statusCode,
        );
      }
    } on SocketException {
      print('Vérifier votre connexion internet');
      return HTTPResponse(false, [],
          message: 'Vérifier votre connexion internet');
    } on FormatException {
      return HTTPResponse(false, [],
          message: 'Mauvaise réponse du server, réessayez');
    } catch (e) {
      return HTTPResponse(false, [],
          message: 'Une erreur est survenue, réessayez');
    }
  }

// new demande
  static Future<String> newDemande(
    String? typeDemande,
    String? description,
    String? departementService,
    String? emailUtilisateur,
    String? tarifDemande,
    String? userDoc,
  ) async {
    final url = 'https://allodocteurplus.com/api/newDemande.php';
    var demandeID;
    var bodyData = {
      'type_demande': typeDemande,
      'description': description,
      'departement_service': departementService,
      'email_utilisateur': emailUtilisateur,
      'tarif_demande': tarifDemande,
      'fichier_demande': userDoc,
    };
    try {
      final response = await http.post(Uri.parse(url), body: bodyData);
      var body = jsonDecode(jsonEncode(response.body));
      if (response.statusCode == 200) {
        // print(body);
        demandeID = body;
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    }
    return demandeID;
  }

// accept demande
  static Future<String> acceptDemande(
    String? idDemande,
    String? emailPraticien,
  ) async {
    final url = 'https://allodocteurplus.com/api/acceptDemande.php';
    var responseBody;
    var bodyData = {
      'id_demande': idDemande,
      'email_praticien': emailPraticien,
    };
    try {
      final response = await http.post(Uri.parse(url), body: bodyData);
      var body = jsonDecode(jsonEncode(response.body));
      if (response.statusCode == 200) {
        // print(body);
        responseBody = body;
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    }
    return responseBody;
  }

  // new consultation

  static Future<String> newConsultation(
    String? emailPatient,
    String? emailPraticien,
    String? idDemande,
    String? fichierConsultation,
  ) async {
    final url = 'https://allodocteurplus.com/api/newConsultation.php';
    var consulationID;
    var bodyData = {
      'email_patient': emailPatient,
      'email_praticien': emailPraticien,
      'id_demande': idDemande,
      'fichier_consultation': fichierConsultation,
    };
    try {
      final response = await http.post(Uri.parse(url), body: bodyData);
      var body = jsonDecode(jsonEncode(response.body));
      if (response.statusCode == 200) {
        print(body);
        consulationID = body;
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    }
    return consulationID;
  }

// ** make a new interpreatation
  static Future<String> newInterpretation(
    String? emailPatient,
    String? emailPraticien,
    String? idDemande,
  ) async {
    final url = 'https://allodocteurplus.com/api/newInterpretation.php';
    var consulationID;
    var bodyData = {
      'email_patient': emailPatient,
      'email_praticien': emailPraticien,
      'id_demande': idDemande,
    };
    try {
      final response = await http.post(Uri.parse(url), body: bodyData);
      var body = jsonDecode(jsonEncode(response.body));
      if (response.statusCode == 200) {
        print(body);
        consulationID = body;
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    }
    return consulationID;
  }

// ** get all consultations suspend
  static Future<String> suspendedConsultation(
    String? idConsultation,
    String? emailPraticien,
  ) async {
    final url = 'https://allodocteurplus.com/api/suspendConsultation.php';
    var responseBody;
    var bodyData = {
      'id_consultation': idConsultation,
      'email_praticien': emailPraticien,
    };
    try {
      final response = await http.post(Uri.parse(url), body: bodyData);
      var body = jsonDecode(jsonEncode(response.body));
      if (response.statusCode == 200) {
        // print(body);
        responseBody = body;
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    }
    return responseBody;
  }

// ** get all consultations done
  static Future<String> doneConsultation(
    String? idConsultation,
    String? emailPraticien,
  ) async {
    final url = 'https://allodocteurplus.com/api/doneConsultation.php';
    var responseBody;
    var bodyData = {
      'id_consultation': idConsultation,
      'email_praticien': emailPraticien,
    };
    try {
      final response = await http.post(Uri.parse(url), body: bodyData);
      var body = jsonDecode(jsonEncode(response.body));
      if (response.statusCode == 200) {
        // print(body);
        responseBody = body;
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    }
    return responseBody;
  }

//** Get all suspend consultation */
  static Future<List<Consultations>> getAllSuspendConsul(
      String emailPraticien) async {
    Uri url = Uri.http('allodocteurplus.com',
        '/api/getAllSuspendConsultations.php?email_praticien=$emailPraticien');

    List<Consultations> _userConsultations = [];
    var response = await get(url);
    if (response.statusCode == 200) {
      print('Les consultations récupérées via ${url.path}');
      var body = jsonDecode(response.body);

      // print(response.body);

      body.forEach((e) {
        Consultations userConsultations = Consultations.fromJson(e);
        _userConsultations.add(userConsultations);
      });
    }
    return _userConsultations;
  }

//** Get all consultation done */
  static Future<List<Consultations>> getAllDoneConsul(
      String emailPraticien) async {
    Uri url = Uri.http('allodocteurplus.com',
        '/api/getAllDoneConsultations.php?email_praticien=$emailPraticien');

    List<Consultations> _userConsultations = [];
    var response = await get(url);
    if (response.statusCode == 200) {
      print('Les consultations récupérées via ${url.path}');
      var body = jsonDecode(response.body);

      // print(response.body);

      body.forEach((e) {
        Consultations userConsultations = Consultations.fromJson(e);
        _userConsultations.add(userConsultations);
      });
    }
    return _userConsultations;
  }

//** Get all waiting demandes   */
  static Future<List<UserDemande>> getAllWaitDemande() async {
    Uri url = Uri.http(
      'allodocteurplus.com',
      '/api/getAllWaitDemandes.php?',
    );
    // String url = 'http://bad-event.com/pharma/getVille.php';
    List<UserDemande> _userDemande = [];

    try {
      var response = await get(url);
      if (response.statusCode == 200) {
        print('Les demandes récupérées via ${url.path}');
        var body = jsonDecode(response.body);

        // print(response.body);
        body.forEach((e) {
          UserDemande userDemande = UserDemande.fromJson(e);
          _userDemande.add(userDemande);
        });
      }
    } catch (e) {
      print(e);
    }
    return _userDemande;
  }

//** Get all waiting demandes by department  */
  static Future<List<UserDemande>> getAllWaitDemandeByDepartment(
      String departementService) async {
    Uri url = Uri.http(
      'allodocteurplus.com',
      '/api/getAllWaitDemandeByDepartment.php?departement_service=$departementService',
    );
    // String url = 'http://bad-event.com/pharma/getVille.php';
    List<UserDemande> _userDemande = [];

    var response = await get(url);
    if (response.statusCode == 200) {
      print('Les demandes récupérées via ${url.path}');
      var body = jsonDecode(response.body);

      // print(response.body);
      body.forEach((e) {
        UserDemande userDemande = UserDemande.fromJson(e);
        _userDemande.add(userDemande);
      });
    }
    return _userDemande;
  }

//** get current consultation */

  static Future<List<Consultations>> getCurrentConsulation(
      String idDemande) async {
    Uri url = Uri.http('allodocteurplus.com',
        '/api/getCurrentConsulation.php?id_demande=$idDemande');
    List<Consultations> _currentConsultations = [];

    var response = await get(url);
    if (response.statusCode == 200) {
      print('Les demandes récupérées via ${url.path}');
      var body = jsonDecode(response.body);

      // print(response.body);
      body.forEach((e) {
        Consultations userDemande = Consultations.fromJson(e);
        _currentConsultations.add(userDemande);
      });
    }
    return _currentConsultations;
  }

//**  */
  static Future<List<UserDemande>> getAllAcceptDemandes(
      String departementService) async {
    Uri url = Uri.http(
      'allodocteurplus.com',
      '/api/getAllAcceptDemandes.php?departement_service=$departementService',
    );
    // String url = 'http://bad-event.com/pharma/getVille.php';
    List<UserDemande> _userDemande = [];

    var response = await get(url);
    if (response.statusCode == 200) {
      print('Les demandes récupérées via ${url.path}');
      var body = jsonDecode(response.body);

      // print(response.body);
      body.forEach((e) {
        UserDemande userDemande = UserDemande.fromJson(e);
        _userDemande.add(userDemande);
      });
    }
    return _userDemande;
  }

  // get demande Status

  static Future<String> getDemandeStatus(String idDemande) async {
    Uri url = Uri.http(
      'allodocteurplus.com',
      '/api/getDemandeStatus.php?id_demande=$idDemande',
    );
    var demandeStatus;

    var response = await get(url);
    if (response.statusCode == 200) {
      print('Status de demande via ${url.path}');
      demandeStatus = response.body;

      // print(demandeStatus);
    }
    return demandeStatus!;
  }

  static Future<String> getPaymentStatus(String idDemande) async {
    Uri url = Uri.http(
      'allodocteurplus.com',
      '/api/getPaymentStatus.php?id_demande=$idDemande',
    );
    var demandeStatus;

    var response = await get(url);
    if (response.statusCode == 200) {
      print('status de paiement via ${url.path}');
      demandeStatus = response.body;

      // print(demandeStatus);
    }
    return demandeStatus!;
  }

// get All users Docs
  static Future<List<UserDocuments>> getAllUserDoc(String userEmail) async {
    Uri url = Uri.http(
      'allodocteurplus.com',
      '/api/getAllUserDoc.php?email_utilisateur=$userEmail',
    );
    List<UserDocuments> documentMedicaux = [];

    var response = await get(url);
    if (response.statusCode == 200) {
      print('Les document médicaux récupérées via ${url.path}');
      var body = jsonDecode(response.body);
      body.forEach((e) {
        UserDocuments userDocuments = UserDocuments.fromJson(e);
        documentMedicaux.add(userDocuments);
      });

      // print(response.body);
    }
    return documentMedicaux;
  }

// upload userDoc
  static Future uploadUserDoc(
    BuildContext context,
    File imageFile,
    String userEmail,
    String userDossier,
  ) async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer " + "ghjklljhggjhk"
    };
// ignore: deprecated_member_use
    var stream = new http.ByteStream(StreamView(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse("https://allodocteurplus.com/api/uploadUserDoc.php");

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));

    request.headers.addAll(headers);
    request.files.add(multipartFile);
    request.fields['name'] = imageFile.path.split('/').last;
    request.fields['nom_document'] = "document";
    request.fields['email_utilisateur'] = userEmail;
    request.fields['dossier_utilisateur'] = userDossier;

    var respond = await request.send();
    if (respond.statusCode == 200) {
      print("Image Uploaded");
      final respStr = await respond.stream.bytesToString();
      print(respStr);
    } else {
      print("Upload Failed");
    }
  }

  static Future uploadPraticianPrescription(
    BuildContext context,
    File imageFile,
    String praticienEmail,
    String praticienNom,
    String praticienSpecialite,
    String nomDocument,
  ) async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer " + "ghjklljhggjhk"
    };
// ignore: deprecated_member_use
    var stream = new http.ByteStream(StreamView(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse(
        "https://allodocteurplus.com/api/uploadPraticianPrescription.php");

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));

    request.headers.addAll(headers);
    request.files.add(multipartFile);
    request.fields['name'] = imageFile.path.split('/').last;
    request.fields['nom_praticien'] = praticienNom;
    request.fields['specialite_praticien'] = praticienSpecialite;
    request.fields['email_praticien'] = praticienEmail;
    request.fields['nom_document'] = nomDocument;

    var respond = await request.send();
    if (respond.statusCode == 200) {
      print("Image Uploaded");
      final respStr = await respond.stream.bytesToString();
      print(respStr);
    } else {
      print("Upload Failed");
    }
  }

// update consultation set ordonnance
  static Future<String> updateConsultation(
    String? idDemande,
  ) async {
    final url = 'https://allodocteurplus.com/api/updateConsultation.php';
    var responseBody;
    var bodyData = {
      'id_demande': idDemande,
    };
    try {
      final response = await http.post(Uri.parse(url), body: bodyData);
      var body = jsonDecode(jsonEncode(response.body));
      if (response.statusCode == 200) {
        // print(body);
        responseBody = body;
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    }
    return responseBody;
  }

  // new message

  static Future<void> newFeedback(
    String? nom,
    String? email,
    String? message,
  ) async {
    final url = 'https://allodocteurplus.com/api/newFeedBack.php';
    var response;
    var bodyData = {
      'nom': nom,
      'email': email,
      'feedback': message,
    };
    try {
      final response = await http.post(Uri.parse(url), body: bodyData);
      var body = jsonDecode(jsonEncode(response.body));
      if (response.statusCode == 200) {
        print(body);
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    }
  }

  // new note

  static Future<void> newNote(
    String? note,
    String? idUtilisateur,
    String? idPraticien,
    String? idConsultation,
    String? subject,
  ) async {
    final url = 'https://allodocteurplus.com/api/newNotes.php';
    var response;
    var bodyData = {
      'note': note,
      'id_utilisateur': idUtilisateur,
      'id_praticien': idPraticien,
      'id_consultation': idConsultation,
      'subject': subject,
    };
    try {
      final response = await http.post(Uri.parse(url), body: bodyData);
      var body = jsonDecode(jsonEncode(response.body));
      if (response.statusCode == 200) {
        print(body);
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    }
  }

// edit user password
  static Future<String> editUserPassword(
    String emailUtilisateur,
    String mdpUtilisateur,
    String newMdp,
  ) async {
    final url = 'https://allodocteurplus.com/api/editUserPassword.php';
    var responseBody;
    var bodyData = {
      'email_utilisateur': emailUtilisateur,
      'mdp_utilisateur': mdpUtilisateur,
      'new_mdp': newMdp,
    };

    try {
      final response = await http.post(Uri.parse(url), body: bodyData);
      var body = jsonDecode(jsonEncode(response.body));
      if (response.statusCode == 200) {
        print(body);
        print(bodyData);
        responseBody = body;
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    }
    return responseBody;
  }

  // edit praticien password
  static Future<String> editPraticienPassword(
    String emailPraticien,
    String mdpPraticien,
    String newMdp,
  ) async {
    final url = 'https://allodocteurplus.com/api/editPraticienPassword.php';
    var responseBody;
    var bodyData = {
      'email_praticien': emailPraticien,
      'mdp_praticien': mdpPraticien,
      'new_mdp': newMdp,
    };

    try {
      final response = await http.post(Uri.parse(url), body: bodyData);
      var body = jsonDecode(jsonEncode(response.body));
      if (response.statusCode == 200) {
        print(body);
        print(bodyData);
        responseBody = body;
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    }
    return responseBody;
  }

  // set user pinCode
  static Future<String> setPatientPinCode(
    String emailUtilisateur,
    String pinUtilisateur,
  ) async {
    final url = 'https://allodocteurplus.com/api/setPatientPinCode.php';
    var responseBody;
    var bodyData = {
      'email_utilisateur': emailUtilisateur,
      'pin_utilisateur': pinUtilisateur,
    };

    try {
      final response = await http.post(Uri.parse(url), body: bodyData);
      var body = jsonDecode(jsonEncode(response.body));
      if (response.statusCode == 200) {
        print(body);
        print(bodyData);
        responseBody = body;
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    }
    return responseBody;
  }

  //** Get all pharmacie   */

  static Future<HTTPResponse<List<Pharmacie>>> getAllPharmacies() async {
    Uri url = Uri.http(
      'allodocteurplus.com',
      '/api/pharmacies/getAllPharmacies.php',
    );
    // String url = 'http://bad-event.com/pharma/getVille.php';
    try {
      var response = await get(url);
      if (response.statusCode == 200) {
        print('Les pharmacies récupérées via ${url.path}');
        var body = jsonDecode(response.body);

        // print(response.body);
        List<Pharmacie> _pharmacies = [];
        body.forEach((e) {
          Pharmacie pharmacie = Pharmacie.fromJson(e);
          _pharmacies.add(pharmacie);
          // print(pharmacie.idPharmacie);
        });
        return HTTPResponse(
          true,
          _pharmacies,
          responseCode: response.statusCode,
          message: 'pharmacies récupéreé ${response.body.length}',
        );
      } else {
        print('pharmcie non récupérés');
        return HTTPResponse(
          false,
          [],
          message: 'Erreur du server',
          responseCode: response.statusCode,
        );
      }
    } on SocketException {
      print('Vérifier votre connexion internet');
      return HTTPResponse(false, [],
          message: 'Vérifier votre connexion internet');
    } on FormatException {
      return HTTPResponse(false, [],
          message: 'Mauvaise réponse du server, réessayez');
    } catch (e) {
      return HTTPResponse(false, [],
          message: 'Une erreur est survenue, réessayez');
    }
  }

  static Future<HTTPResponse<List<Programme>>> getAllProgrammes() async {
    Uri url = Uri.http(
      'allodocteurplus.com',
      '/api/pharmacies/getAllProgrammes.php',
    );
    try {
      var response = await get(url);
      if (response.statusCode == 200) {
        print('Les programmes récupérés via ${url.path}');
        var body = jsonDecode(response.body);

        // print(response.body);
        List<Programme> _programmes = [];
        body.forEach((e) {
          Programme programme = Programme.fromJson(e);
          _programmes.add(programme);
        });
        return HTTPResponse(
          true,
          _programmes,
          responseCode: response.statusCode,
          message: 'programme récupérés ${response.body.length}',
        );
      } else {
        print('programme non récupérés');
        return HTTPResponse(
          false,
          [],
          message: 'Erreur du server',
          responseCode: response.statusCode,
        );
      }
    } on SocketException {
      print('Vérifier votre connexion internet');
      return HTTPResponse(false, [],
          message: 'Vérifier votre connexion internet');
    } on FormatException {
      return HTTPResponse(false, [],
          message: 'Mauvaise réponse du server, réessayez');
    } catch (e) {
      return HTTPResponse(false, [],
          message: 'Une erreur est survenue, réessayez');
    }
  }
}





//