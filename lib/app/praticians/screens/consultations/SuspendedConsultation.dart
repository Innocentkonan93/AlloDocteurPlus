import 'package:google_fonts/google_fonts.dart';

import '../../../utils/processs/chat/ChatScreen.dart';
import '../../../../data/controllers/PraticienController.dart';
import '../../../../data/controllers/UserConsultationController.dart';
import '../../../../data/services/ApiService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SuspendedConsultation extends StatefulWidget {
  const SuspendedConsultation({Key? key}) : super(key: key);

  @override
  _SuspendedConsultationState createState() => _SuspendedConsultationState();
}

class _SuspendedConsultationState extends State<SuspendedConsultation> {
  FirebaseFirestore _db = FirebaseFirestore.instance;
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
    String emailUtilisateur,
    String emailPraticien,
  ) async {
    _db.collection("notifications/yBlfDOUJ9hair4CP2aC4/utilisateurs").add(
      {
        "title": "Reprise consultation",
        "body": "Votre praticien à repris la consultation, réjoignez-le !",
        "notif_date": Timestamp.now(),
        "topic_receiver": topic,
        "user_receiver": emailUtilisateur,
        "channel": idDemande,
        "pratician_email": emailPraticien,
        "isView": false,
        "route_name": "chat_screen"
      },
    );
  }

  @override
  void initState() {
    getAllConsultations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final praticienController = Provider.of<PraticienController>(context);
    final currentPraticien = praticienController.listPraticiens.first;
    final consultations = Provider.of<UserConsultationController>(context);
    final consultationsList = consultations.listConsultations;
    final consultationsSuspended = consultationsList
        .where((consultation) =>
            consultation.statutConsultation == 'standby' ||
            consultation.statutConsultation == 'created')
        .where((consultation) =>
            consultation.emailPraticien == currentPraticien.emailPraticien)
        .toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF101A69),
        elevation: 0.0,
        title: Text(
          'Consultations en cours',
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            letterSpacing: -1,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: consultationsSuspended.length == 0
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.boxOpen,
                            size: 50,
                            color: Colors.black26,
                          ),
                          Text('Aucune consultation en cours'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        final consultation = consultationsSuspended[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 5,
                          ),
                          child: ListTile(
                            tileColor: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            title: Text(
                              'Suspendue',
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            leading: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.pending_actions_rounded,
                                  size: 40,
                                  color: Colors.orange[400],
                                ),
                              ),
                            ),
                            onTap: () async {
                              var topic =
                                  consultation.emailPatient!.split("@").first;
                              if (topic.contains(".")) {
                                topic = topic.split('.').last;
                              }
                              await addNotif(
                                topic,
                                "${consultation.idDemande}",
                                "${consultation.emailPatient}",
                                "${consultation.emailPraticien}",
                              );
                              await Get.to(
                                () => ChatScreen(
                                  "${consultation.emailPatient}",
                                  "${consultation.emailPraticien}",
                                  "${consultation.idDemande}",
                                ),
                              );
                              getAllConsultations();
                            },
                            subtitle:
                                Text("Ref: 212800${consultation.idConsultation}"),
                            trailing: ElevatedButton(
                              child: Text(
                                "Reprendre",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: () async {
                                var topic =
                                    consultation.emailPatient!.split("@").first;
                                if (topic.contains(".")) {
                                  topic = topic.split('.').last;
                                }
                                await addNotif(
                                  topic,
                                  "${consultation.idDemande}",
                                  "${consultation.emailPatient}",
                                  "${consultation.emailPraticien}",
                                );
                                await Get.to(
                                  () => ChatScreen(
                                    "${consultation.emailPatient}",
                                    "${consultation.emailPraticien}",
                                    "${consultation.idDemande}",
                                  ),
                                );
                                getAllConsultations();
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0.0,
                                  primary: Color(0XFF101A69),
                                  shape: StadiumBorder()),
                            ),
                          ),
                        );
                      },
                      itemCount: consultationsSuspended.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
