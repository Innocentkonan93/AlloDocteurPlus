import 'dart:async';

import '../../utils/widgets/NewPinScreen.dart';
import '../../utils/widgets/PinScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'settings/EditUserPhoto.dart';
import '../../../data/services/ApiService.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings/UserSettings.dart';
import '../../utils/contacts/ConatctAndInfos.dart';
import '../../utils/widgets/LoadingWidgets.dart';
import '../../utils/widgets/NoInternetWidget.dart';
import '../../../data/controllers/UsersController.dart';
import '../../../data/models/User.dart';
import '../../../data/services/LoginService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

class CompteScreenWidget extends StatefulWidget {
  const CompteScreenWidget({Key? key}) : super(key: key);

  @override
  _CompteScreenWidgetState createState() => _CompteScreenWidgetState();
}

class _CompteScreenWidgetState extends State<CompteScreenWidget> {
  bool hasInternet = true;
  bool isOk = false;
  late StreamSubscription connectivitySubscription;
  ConnectivityResult result = ConnectivityResult.none;
  late StreamSubscription internetsubscription;
  LoadingWidget loadingWidget = LoadingWidget();

  Future<String> getUserID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userID = prefs.getString('userID').toString();
    return userID;
  }

  Future<void> getCurrentUserData() async {
    var userID = await getUserID();
    var resp = await ApiService.getCurrentUser(userID);
    var provider = Provider.of<UsersController>(context, listen: false);

    if (resp.isSuccesful) {
      provider.setUserList(resp.data);

      provider.isProces(resp.isSuccesful);
    }

    return resp.data;
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditUserPhoto()),
    );
    if (result != null && result == "updated") {
      await getCurrentUserData();
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
        Connectivity().onConnectivityChanged.listen((status) {
      setState(() => result = status);
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
  Widget build(BuildContext context2) {
    final size = MediaQuery.of(context2).size;
    final users = Provider.of<UsersController>(context2);
    final currentUserList = users.listUsers;
    final currentUser = currentUserList.first;

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
                          color: Colors.blue,
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
                                    currentUser.imageUtilisateur != null
                                        ? NetworkImage(
                                            "https://allodocteurplus.com/api/${currentUser.imageUtilisateur}",
                                          )
                                        : null,
                                child: currentUser.imageUtilisateur == null
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
                                  '${currentUser.nomUtilisateur}',
                                  style: GoogleFonts.nunito(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Icon(Icons.pin_drop),
                          //     Text(
                          //       'Josco Diesel',
                          //       style: TextStyle(),
                          //     ),
                          //   ],
                          // )
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
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        profilMenuItem(
                          FaIcon(FontAwesomeIcons.idCardAlt),
                          'Fiche médicale',
                          () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              )),
                              builder: (context) {
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          if (currentUser.pinUtilisateur ==
                                              null) {
                                            print(
                                                "pin : ${currentUser.pinUtilisateur}");
                                            Get.to(
                                              () => NewPinScreen(
                                                currentUser: currentUser,
                                              ),
                                              fullscreenDialog: true,
                                            );
                                          } else {
                                            print(
                                                "pin : ${currentUser.pinUtilisateur}");
                                            Get.to(
                                              () => PinScreen(
                                                pinUtilisateur: currentUser
                                                    .pinUtilisateur
                                                    .toString(),
                                              ),
                                              fullscreenDialog: true,
                                            );
                                          }
                                          // Navigator.of(context).push(
                                          //   MaterialPageRoute(
                                          //     fullscreenDialog: true,
                                          //     builder: (context) =>
                                          //         UserMedicalInfo(),
                                          //   ),
                                          // );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                CupertinoIcons
                                                    .folder_badge_person_crop,
                                                color: Colors.blue[900],
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "Dossier médical",
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.blue[900]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(
                                          // height: 0.1,
                                          ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Constantes',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          // Text(
                                          //   'Constantes',
                                          //   style: GoogleFonts.montserrat(),
                                          // ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Taille:',
                                                  style: GoogleFonts.montserrat(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Spacer(),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 15,
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Text(
                                                    '${currentUser.tailleUtilisateur} cm',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 15,
                                                            color: Colors
                                                                .blue[900]),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Poids:',
                                                  style: GoogleFonts.montserrat(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Spacer(),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 15,
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Text(
                                                    '${currentUser.poidsUtilisateur} kg',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 15,
                                                            color: Colors
                                                                .blue[900]),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Groupe sanguin:',
                                                  style: GoogleFonts.montserrat(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Spacer(),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Text(
                                                    '${currentUser.gsUtilisateur}',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 15,
                                                            color: Colors
                                                                .red[900]),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        // profilMenuItem(
                        //   FaIcon(FontAwesomeIcons.filePrescription),
                        //   'Prescriptions',
                        //   () {
                        //     Navigator.of(context).push(
                        //       MaterialPageRoute(
                        //         fullscreenDialog: true,
                        //         builder: (_) => PrescriptionsList(),
                        //       ),
                        //     );
                        //   },
                        // ),
                        // profilMenuItem(
                        //   FaIcon(FontAwesomeIcons.history),
                        //   'Historiques',
                        //   () {
                        //     Navigator.of(context).push(
                        //       MaterialPageRoute(
                        //         builder: (_) => UserHistoriques(),
                        //       ),
                        //     );
                        //   },
                        // ),
                        profilMenuItem(
                          FaIcon(FontAwesomeIcons.userCog),
                          'Paramètres du compte',
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => UserSettings(currentUserList),
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
                        //   () async {
                        //     showDialog(
                        //       context: context,
                        //       builder: (context) {
                        //         return AlertDialog(
                        //           shape: RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.circular(24)),
                        //           title: Text('Déconnexion'),
                        //           content:
                        //               Text('Vous allez vous déconnecter !'),
                        //           actions: [
                        //             TextButton(
                        //               onPressed: () {
                        //                 Navigator.of(context).pop();
                        //               },
                        //               child: Text('Annuler',
                        //                   style: TextStyle(color: Colors.red)),
                        //             ),
                        //             OkWidget(currentUser),
                        //           ],
                        //         );
                        //       },
                        //     );
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

Widget profilMenuItem(dynamic icon, String title, VoidCallback onPressed) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    // decoration: BoxDecoration(
    //   border: Border(
    //     bottom: BorderSide(
    //       // color: Colors.grey.withOpacity(0.2),
    //     ),
    //   ),
    // ),
    child: TextButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Container(
            height: 25,
            width: 25,
            child: Center(
              child: icon,
            ),
          ),
          // Icon(
          //   Icons.settings,
          //   color: Color(0XFF363636),
          // ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: 17,
                color: Color(0XFF363636),
                letterSpacing: -1,
              ),
            ),
          )
        ],
      ),
    ),
  );
}

class OkWidget extends StatefulWidget {
  final User currentUser;

  OkWidget(this.currentUser);

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
        String usertopic =
            widget.currentUser.emailUtilisateur!.split("@").first;
        if (usertopic.contains(".")) {
          usertopic = usertopic.split(".").last;
        }
        await FirebaseMessaging.instance
            .unsubscribeFromTopic(usertopic)
            .then((value) => print('unsuscribed'));
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
