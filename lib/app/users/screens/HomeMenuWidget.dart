// ignore_for_file: unused_field

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:app_allo_docteur_plus/app/app_categories/CategorieDetailsScreen.dart';
import 'package:app_allo_docteur_plus/app/app_categories/CategorieListPage.dart';
import 'package:app_allo_docteur_plus/app/app_services/ServicesDetailsScreen.dart';
import 'package:app_allo_docteur_plus/app/praticians/screens/details/PraticianDetailsScreen.dart';
import 'package:app_allo_docteur_plus/app/praticians/widgets/PraticianListPage.dart';
import 'package:app_allo_docteur_plus/app/users/screens/ConsultationScreenWidget.dart';
import 'package:app_allo_docteur_plus/app/users/screens/histories/notifications/UserNotificationsScreen.dart';
import 'package:app_allo_docteur_plus/app/utils/processs/chat/ChatScreen.dart';
import 'package:app_allo_docteur_plus/app/utils/widgets/NoInternetWidget.dart';
import 'package:app_allo_docteur_plus/app/utils/widgets/PraticianRatingView.dart';
import 'package:app_allo_docteur_plus/data/controllers/DepartementController.dart';
import 'package:app_allo_docteur_plus/data/controllers/PraticienController.dart';
import 'package:app_allo_docteur_plus/data/controllers/PraticienCurriculum.dart';
import 'package:app_allo_docteur_plus/data/controllers/ServicesController.dart';
import 'package:app_allo_docteur_plus/data/controllers/ServicesTypeController.dart';
import 'package:app_allo_docteur_plus/data/controllers/UserActivitesController.dart';
import 'package:app_allo_docteur_plus/data/controllers/UserConsultationController.dart';
import 'package:app_allo_docteur_plus/data/controllers/UsersController.dart';
import 'package:app_allo_docteur_plus/data/services/ApiService.dart';
import 'package:app_allo_docteur_plus/data/services/FirestoreService.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeMenuWidget extends StatefulWidget {
  const HomeMenuWidget({Key? key}) : super(key: key);

  @override
  _HomeMenuWidgetState createState() => _HomeMenuWidgetState();
}

class _HomeMenuWidgetState extends State<HomeMenuWidget> {
  bool hasInternet = true;
  late StreamSubscription internetSubscription;
  late StreamSubscription connectivitySubscription;
  ConnectivityResult result = ConnectivityResult.none;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirestoreService firestoreService = FirestoreService();
  String? userNom;
  String? userType;
  final _scrollController = ScrollController(initialScrollOffset: 50.0);

