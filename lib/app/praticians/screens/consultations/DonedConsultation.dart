import 'package:google_fonts/google_fonts.dart';

import '../../../../data/controllers/PraticienController.dart';
import '../../../../data/controllers/UserConsultationController.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DonedConsultation extends StatefulWidget {
  const DonedConsultation({Key? key}) : super(key: key);

  @override
  _DonedConsultationState createState() => _DonedConsultationState();
}

class _DonedConsultationState extends State<DonedConsultation> {
  @override
  Widget build(BuildContext context) {
    final praticienController = Provider.of<PraticienController>(context);
    final currentPraticien = praticienController.listPraticiens.first;
    final consultationController =
        Provider.of<UserConsultationController>(context);
    final consultationsList = consultationController.listConsultations;
    final praticianDonededconsultation = consultationsList
        .where((donedConsultation) =>
            donedConsultation.emailPraticien == currentPraticien.emailPraticien)
        .toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF101A69),
        elevation: 0.0,
        title: Text('Demandes traitées', style: GoogleFonts.nunito(
        fontWeight: FontWeight.w500,
        fontSize: 20,
        letterSpacing: -1,
      ),),
        centerTitle: true,
        leading: BackButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child:
                Center(child: Text("${praticianDonededconsultation.length}")),
          )
        ],
      ),
      body: praticienController.isProcessing &&
              consultationController.isProcessing
          ? Scrollbar(
            radius: Radius.circular(10),
              child: ListView.builder(
                itemCount: praticianDonededconsultation.length,
                itemBuilder: (context, index) {
                  final consultation = praticianDonededconsultation[index];
                  var date = DateFormat(
                    'dd.MM.yy HH:mm',
                  ).format(DateTime.tryParse(consultation.dateConsultation!)!
                      .toLocal());
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      leading: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.green[400],
                          ),
                        ),
                      ),
                      title: Text(
                        "ref: 212800${consultation.idConsultation}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      subtitle: Column(
                        children: [
                          Row(
                            children: [
                              Text('Terminée le'),
                              SizedBox(width: 5),
                              Text(
                                "${date}",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                consultation.ordonnanceConsultation == "OUI"
                                    ? 'Avec prescription'
                                    : 'Sans prescription',
                                style: TextStyle(
                                  color: consultation.ordonnanceConsultation ==
                                          "OUI"
                                      ? Colors.green
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Icon(
                        Icons.info_outline_rounded,
                        size: 24,
                        color: Color(0XFF101A69).withOpacity(0.4),
                      ),

                      // isThreeLine: true,
                      tileColor: Colors.grey[200],

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              insetAnimationCurve: Curves.bounceInOut,
                              insetAnimationDuration: Duration(seconds: 10),
                              child: Container(
                                padding: EdgeInsets.all(10),
                                // height: 200,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '212808${consultation.idConsultation}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    
                                    Divider(),
                                    Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.white12,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.check,
                                          size: 40,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Terminée le',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "${date}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                          consultation.ordonnanceConsultation ==
                                                  "OUI"
                                              ? 'Avec prescription'
                                              : 'Sans prescription',
                                          style: TextStyle(
                                            color: consultation
                                                        .ordonnanceConsultation ==
                                                    "OUI"
                                                ? Colors.green
                                                : Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                    Divider(),
                                    TextButton(onPressed: (){
                                      Navigator.pop(context);
                                    }, child: Text('OK'))
                                  ],
                                ),
                              ),
                            );
                      },
                    );
                      })
                  );
                },
              ),
            )
          : Center(
              child: CircularProgressIndicator.adaptive(),
            ),
    );
  }
}
