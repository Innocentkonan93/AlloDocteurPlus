// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:app_allo_docteur_plus/app/praticians/screens/settings/EditPraticianPhoto.dart';
import 'package:app_allo_docteur_plus/app/praticians/screens/settings/PraticianSetting.dart';
import 'package:app_allo_docteur_plus/app/users/screens/CompteScreenWidget.dart';
import 'package:app_allo_docteur_plus/app/utils/contacts/ConatctAndInfos.dart';
import 'package:app_allo_docteur_plus/app/utils/widgets/LoadingWidgets.dart';
import 'package:app_allo_docteur_plus/app/utils/widgets/NoInternetWidget.dart';
import 'package:app_allo_docteur_plus/data/controllers/PraticienController.dart';
import 'package:app_allo_docteur_plus/data/models/Praticien.dart';
import 'package:app_allo_docteur_plus/data/services/ApiService.dart';
import 'package:app_allo_docteur_plus/data/services/LoginService.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'histories/PraticiansAcitivites.dart';

class PCompteScreenWidget extends StatefulWidget {
  const PCompteScreenWidget({Key? key}) : super(key: key);

  @override
  _PCompteScreenWidgetState createState() => _PCompteScreenWidgetState();
}

class _PCompteScreenWidgetState extends State<PCompteScreenWidget> {
  LoadingWidget loadingWidget = LoadingWidget();
  bool hasInternet = true;
  late StreamSubscription internetsubscription;
  late StreamSubscription connectivitySubscription;

  ConnectivityResult result = ConnectivityResult.none;
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
  void initState() {
    internetsubscription =
        InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() {
        this.hasInternet = hasInternet;
      });
      print(hasInternet);
    });

    connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((event) {
      setState(() {
        result = event;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    internetsubscription.cancel();
    connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final size = MediaQuery.of(context).size;
    final praticienController = Provider.of<PraticienController>(context);
    final praticienList = praticienController.listPraticiens;
    final currentPraticien = praticienList.first;

    final AppBar appBar = AppBar(
      title: Text(
        'Compte',
        style: GoogleFonts.nunito(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          letterSpacing: -1,
        ),
      ),
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: Color(0XFF101A69),
      brightness: Brightness.dark,
    );

    return hasInternet
        ? Scaffold(
            appBar: appBar,
            body: Container(
              height: size.height,
              child: Column(
                children: [
                  Expanded(
                    // height: (size.height -
                    //         (appBar.preferredSize.height + window.padding.top)) *
                    //     0.4,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Color(0XFF101A69),
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(50))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: size.width / 6,
                            backgroundColor: Colors.white,
                            child: GestureDetector(
                              onTap: () {
                                _navigateAndDisplaySelection(context);
                              },
                              child: CircleAvatar(
                                radius: size.width / 6.5,
                                backgroundImage:
                                    currentPraticien.imagePraticien != null
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
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(30)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Dr. ${currentPraticien.nomPraticien}',
                                  style: GoogleFonts.nunito(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${currentPraticien.specialitePraticien}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    // height: (size.height -
                    //         (appBar.preferredSize.height + window.padding.top)) *
                    //     0.5,
                    child: ListView(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        // profilMenuItem(
                        //   FaIcon(
                        //     FontAwesomeIcons.history,
                        //   ),
                        //   'Historiques',
                        //   () {
                        //     Navigator.of(context).push(
                        //       MaterialPageRoute(
                        //         builder: (context) => PraticianHistoriques(),
                        //       ),
                        //     );
                        //   },
                        // ),
                        profilMenuItem(
                          FaIcon(
                            FontAwesomeIcons.filePrescription,
                          ),
                          'Prescriptions',
                          () {
                            Get.to(
                              () => PraticianActivites(),
                              // fullscreenDialog: true
                            );
                          },
                        ),
                        profilMenuItem(
                          FaIcon(
                            FontAwesomeIcons.userCog,
                          ),
                          'Paramètres du compte',
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    PraticianSettings(praticienList),
                              ),
                            );
                          },
                        ),
                        profilMenuItem(
                          FaIcon(
                            FontAwesomeIcons.infoCircle,
                          ),
                          'Contacts et infos',
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ContactAndInfo(),
                              ),
                            );
                          },
                        ),
                        // profilMenuItem(
                        //   FaIcon(
                        //     FontAwesomeIcons.signInAlt,
                        //     color: Colors.red,
                        //   ),
                        //   'Déconnexion',
                        //   () {
                        //     showDialog(
                        //         context: context,
                        //         builder: (context) {
                        //           return AlertDialog(
                        //             shape: RoundedRectangleBorder(
                        //                 borderRadius:
                        //                     BorderRadius.circular(24)),
                        //             title: Text('Déconnexion'),
                        //             content:
                        //                 Text('Vous allez vous déconnecter !'),
                        //             actions: [
                        //               TextButton(
                        //                 onPressed: () {
                        //                   Navigator.of(context).pop();
                        //                 },
                        //                 child: Text('Annuler',
                        //                     style:
                        //                         TextStyle(color: Colors.red)),
                        //               ),
                        //               OkWidget(currentPraticien),
                        //             ],
                        //           );
                        //         });
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : NoInternetWidget(hasInternet, result);
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
            .then((value) => print("unsuscribed"));
        await FirebaseMessaging.instance
            .unsubscribeFromTopic(praticiantopic)
            .then((value) => print("unsuscribed to department"));
        LoginService().userLogout(context);
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
