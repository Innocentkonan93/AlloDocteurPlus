import 'dart:convert';
import '../../app/utils/login/LoginSucces.dart';
import '../../app/utils/login/log/LogScreenWidget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LoginService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  //user pref login
  Future<void> loginUserPref(String userID, String userEmail,
      String userDossier, String userNom) async {
    // store preferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userType', "utilisateurs");
    prefs.setString('userID', userID);
    prefs.setString('userEmail', userEmail);
    prefs.setString('userDossier', userDossier);
    prefs.setString('userDossier', userNom);
    String usertopic = userEmail.split("@").first;
    if (usertopic.contains(".")) {
      usertopic = usertopic.split(".").last;
    }
    print("user topic " + usertopic);
    await messaging
        .subscribeToTopic("$usertopic")
        .then((value) => print('suscribed'));
  }

  //pratician pref login
  Future<void> loginPraticianPref(
    String praticianID,
    String praticienEmail,
    String praticianDepartement,
    String praticianNom,
    String onlineStatus,
  ) async {
    // store preferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userType', "praticiens");
    prefs.setString('praticianID', praticianID);
    prefs.setString('praticianEmail', praticienEmail);
    prefs.setString('praticianDepartement', praticianDepartement);
    prefs.setString('praticianNom', praticianNom);
    prefs.setString('online', onlineStatus);

    String praticiantopic = praticienEmail.split("@").first;
    if (praticiantopic.contains(".")) {
      praticiantopic = praticiantopic.split(".").last;
    }
    print("user topic " + praticiantopic);
    await messaging
        .subscribeToTopic("$praticiantopic")
        .then((value) => print('suscribed to :' + praticiantopic));
    await messaging
        .subscribeToTopic("newDemande")
        .then((value) => print('suscribed to newDemande'));
    await messaging
        .subscribeToTopic("$praticianDepartement")
        .then((value) => print('suscribed to :' + praticianDepartement));
  }

  Future<void> cleanUserPref() async {
    // clean
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userType');
    prefs.remove('userID');
    prefs.remove('userEmail');
    prefs.remove('userDossier');
    prefs.remove('userDossier');
    // prefs.clear();
  }

  Future<void> cleanPraticianPref() async {
    // clean
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userType');
    prefs.remove('praticianID');
    prefs.remove('praticianID');
    prefs.remove('praticianEmail');
    prefs.remove('praticianDepartement');
    prefs.remove('praticianNom');
    prefs.remove('online');
    // prefs.clear();
  }

  Future<void> userLogin(
      BuildContext context, String email, String password) async {
    final url = 'https://allodocteurplus.com/api/mobileLogin.php';
    final bodyData = {"email_utilisateur": email, "mdp_utilisateur": password};
    try {
      var response = await http.post(Uri.parse(url), body: bodyData);
      var body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // check if is login succesfully
        if (body.length == 1) {
          final userID = await body[0]['id_utilisateur'];
          final userEmail = await body[0]['email_utilisateur'];
          final userDossier = await body[0]['dossier_utilisateur'];
          final userNom = await body[0]['nom_utilisateur'];

          loginUserPref(userID, userEmail, userDossier, userNom);
          print('user id: ' + userID);
          print('user email: ' + userEmail);
          print('user dossier: ' + userDossier);

          Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(pageBuilder: (_, animation, __){
              return FadeTransition(opacity: animation, child: LoginSuccess(),);
            }),
              // MaterialPageRoute(
              //   builder: (contex) => LoginSuccess(),
              // ),
              (route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.exclamationCircle,
                  size: 18,
                  color: Colors.white,
                ),
                SizedBox(width: 5),
                Text("Identifiants incorrects"),
              ],
            ),
            backgroundColor: Theme.of(context).errorColor,
          ));
          print("login error : incorrects credentials");
        }
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> userRegistration(
    BuildContext context,
    String nomUtilisateur,
    String ageUtilisateur,
    String tailleUtilisateur,
    String poidsUtilisateur,
    String emailUtilisateur,
    String numeroUtilisateur,
    String mdpUtilisateur,
    String gsUtilisateur,
  ) async {
    final url = 'https://allodocteurplus.com/api/mobileRegistration.php';
    var result = "registration failed";
    final bodyData = {
      'nom_utilisateur': nomUtilisateur,
      'age_utilisateur': ageUtilisateur,
      'taille_utilisateur': tailleUtilisateur,
      'poids_utilisateur': poidsUtilisateur,
      'email_utilisateur': emailUtilisateur,
      'numero_utilisateur': numeroUtilisateur,
      'mdp_utilisateur': mdpUtilisateur,
      'gs_utilisateur': gsUtilisateur,
    };
    try {
      var response = await http.post(Uri.parse(url), body: bodyData);
      var body = jsonDecode(jsonEncode(response.body));

      if (response.statusCode == 200) {
        print(body);
        // check if is login succesfully
        //body
        if (body == "registred") {
          // do something
          print(body);
          userLogin(context, emailUtilisateur, mdpUtilisateur);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 6),
            content: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.exclamationCircle,
                  size: 18,
                  color: Colors.white,
                ),
                SizedBox(width: 5),
                Text("$body"),
              ],
            ),
            backgroundColor: Theme.of(context).errorColor,
          ));
        }
        return body;
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<void> praticianLogin(
      BuildContext context, String email, String password) async {
    final url = 'https://allodocteurplus.com/api/mobilePraticianLogin.php';
    final bodyData = {"email_praticien": email, "mdp_praticien": password};
    try {
      var response = await http.post(Uri.parse(url), body: bodyData);
      var body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // check if is login succesfully
        if (body.length == 1) {
          final praticianID = await body[0]['id_praticien'];
          final praticianEmail = await body[0]['email_praticien'];
          final specialitePraticien = await body[0]['specialite_praticien'];
          final nomPraticien = await body[0]['nom_praticien'];
          final onlineStatus = await body[0]['online'];

          loginPraticianPref(
            praticianID,
            praticianEmail,
            specialitePraticien,
            nomPraticien,
            onlineStatus,
          );
          print('pratician id: ' + praticianID);
          print('pratician email: ' + praticianEmail);
          print('pratician specialite: ' + specialitePraticien);

           Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(pageBuilder: (_, animation, __){
              return FadeTransition(opacity: animation, child: LoginSuccess(),);
            }),
              // MaterialPageRoute(
              //   builder: (contex) => LoginSuccess(),
              // ),
              (route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.exclamationCircle,
                  size: 18,
                  color: Colors.white,
                ),
                SizedBox(width: 5),
                Text("Identifiants incorrects"),
              ],
            ),
            backgroundColor: Theme.of(context).errorColor,
          ));
          print("login error : incorrects credentials");
        }
      } else {
        print('error');
      }
    } catch (e) {
      print(e);
    }
  }

  Future userLogout(BuildContext context) async {
    await cleanUserPref().then(
      (value) {
        print('pref clean');
        Get.offAll(
          () => LogScreenWidget(),
        );
      },
    );
  }

  Future praticianLogout(BuildContext context, String praticienId) async {
    await setLogout(praticienId);
    await cleanPraticianPref().then(
      (value) {
        print('pref clean');

        Get.offAll(
          () => LogScreenWidget(),
        );
      },
    );
  }

  Future setLogout(String praticienId) async {
    try {
      final url = 'https://allodocteurplus.com/api/logout.php';
      final bodyData = {
        "id_praticien": praticienId,
      };

      try {
        var response = await http.post(Uri.parse(url), body: bodyData);
        var body = jsonDecode(jsonEncode(response.body));
        if (response.statusCode == 200) {
          print(body);
          print(bodyData);
        }
      } catch (e) {
        print(e);
      }
    } catch (e) {}
  }
}
