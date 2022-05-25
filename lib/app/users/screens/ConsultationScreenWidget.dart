import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/processs/chat/ChatScreen.dart';
import '../../utils/widgets/NoInternetWidget.dart';

import '../../../data/controllers/UserConsultationController.dart';
import '../../../data/controllers/UsersController.dart';
import '../../../data/services/ApiService.dart';
import '../../../data/services/PDFApi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

class ConsultationScreenWidget extends StatefulWidget {
  const ConsultationScreenWidget({Key? key}) : super(key: key);

  @override
  _ConsultationScreenWidgetState createState() =>
      _ConsultationScreenWidgetState();
}

class _ConsultationScreenWidgetState extends State<ConsultationScreenWidget> {
  late StreamSubscription internetSubscription;
  late StreamSubscription connectivitySubscription;
  ConnectivityResult result = ConnectivityResult.none;
  PageController pageController = PageController();
  FirebaseFirestore _db = FirebaseFirestore.instance;
  bool hasInternet = true;
  late StreamSubscription internetsubscription;
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

  Future<void> addNotif(
    String topic,
    String idDemande,
    String emailPraticien,
    String emailPatient,
  ) async {
    _db.collection("notifications/yBlfDOUJ9hair4CP2aC4/praticiens").add(
      {
        "title": "Retour utilisateur",
        "body": "Votre patient à fait son retour dans la conversation",
        "notif_date": Timestamp.now(),
        "topic_receiver": topic,
        "user_receiver": emailPatient,
        "pratician_receiver": emailPraticien,
        "route_name": "chat_screen",
        "channel": idDemande,
        "isView": false,
      },
    );
  }

  AppBar appBar = new AppBar(
    title: Text(
      'Consulations',
      style: GoogleFonts.nunito(
        fontWeight: FontWeight.w500,
        fontSize: 20,
        letterSpacing: -1,
      ),
    ),
    centerTitle: true,
    elevation: 0.9,
  );

  @override
  void initState() {
    getAllConsultations();

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
    final userController = Provider.of<UsersController>(context);
    final currenUser = userController.listUsers.first;
    final consultations = Provider.of<UserConsultationController>(context);
    final consultationsList = consultations.listConsultations;

    final userConsultations = consultationsList
        .where((consultation) =>
            consultation.emailPatient == currenUser.emailUtilisateur)
        .toList();

    final consultationsDone = consultationsList
        .where((consultation) =>
            consultation.statutConsultation == 'done' &&
            consultation.emailPatient == currenUser.emailUtilisateur)
        .toList();
    final consultationsSuspended = consultationsList
        .where((consultation) =>
            consultation.emailPatient == currenUser.emailUtilisateur)
        .where((consultation) =>
            consultation.statutConsultation == "standby" ||
            consultation.statutConsultation == "created")
        .toList();
    final size = MediaQuery.of(context).size;
    return hasInternet
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: appBar,
            body: Container(
              height: size.height - appBar.preferredSize.height,
              child: RefreshIndicator(
                onRefresh: () async {
                  await getAllConsultations();
                },
                edgeOffset: 20,
                displacement: 20,
                child: userConsultations.length == 0
                    ? Center(
                        child: Text(
                          "Aucune consultation effectuée",
                          style: GoogleFonts.nunito(fontSize: 16),
                        ),
                      )
                    : ListView(
                        children: [
                          Container(
                            height: 130,
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 15, top: 15),
                                  child: Row(
                                    children: [
                                      Text(
                                        'En cours',
                                        style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Icon(
                                        Icons.timelapse_outlined,
                                        size: 20,
                                        color: Colors.orange,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: consultationsSuspended.length == 0
                                      ? Center(
                                          child: Text(
                                            'Aucune consultation en cours',
                                            style: GoogleFonts.nunito(fontSize: 16),
                                          ),
                                        )
                                      : ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, i) {
                                            final consulationSuspendues =
                                                consultationsSuspended[i];
                                            return GestureDetector(
                                              onTap: () async {
                                                var topic =
                                                    consulationSuspendues
                                                        .emailPraticien!
                                                        .split("@")
                                                        .first;
                                                if (topic.contains(".")) {
                                                  topic = topic.split('.').last;
                                                }
                                                await addNotif(
                                                    "$topic",
                                                    "${consulationSuspendues.idDemande}",
                                                    "${consulationSuspendues.emailPraticien}",
                                                    "${consulationSuspendues.emailPatient}");
                                                Get.to(
                                                  () => ChatScreen(
                                                    "${consulationSuspendues.emailPatient}",
                                                    "${consulationSuspendues.emailPraticien}",
                                                    "${consulationSuspendues.idDemande}",
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                margin: EdgeInsets.all(15),
                                                padding: EdgeInsets.all(8),
                                                width: size.width / 2.2,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: Colors.orange,
                                                    width: 0.5,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.14),
                                                      offset: Offset(-2, 2),
                                                      blurRadius: 3,
                                                    ),
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.14),
                                                      offset: Offset(2, -2),
                                                      blurRadius: 3,
                                                    )
                                                  ],
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Ref: 212800${consulationSuspendues.idConsultation}",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Continuer',
                                                          style: GoogleFonts.quicksand(
                                                            color:
                                                                Colors.orange,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 18,
                                                            letterSpacing: -0.5,
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons.play_arrow,
                                                          color: Colors.orange,
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount:
                                              consultationsSuspended.length,
                                        ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, bottom: 10, top: 10),
                            child: Row(
                              children: [
                                Text(
                                  "Terminées",
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                FaIcon(
                                  FontAwesomeIcons.check,
                                  size: 15,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: !consultations.isProcessing
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ListView(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    children: List.generate(
                                      consultationsDone.length,
                                      (index) {
                                        final consultation =
                                            consultationsDone[index];
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 15),
                                          height: 70,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.green,
                                                    width: 0.5,
                                                  ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.14),
                                                offset: Offset(-2, 2),
                                                blurRadius: 3,
                                              ),
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.14),
                                                offset: Offset(2, -2),
                                                blurRadius: 3,
                                              )
                                            ],
                                          ),
                                          child: ListTile(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            title: Text(
                                              "Ref: 212800${consultation.idConsultation}",
                                              style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            subtitle: consultation
                                                        .dateModification ==
                                                    null
                                                ? Text(
                                                    'Terminée le ${consultation.dateConsultation}',
                                                    style:
                                                        GoogleFonts.quicksand(
                                                      fontSize: 14,
                                                    ),
                                                  )
                                                : Text(
                                                    'Terminée le ${consultation.dateModification}',
                                                    style:
                                                        GoogleFonts.quicksand(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                            trailing: consultation
                                                        .fichierConsultation !=
                                                    "null"
                                                ? IconButton(
                                                    onPressed: () {
                                                      final endPoint =
                                                          "https://allodocteurplus.com/DossiersMedicaux/${consultation.emailPatient}/${consultation.fichierConsultation}";
                                                      PDFApi.loadNetwork(
                                                          endPoint);
                                                    },
                                                    icon: FaIcon(
                                                      FontAwesomeIcons
                                                          .filePrescription,
                                                      color: Colors.green,
                                                    ),
                                                  )
                                                : null,
                                            onTap: () {},
                                          ),
                                        );
                                      },
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
