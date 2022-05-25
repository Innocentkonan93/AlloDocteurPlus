// ignore_for_file: unused_local_variable

import 'dart:async';
import 'package:app_allo_docteur_plus/app/utils/processs/chat/ChatScreen.dart';
import 'package:app_allo_docteur_plus/app/utils/widgets/NoInternetWidget.dart';
import 'package:app_allo_docteur_plus/data/controllers/PraticienController.dart';
import 'package:app_allo_docteur_plus/data/controllers/UsersController.dart';
import 'package:app_allo_docteur_plus/data/models/Demandes.dart';
import 'package:app_allo_docteur_plus/data/services/ApiService.dart';
import 'package:app_allo_docteur_plus/data/services/FirestoreService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DemandesScreenWidget extends StatefulWidget {
  const DemandesScreenWidget({Key? key}) : super(key: key);

  @override
  _DemandesScreenWidgetState createState() => _DemandesScreenWidgetState();
}

class _DemandesScreenWidgetState extends State<DemandesScreenWidget> {
  PageController pageController = PageController();
  FirebaseFirestore _db = FirebaseFirestore.instance;
  bool hasInternet = true;
  bool isAcceptationProcessing = false;
  late StreamSubscription internetsubscription;
  late StreamSubscription connectivitySubscription;

  ConnectivityResult result = ConnectivityResult.none;
  Future<String> getPraticianDepartement() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String departement =
        prefs.getString('praticianDepartement').toString();
    return departement;
  }

  Stream<List<UserDemande>> get demandStream async* {
    final String department = await getPraticianDepartement();
    for (var i = 0; i > -1; i++) {
      // await Future.delayed(Duration(milliseconds: 500));

      // yield await ApiService.getAllWaitDemandeByDepartment("$department");
      // yield await ApiService.getAllAcceptDemandes("Pharmacie");
      yield await ApiService.getAllWaitDemande();

      i++;
    }
  }

  Duration duration = Duration(seconds: 10);
  Future acceptingDemande(
      String emailUser,
      String emailPraticien,
      String idDemande,
      String? fichierConsulation,
      String? descriptionOrMofif) async {
    setState(() {
      isAcceptationProcessing = true;
    });
    final result =
        await ApiService.acceptDemande(idDemande, emailPraticien).then((value) {
      ApiService.newConsultation(
        emailUser,
        emailPraticien,
        idDemande,
        fichierConsulation,
      );
    });
    print(result);

    // print(idConsultation);
    print(emailUser);
    print(emailPraticien);
    print(idDemande);

    var topic = emailUser.split("@").first;
    if (topic.contains(".")) {
      topic = topic.split('.').last;
    }

    await _db.collection("notifications/yBlfDOUJ9hair4CP2aC4/utilisateurs").add(
      {
        "title": "Début consultation",
        "body": "Votre consultation à débuté réjoingnez votre médecin",
        "notif_date": Timestamp.now(),
        "topic_receiver": topic,
        "user_receiver": emailUser,
        "channel": idDemande,
        "pratician_email": emailPraticien,
        "isView": false,
        "route_name": "chat_screen"
      },
    );

    await FirestoreService().createChannel(idDemande);
    Get.to(
      () => ChatScreen(
        emailUser,
        emailPraticien,
        idDemande,
        descritpionOrMotif: descriptionOrMofif,
      ),
      fullscreenDialog: true,
    );
  }

  Future<void> getCurrentUserData() async {
    // var userID = await getUserID();
    var resp = await ApiService.getAllUtilisateurs();
    var provider = Provider.of<UsersController>(context, listen: false);

    if (resp.isSuccesful) {
      provider.setUserList(resp.data);

      provider.isProces(resp.isSuccesful);
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final praticienController = Provider.of<PraticienController>(context);
    final currentPraticien = praticienController.listPraticiens.first;

    return hasInternet
        ? Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(
                'Les demandes',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  letterSpacing: -1,
                ),
              ),
              elevation: 0.0,
              backgroundColor: Color(0XFF101A69),
              // ignore: deprecated_member_use
              brightness: Brightness.dark,
              centerTitle: true,
            ),
            body: Scrollbar(
              child: StreamBuilder<List<UserDemande>>(
                stream: demandStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<UserDemande>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      List<UserDemande> demandes = snapshot.data!;
                      return RefreshIndicator(
                        onRefresh: () {
                          return ApiService.getAllDemandes();
                        },
                        triggerMode: RefreshIndicatorTriggerMode.onEdge,
                        semanticsLabel: 'Actualisé',
                        child: demandes.length == 0
                            ? Container(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: 200,
                                        width: 200,
                                        child: Image.asset(
                                            "assets/images/standing.png")),
                                    Text(
                                      'Aucune nouvelle demande',
                                      style: GoogleFonts.nunito(),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: demandes.length,
                                itemBuilder: (context, index) {
                                  final demande = demandes[index];
                                  return Container(
                                    clipBehavior: Clip.antiAlias,
                                    key: ValueKey(index),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 8),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                      // borderRadius: BorderRadius.circular(10),
                                      // border: Border(
                                      //   left: demande.departementService ==
                                      //           "Urgence"
                                      //       ? BorderSide(
                                      //           width: 5, color: Colors.red)
                                      //       : BorderSide.none,
                                      // ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.14),
                                          offset: Offset(-2, 2),
                                          blurRadius: 3,
                                        ),
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.14),
                                          offset: Offset(2, -2),
                                          blurRadius: 3,
                                        )
                                      ],
                                    ),
                                    child: ExpansionTile(
                                      title: Text(
                                        "${demande.departementService}",
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17,
                                          color: Color(0XFF101A69),
                                        ),
                                      ),
                                      subtitle: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '${demande.typeDemande}',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      children: [
                                        Divider(),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Text(
                                            "${demande.description}",
                                            style: GoogleFonts.nunito(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: ElevatedButton(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Accepter",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            onPressed: isAcceptationProcessing
                                                ? null
                                                : () async {
                                                    print(demande.description);
                                                    await acceptingDemande(
                                                        "${demande.emailUtilisateur}",
                                                        "${currentPraticien.emailPraticien}",
                                                        "${demande.idDemande}",
                                                        "${demande.fichierDemande}",
                                                        "${demande.description}");
                                                  },
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.all(2),
                                              elevation: 0.0,
                                              primary: Colors.green[800],
                                              // fixedSize: Size(70, 20),
                                              // minimumSize: Size(70, 30),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                  }
                  return Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {});
                      },
                      child: snapshot.hasError
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Rafraichir'),
                                Icon(Icons.refresh),
                              ],
                            )
                          : Container(
                              child: Text('Recupérarion...'),
                            ),
                    ),
                  );
                },
              ),
            ),
          )
        : NoInternetWidget(hasInternet, result);
  }
}
