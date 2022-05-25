import 'dart:async';

import '../../utils/processs/chat/ChatScreen.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/controllers/PraticiensAcitivitesController.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'DemandesScreenWidegt.dart';
import 'consultations/AcceptedDemande.dart';
import 'consultations/DonedConsultation.dart';
import 'consultations/SuspendedConsultation.dart';
import '../../utils/widgets/NoInternetWidget.dart';
import '../../../data/controllers/PraticienController.dart';
import '../../../data/controllers/PraticienCurriculum.dart';
import '../../../data/controllers/UserActivitesController.dart';
import '../../../data/controllers/UserConsultationController.dart';
import '../../../data/controllers/UserDemandeController.dart';
import '../../../data/models/Demandes.dart';
import '../../../data/services/ApiService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PHomeScreenWidget extends StatefulWidget {
  const PHomeScreenWidget({Key? key}) : super(key: key);

  @override
  _PHomeScreenWidgetState createState() => _PHomeScreenWidgetState();
}

class _PHomeScreenWidgetState extends State<PHomeScreenWidget> {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  bool hasInternet = true;
  String? userType;
  late StreamSubscription internetsubscription;
  late StreamSubscription connectivitySubscription;

  ConnectivityResult result = ConnectivityResult.none;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<String> getTypedUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = prefs.getString('userType').toString();
    return userType!;
  }

  Future<String> getPraticianDepartement() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String departement =
        prefs.getString('praticianDepartement').toString();
    return departement;
  }

  Stream<List<UserDemande>> get demandStream async* {
    final String department = await getPraticianDepartement();
    for (var i = 0; i > -1; i++) {
      // await Future.delayed(Duration(seconds: 1));

      yield await ApiService.getAllWaitDemande();
      // yield await ApiService.getAllWaitDemandeByDepartment("$department");
      i++;
    }
  }

  Future<List> getAllConsultations() async {
    var provider =
        Provider.of<UserConsultationController>(context, listen: false);
    var resp = await ApiService.getAllConsultations();
    if (resp.isSuccesful) {
      provider.setConsultationsList(resp.data);

      provider.isProces(resp.isSuccesful);
    }
    return resp.data;
  }

  Future<List> getAllActivitesPraticiens() async {
    var provider =
        Provider.of<PraticiensActivitesController>(context, listen: false);
    var resp = await ApiService.getAllActivitesPraticiens();
    if (resp.isSuccesful) {
      provider.setActivitesPraticiensList(resp.data);

      provider.isProces(resp.isSuccesful);
    }
    return resp.data;
  }

  Future<List> getAllActivites() async {
    var provider = Provider.of<UserActivitesController>(context, listen: false);
    var resp = await ApiService.getAllActivites();
    if (resp.isSuccesful) {
      provider.setUserActivitesList(resp.data);

      provider.isProces(resp.isSuccesful);
    }
    return resp.data;
  }

  Future<List> getAllDemandes() async {
    var provider =
        Provider.of<UserDemandeDemandeController>(context, listen: false);
    var resp = await ApiService.getAllDemandes();
    if (resp.isSuccesful) {
      provider.setUserDemandeList(resp.data);
      provider.isProces(resp.isSuccesful);
    }
    return resp.data;
  }

  Future<List> getPraticienCurriculum() async {
    var provider = Provider.of<PraticienCurriculum>(context, listen: false);
    var resp = await ApiService.getAllPraticienCurriculum();
    if (resp.isSuccesful) {
      provider.setCurriculumsList(resp.data);
      provider.isProces(resp.isSuccesful);
    }
    return resp.data;
  }

  _getToken() {
    _firebaseMessaging.getToken().then((deviceToken) {
      print('Device Token: $deviceToken');
      _db
          .collection(
              "/notifications/yBlfDOUJ9hair4CP2aC4/notificationTokens/9e2jgRn3F2Wq3yWWdh5p/praticiens")
          .add({
        "notificationToken": deviceToken,
      });
    });
  }

  @override
  void initState() {
    getAllDemandes();
    getAllConsultations();
    getAllActivites();
    getPraticienCurriculum();
    getTypedUserData();
    getAllActivitesPraticiens();
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

    _getToken();
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print(message.notification!.title);
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final idConsultation = message.data['id_consultation'];
      final emailUtilisateur = message.data['user_receiver'];
      final emailPraticien = message.data['pratician_receiver'];
      if (message.notification != null) {
        if (message.notification!.title == "Retour utilisateur" &&
            userType == "praticiens") {
          final title = message.notification!.title.toString();
          final body = message.notification!.body.toString();
          Get.snackbar(
            title,
            body,
            duration: Duration(seconds: 30),
            dismissDirection: DismissDirection.horizontal,
            isDismissible: true,
            backgroundColor: Colors.white,
            borderRadius: 10.0,
            boxShadows: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5,
                offset: Offset(0.0, 0.0),
              )
            ],
            icon: Icon(Icons.settings_backup_restore_outlined,
                color: Colors.deepOrange),
            padding: EdgeInsets.all(8),
            onTap: (snack) async {
              final routeName = message.data['route_name'];
              if (routeName == "chat_screen") {
                await Get.to(
                  () => ChatScreen(
                      emailUtilisateur, emailPraticien, idConsultation),
                );
                Get.back();
              }
            },
          );
        }

        if (message.notification!.title == "Nouvelle demande" &&
            userType == "praticiens") {
          getAllDemandes();
          final title = message.notification!.title.toString();
          final body = message.notification!.body.toString();
          final routeName = message.data['route_name'];
          Get.snackbar(
            title,
            body,
            duration: Duration(seconds: 30),
            dismissDirection: DismissDirection.horizontal,
            isDismissible: true,
            backgroundColor: Colors.white,
            borderRadius: 10.0,
            icon: Icon(Icons.receipt, color: Colors.green),
            padding: EdgeInsets.all(8),
            boxShadows: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5,
                offset: Offset(0.0, 0.0),
              )
            ],
            onTap: (snack) {
              if (routeName == "demande_screen") {
                Get.to(() => DemandesScreenWidget());
              }
            },
          );
        }
      }
    });
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   if (message.notification != null) {
    //     if (message.notification!.title != "appel vidéo" &&
    //         userType == "praticiens") {
    //       NotificationApi.display(message);
    //     } else {
    //       print("appel video lancée");
    //     }
    //   }
    // });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("onMessageOpenedApp: $message");

      final idConsultation = message.data['id_consultation'];
      final emailUtilisateur = message.data['user_receiver'];
      final pratician_receiver = message.data['pratician_receiver'];
      final nameRoute = message.data["route_name"];

      if (message.notification!.title == "Retour utilisateur") {
        if (nameRoute == "chat_screen") {
          Get.offAll(
            () => ChatScreen(
                emailUtilisateur, pratician_receiver, idConsultation),
          );
        }
      }
      if (message.notification!.title == "Nouvelle demande" &&
          userType == "praticiens") {
        if (nameRoute == "demande_screen") {
          Get.to(
            () => DemandesScreenWidget(),
          );
        }
      }
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
    final size = MediaQuery.of(context).size;

    final praticianController = Provider.of<PraticienController>(context);
    final praticianList = praticianController.listPraticiens;
    final currentPraticien = praticianList.first;

    final demandeProvider = Provider.of<UserDemandeDemandeController>(context);

    final demandeList = demandeProvider.listUserDemandes;

    final demandeAccepted = demandeList
        .where((demande) => demande.statusDemande == "ACCEPTED")
        .where((demande) =>
            demande.emailPraticien == "${currentPraticien.emailPraticien}")
        .toList();

    final consultations = Provider.of<UserConsultationController>(context);

    final consultationsList = consultations.listConsultations;

    final consultationsDone = consultationsList
        .where((consultation) => consultation.statutConsultation == "done")
        .where((consultation) =>
            consultation.emailPraticien == "${currentPraticien.emailPraticien}")
        .toList();

    final consultationsSuspended = consultationsList
        .where((consultation) =>
            consultation.statutConsultation == 'standby' ||
            consultation.statutConsultation == 'created')
        .where((consultation) =>
            consultation.emailPraticien == currentPraticien.emailPraticien)
        .toList();

    return hasInternet
        ? Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              // ignore: deprecated_member_use
              brightness: Brightness.dark,
              title: Text(
                'Bonjour Dr. ' +
                    currentPraticien.nomPraticien!.split(' ').first +
                    ' !',
                style: GoogleFonts.nunito(),
              ),
            ),
            body: Container(
              height: size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0XFF101A69).withOpacity(0.9),
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.6],
                ),
              ),
              child: Center(
                child: GridView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(20),
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 30,
                      childAspectRatio: 1.2),
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => DemandesScreenWidget(),
                        );
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => DemandesScreenWidget(),
                        //   ),
                        // );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 3,
                                offset: Offset(2, 2),
                                color: Colors.black12,
                              )
                            ]),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Color(0XFF101A69),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Nouvelles demandes",
                                      style: GoogleFonts.nunito(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: StreamBuilder(
                                stream: demandStream,
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<UserDemande>> snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.active) {
                                      return Center(
                                        child: Text(
                                          snapshot.data!.length.toString(),
                                          style: GoogleFonts.montserrat(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: Text(
                                          '-',
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }
                                  }
                                  return Container(
                                    child: Center(
                                      child: Text(
                                        '-',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SuspendedConsultation(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 3,
                                offset: Offset(2, 2),
                                color: Colors.black12,
                              )
                            ]),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Color(0XFF101A69),
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "En cours",
                                      style: GoogleFonts.nunito(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: !consultations.isProcessing
                                    ? Text(
                                        '-',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Text(
                                        '${consultationsSuspended.length}',
                                        style: GoogleFonts.montserrat(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => AcceptedDemande(),
                          fullscreenDialog: true,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 3,
                                offset: Offset(2, 2),
                                color: Colors.black12,
                              )
                            ]),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Color(0XFF4F9A18),
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Demandes acceptées",
                                      style: GoogleFonts.nunito(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: !demandeProvider.isProcessing
                                    ? Text(
                                        '-',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Text(
                                        '${demandeAccepted.length}',
                                        style: GoogleFonts.montserrat(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => DonedConsultation(),
                          fullscreenDialog: true,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 3,
                                offset: Offset(2, 2),
                                color: Colors.black12,
                              )
                            ]),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Color(0XFF4F9A18),
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Demandes traitées",
                                      style: GoogleFonts.nunito(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child:
                                  //   StreamBuilder(
                                  // stream: _streamController.stream,
                                  // builder: (context, snapshot) {
                                  //   if (snapshot.hasError)
                                  //     return Text('Errr');
                                  //   else if (snapshot.connectionState ==
                                  //       ConnectionState.waiting)
                                  //     return Center(child: CircularProgressIndicator());
                                  //   return Text("${snapshot.data}");
                                  // },
                                  // )
                                  Center(
                                child: !consultations.isProcessing
                                    ? Text(
                                        '-',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Text(
                                        '${consultationsDone.length}',
                                        style: GoogleFonts.montserrat(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : NoInternetWidget(hasInternet, result);
  }
}
