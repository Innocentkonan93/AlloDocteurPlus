import 'package:google_fonts/google_fonts.dart';

import 'EditPraticienPassword.dart';
import '../../../../data/services/LoginService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import 'EditPraticianPhoto.dart';
import '../../../../data/controllers/PraticienController.dart';
import '../../../../data/models/Praticien.dart';
import '../../../../data/services/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PraticianSettings extends StatefulWidget {
  final List<Praticien> _praticienList;
  const PraticianSettings(this._praticienList, {Key? key}) : super(key: key);

  @override
  _PraticianSettingsState createState() => _PraticianSettingsState();
}

class _PraticianSettingsState extends State<PraticianSettings> {
  // praticien
  Future<String> getPraticianID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userID = prefs.getString('praticianID').toString();
    return userID;
  }

  Future<List> getCurrentPraticien() async {
    var userID = await getPraticianID();

    var resp = await ApiService.getCurrentPraticien(userID);
    var provider = Provider.of<PraticienController>(context, listen: false);
    if (resp.isSuccesful) {
      provider.setPraticienList(resp.data);
      provider.isProces(resp.isSuccesful);
    }
    return resp.data;
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPraticianPhoto()),
    );
    if (result != null && result == "updated") {
      await getCurrentPraticien();
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Photo modifiée'),
          backgroundColor: Colors.green,
        ));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final praticienList = widget._praticienList;
    final currentPraticien = praticienList.first;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gestion du compte',
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            letterSpacing: -1,
          ),
        ),
        backgroundColor: Color(0XFF101A69),
        centerTitle: true,
      ),
      body: Container(
        height: size.height,
        child: ListView(
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: CircleAvatar(
                      radius: size.width / 6,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: size.width / 6.5,
                        backgroundImage: currentPraticien.imagePraticien != null
                            ? NetworkImage(
                                "https://allodocteurplus.com/api/${currentPraticien.imagePraticien}",
                              )
                            : null,
                        child: currentPraticien.imagePraticien == null
                            ? Icon(
                                Icons.person,
                                color: Colors.white.withOpacity(0.23),
                                size: 60,
                              )
                            : null,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _navigateAndDisplaySelection(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Modifier photo',
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Nom complet",
                      style: GoogleFonts.nunito(
                        color: Colors.grey,
                      ),
                    ),
                    subtitle: Text(
                      "${currentPraticien.nomPraticien}",
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Fonction",
                      style: GoogleFonts.nunito(
                        color: Colors.grey,
                      ),
                    ),
                    subtitle: Text(
                      "${currentPraticien.specialitePraticien}",
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Email",
                      style: GoogleFonts.nunito(
                        color: Colors.grey,
                      ),
                    ),
                    subtitle: Text(
                      "${currentPraticien.emailPraticien}",
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // trailing: Icon(
                    //   Icons.arrow_forward_ios_rounded,
                    //   size: 15,
                    //   color: Color(0XFF101A69),
                    // ),
                    // onTap: () {
                    //   Get.to(() => EditPraticienPassword(
                    //       "${currentPraticien.emailPraticien}"));
                    // },
                  ),
                  ListTile(
                    title: Text(
                      "Mot de passe",
                      style: GoogleFonts.nunito(
                        color: Colors.grey,
                      ),
                    ),
                    subtitle: Text(
                      "**********",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                      color: Color(0XFF101A69),
                    ),
                    onTap: () {
                      Get.to(() => EditPraticienPassword(
                          "${currentPraticien.emailPraticien}"));
                    },
                  ),
                  ListTile(
                    title: Text(
                      "Numéro",
                      style: GoogleFonts.nunito(
                        color: Colors.grey,
                      ),
                    ),
                    subtitle: Text(
                      "${currentPraticien.numeroPraticien}",
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Status",
                      style: GoogleFonts.nunito(
                        color: Colors.grey,
                      ),
                    ),
                    subtitle: Text(
                      "${currentPraticien.statutPraticien}",
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Divider(
                    height: 0.2,
                  ),
                  SwitchListTile.adaptive(
                    value: true,
                    onChanged: (val) {},
                    title: Text(
                      "Notifications",
                      style: GoogleFonts.montserrat(),
                    ),
                  ),
                  Divider(
                    height: 0.2,
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Déconnexion',
                            style: GoogleFonts.montserrat(),
                          ),
                        ],
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24)),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Déconnexion',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      'Vous allez vous déconnecter !',
                                      style: GoogleFonts.montserrat(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Annuler',
                                      // style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  OkWidget(currentPraticien),
                                ],
                              );
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red[600],
                        elevation: 1,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OkWidget extends StatefulWidget {
  final Praticien currentPraticien;

  OkWidget(this.currentPraticien);

  @override
  _OkWidgetState createState() => _OkWidgetState();
}

class _OkWidgetState extends State<OkWidget> {
  bool isOk = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        setState(() {
          isOk = true;
        });
        String praticiantopic =
            widget.currentPraticien.emailPraticien!.split("@").first;
        if (praticiantopic.contains(".")) {
          praticiantopic = praticiantopic.split(".").last;
        }

        String departmenttopic = widget.currentPraticien.specialitePraticien!;

        await FirebaseMessaging.instance
            .unsubscribeFromTopic(departmenttopic)
            .then((value) => print("unsuscribed"));
        await FirebaseMessaging.instance
            .unsubscribeFromTopic("newDemande")
            .then((value) => print("unsuscribed to new demande"));
        await FirebaseMessaging.instance
            .unsubscribeFromTopic(praticiantopic)
            .then((value) => print("unsuscribed to department"));
        LoginService()
            .praticianLogout(context, "${widget.currentPraticien.idPraticien}");
      },
      child: isOk
          ? SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator.adaptive())
          : Text("Ok"),
    );
  }
}