  Future<String> getTypedUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = prefs.getString('userType').toString();
    return userType!;
  }

  Future<List> getAllServiceType() async {
    var provider = Provider.of<ServicesTypeController>(context, listen: false);
    var resp = await ApiService.getAllServicesType();
    if (resp.isSuccesful) {
      provider.setServicesTypeList(resp.data);

      provider.isProces(resp.isSuccesful);
    }
    return resp.data;
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

  Future<List> getAllServices() async {
    var provider = Provider.of<ServicesController>(context, listen: false);
    var resp = await ApiService.getAllServices();
    if (resp.isSuccesful) {
      provider.setServicesList(resp.data);

      provider.isProces(resp.isSuccesful);
    }
    return resp.data;
  }

  Future<List> getAllDepartements() async {
    var provider = Provider.of<DepartementController>(context, listen: false);
    var resp = await ApiService.getAllDepartement();
    if (resp.isSuccesful) {
      provider.setDepartementList(resp.data);
      provider.isProces(resp.isSuccesful);
    }
    return resp.data;
  }

  Future<List> getAllPraticiens() async {
    var provider = Provider.of<PraticienController>(context, listen: false);
    var resp = await ApiService.getAllPraticien();
    if (resp.isSuccesful) {
      provider.setPraticienList(resp.data);
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

  Future<String> getUserID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userID = prefs.getString('userID').toString();
    userNom = prefs.getString('userNom').toString();
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

  Future<List> getPraticienCurriculum() async {
    var provider = Provider.of<PraticienCurriculum>(context, listen: false);
    var resp = await ApiService.getAllPraticienCurriculum();
    if (resp.isSuccesful) {
      provider.setCurriculumsList(resp.data);
      provider.isProces(resp.isSuccesful);
    }
    return resp.data;
  }

  final AppBar appbar = AppBar();

  // getToken() {
  //   _firebaseMessaging.getToken().then((deviceToken) {
  //     print('Device Token: $deviceToken');
  //     _db
  //         .collection(
  //             "/notifications/yBlfDOUJ9hair4CP2aC4/notificationTokens/1cfDEVjVR1KFS0E2y0cm/utilisteurs")
  //         .add({
  //       "notificationToken": deviceToken,
  //     });
  //   });
  // }

  openRatingDialog(
    BuildContext context,
    String idConsultation,
    String idUtilisateur,
    String idPraticien,
  ) {
    showDialog(
      barrierColor: Colors.black26,
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          child: PraticianRatingView(
            idConsultation: idConsultation,
            idPraticien: idPraticien,
            idUtilisateur: idUtilisateur,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // getToken();
    getCurrentUserData();
    getAllServiceType();
    getAllServices();
    getAllPraticiens();
    getAllDepartements();
    getAllActivites();
    getPraticienCurriculum();
    getAllConsultations();
    getTypedUserData();

    internetSubscription =
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

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print(message.notification!.title);
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null && userType == "utilisateurs") {
        if (message.notification!.title == "Nouvelle prescription" ||
            message.notification!.title == "Nouveau bulletin") {
          Get.snackbar(
            message.notification!.title.toString(),
            message.notification!.body.toString(),
            duration: Duration(seconds: 30),
            borderRadius: 10.0,
            backgroundColor: Colors.white,
            icon: Center(
              child: FaIcon(
                FontAwesomeIcons.filePrescription,
                color: Colors.green,
              ),
            ),
            padding: EdgeInsets.all(8),
            boxShadows: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5,
                offset: Offset(0.0, 0.0),
              )
            ],
          );
        }

        if (message.notification!.title == "Consultation") {
          final routeName = message.data['route_name'];
          print(routeName);
          Get.snackbar(
            message.notification!.title.toString(),
            message.notification!.body.toString(),
            duration: Duration(seconds: 30),
            dismissDirection: DismissDirection.horizontal,
            isDismissible: true,
            backgroundColor: Colors.white,
            borderRadius: 10.0,
            icon: Icon(Icons.pause_circle_outline_rounded,
                color: Colors.deepOrange),
            padding: EdgeInsets.all(8),
            boxShadows: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5,
                offset: Offset(0.0, 0.0),
              )
            ],
            onTap: (getObj) async {
              print(message.data);
              if (routeName == "consultation_screen") {
                await Get.to(() => ConsultationScreenWidget());
                Get.back();
              }
            },
          );
          if (message.notification!.body!.contains("terminé")) {
            print(message.data['id_consultation']);

            Future.delayed(Duration(seconds: 10), () async {
              final idConsultation = await message.data['id_consultation'];
              final emailUtilisateur = await message.data['user_receiver'];
              final emailPraticien = await message.data['pratician_email'];

              await FirebaseMessaging.instance
                  .unsubscribeFromTopic(idConsultation);

              // print("consultation_id: " + idConsultation.toString());
              // print("user: " + emailUtilisateur.toString());
              // print("praticien: " + emailPraticien.toString());
              if (mounted)
                openRatingDialog(
                  context,
                  idConsultation,
                  emailUtilisateur.toString(),
                  emailPraticien.toString(),
                );
            });
          }
        }
        if (message.notification!.title == "Reprise consultation") {
          final idConsultation = message.data['id_consultation'];
          final emailUtilisateur = message.data['user_receiver'];
          final emailPraticien = message.data['pratician_email'];
          Get.snackbar(
            message.notification!.title.toString(),
            message.notification!.body.toString(),
            duration: Duration(seconds: 30),
            dismissDirection: DismissDirection.horizontal,
            isDismissible: true,
            backgroundColor: Colors.white,
            borderRadius: 10.0,
            icon: Icon(
              Icons.reset_tv_rounded,
              color: Colors.blue,
            ),
            padding: EdgeInsets.all(8),
            boxShadows: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5,
                offset: Offset(0.0, 0.0),
              )
            ],
            onTap: (getObj) async {
              final routeName = message.data['route_name'];
              if (routeName == "chat_screen") {
                Navigator.of(context).pop();
                await Get.offAll(
                  () => ChatScreen(
                      emailUtilisateur, emailPraticien, idConsultation),
                );
                Get.back();
              }
            },
          );
        }
      }
    });
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // NotificationApi.display(message);
    // });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("onMessageOpenedApp: $message");

      final idConsultation = message.data['id_consultation'];
      final emailUtilisateur = message.data['user_receiver'];
      final emailPraticien = message.data['pratician_email'];

      final nameRoute = message.data["route_name"];

      if (nameRoute == "chat_screen") {
        Get.offAll(
          () => ChatScreen(emailUtilisateur, emailPraticien, idConsultation),
        );
      } else if (nameRoute == "consultation_screen") {
        Get.to(() => ConsultationScreenWidget());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    internetSubscription.cancel();
    connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final typesDeService = Provider.of<ServicesTypeController>(context);
    final services = typesDeService.listServicesTypes;

    final departementProvider = Provider.of<DepartementController>(context);
    final departementList = departementProvider.listDepartements;

    final praticienController = Provider.of<PraticienController>(context);
    final praticienList = praticienController.listPraticiens
        .where((praticien) => praticien.verifProf == 'oui')
        .toList();

    final userController = Provider.of<UsersController>(context);
    final currenUser = userController.listUsers;
    return hasInternet
        ? Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              actions: [
                StreamBuilder<QuerySnapshot>(
                  stream: firestoreService
                      .getUserNotif(currenUser.first.emailUtilisateur!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Icon(Icons.notifications_rounded);
                    } else {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      }
                      final notifs = snapshot.data!.docs;
                      FlutterAppBadger.updateBadgeCount(notifs.length);
                      return Badge(
                        position: BadgePosition.topEnd(top: 5, end: 3),
                        animationDuration: Duration(milliseconds: 300),
                        animationType: BadgeAnimationType.slide,
                        badgeContent: Text(
                          notifs.length.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Get.to(() => UserNotificationScreen(), fullscreenDialog: true);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => UserNotificationScreen(),
                                fullscreenDialog: true,
                              ),
                            );
                          },
                          icon: Icon(Icons.notifications_rounded),
                        ),
                      );
                    }
                  },
                ),
              ],
              title: Text(
                'Bienvenue !',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  letterSpacing: -1,
                ),
              ),
              centerTitle: true,
            ),
            body: Container(
              width: double.infinity,
              height: size.height - appbar.preferredSize.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: (size.height -
                            (appbar.preferredSize.height +
                                window.padding.top)) *
                        0.25,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        // border: Border.all(),
                        ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Nos services',
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  letterSpacing: -1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: !typesDeService.isProcessing
                              ? Center(
                                  child: Platform.isIOS
                                      ? CupertinoActivityIndicator()
                                      : CircularProgressIndicator(),
                                )
                              : ListView.builder(
                                  key: PageStorageKey('services'),
                                  itemCount: services.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, i) {
                                    final service = services[i];
                                    var color;
                                    if (i == 0) color = Colors.cyan;
                                    if (i == 1) color = Color(0XFFD2D6EA);
                                    if (i == 2) color = Colors.brown;
                                    return GestureDetector(
                                      onTap: () {
                                        // Navigator.of(context).push(
                                        //   MaterialPageRoute(
                                        //     fullscreenDialog: true,
                                        //     builder: (_) => ServicesDetailsScreen(
                                        //       serviceType: "${service.nomService}",
                                        //     ),
                                        //   ),
                                        // );
                                        Get.to(
                                          () => ServicesDetailsScreen(
                                            serviceType:
                                                "${service.nomService}",
                                          ),
                                          // fullscreenDialog: true,
                                        );
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.all(6),
                                        padding: EdgeInsets.all(6),
                                        width: size.width / 3.3,
                                        decoration: BoxDecoration(
                                          color: color,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.14),
                                              offset: Offset(2, 2),
                                              blurRadius: 2,
                                            )
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FaIcon(
                                              i == 0
                                                  ? FontAwesomeIcons.stethoscope
                                                  : i == 1
                                                      ? FontAwesomeIcons
                                                          .notesMedical
                                                      : FontAwesomeIcons
                                                          .infoCircle,
                                              size: size.height / 15,
                                              color: i == 2 || i == 0
                                                  ? Colors.white
                                                  : null,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              services[i].nomService.toString(),
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                color: i == 2 || i == 0
                                                    ? Colors.white
                                                    : null,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),

                  //! espace ici
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: (size.height -
                            (appbar.preferredSize.height +
                                window.padding.top)) *
                        0.25,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        // border: Border.all(),
                        ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Nos spécialités',
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  letterSpacing: -1,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => CategorieListPage(),
                                    ),
                                  );
                                },
                                child: seeMoreButton(),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: !departementProvider.isProcessing
                              ? Center(
                                  child: Platform.isIOS
                                      ? CupertinoActivityIndicator()
                                      : CircularProgressIndicator(),
                                )
                              : ListView(
                                  key: PageStorageKey('Specialies'),
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  children: List.generate(
                                    departementList.length != 0 ? 3 : 0,
                                    (index) {
                                      departementList.sort((a, b) => a
                                          .departementService!
                                          .compareTo(b.departementService!));
                                      final departement =
                                          departementList[index];

                                      // var departImg;
                                      // switch (index) {
                                      //   case 0:
                                      //     departImg = "medgen.png";
                                      //     break;
                                      //   case 1:
                                      //     departImg = "gyneco.png";
                                      //     break;
                                      //   case 2:
                                      //     departImg = "pharma.png";
                                      //     break;
                                      //   case 3:
                                      //     departImg = "urgence.png";
                                      //     break;
                                      //   default:
                                      // }

                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  CategoriesDetailsScreen(
                                                "${departement.departementService}",
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 3),
                                          width: size.width / 3.3,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.14),
                                                  offset: Offset(2, 2),
                                                  blurRadius: 2)
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: size.height / 12,
                                                width: size.height / 12,
                                                child: Image.network(
                                                  "http://allodocteurplus.com/images/departement_service/${departement.departementImage}",
                                                  loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    }
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator
                                                              .adaptive(
                                                        value: loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                loadingProgress
                                                                    .expectedTotalBytes!
                                                            : null,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                '${departement.departementService}'
                                                    .capitalizeFirst
                                                    .toString(),
                                                style: GoogleFonts.quicksand(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13,
                                                ),
                                                overflow: TextOverflow.clip,
                                                softWrap: true,
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  //! espace ici
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: (size.height -
                            (appbar.preferredSize.height +
                                window.padding.top)) *
                        0.30,
                    width: double.infinity,
                    // padding: EdgeInsets.only(bottom: 25),
                    decoration: BoxDecoration(
                        // border: Border.all(),
                        ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Nos praticiens',
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    letterSpacing: -1),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => PraticianListPage(),
                                    ),
                                  );
                                },
                                child: seeMoreButton(),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: !praticienController.isProcessing
                              ? Center(
                                  child: Platform.isIOS
                                      ? CupertinoActivityIndicator()
                                      : CircularProgressIndicator(),
                                )
                              : ListView(
                                  key: PageStorageKey('praticiens'),
                                  scrollDirection: Axis.horizontal,
                                  children: List.generate(
                                    praticienList.length,
                                    (index) {
                                      final praticien = praticienList[index];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  PraticianDetailsScreen(
                                                praticien.idPraticien
                                                    .toString(),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin:
                                              EdgeInsets.fromLTRB(8, 0, 8, 3),
                                          padding: EdgeInsets.all(10),
                                          width: size.width / 2.5,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.14),
                                                offset: Offset(2, 2),
                                                blurRadius: 2,
                                              )
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                        height: double.infinity,
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black38
                                                              .withAlpha(14),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        child: praticien
                                                                    .imagePraticien ==
                                                                null
                                                            ? Center(
                                                                child: FaIcon(
                                                                  FontAwesomeIcons
                                                                      .userMd,
                                                                  color: Colors
                                                                      .black
                                                                      .withAlpha(
                                                                          70),
                                                                  size: 45,
                                                                ),
                                                              )
                                                            : ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                child: Image
                                                                    .network(
                                                                  "https://allodocteurplus.com/api/${praticien.imagePraticien}",
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        color: Colors.white,
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                FaIcon(
                                                                  FontAwesomeIcons
                                                                      .solidCircle,
                                                                  size: 12,
                                                                  color: praticien
                                                                              .online ==
                                                                          'online'
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .orange,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        'Dr. ${praticien.nomPraticien}',
                                                        overflow:
                                                            TextOverflow.clip,
                                                        style: GoogleFonts
                                                            .quicksand(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      '${praticien.specialitePraticien}',
                                                      style: GoogleFonts.nunito(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0XFF59BCC4),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                        // color: Colors.grey,
                        // info space
                        ),
                  ),
                ],
              ),
            ),
          )
        : NoInternetWidget(hasInternet, result);
  }

  Container seeMoreButton() {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ' Voir plus ',
            style: GoogleFonts.montserrat(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Icon(
            Icons.arrow_forward_rounded,
            size: 15,
          ),
        ],
      ),
    );
  }
}
