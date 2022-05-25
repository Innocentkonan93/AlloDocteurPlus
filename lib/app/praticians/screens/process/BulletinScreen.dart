import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/models/Praticien.dart';
import '../../../../data/controllers/PraticienController.dart';
import '../../../../data/models/User.dart';
import '../../../../data/services/ApiService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BulletinScreen extends StatefulWidget {
  final String idDemande;
  final User patient;
  final Praticien praticien;
  const BulletinScreen(this.idDemande, this.patient, this.praticien, {Key? key})
      : super(key: key);

  @override
  _BulletinScreenState createState() => _BulletinScreenState();
}

class _BulletinScreenState extends State<BulletinScreen> {
  final pdf = pw.Document();
  final inputController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseFirestore _db = FirebaseFirestore.instance;
  List<String> prescriptionList = [];
  bool isLoading = false;
  String? uid;
  String? userType;

  void addPrescription(String medoc) {
    setState(() {
      prescriptionList.add(medoc);
    });
    inputController.clear();
    Navigator.of(context).pop();
  }

  Future<File?> getSignature(String url, String fileName) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$fileName');

    try {
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      print(file.path);
    } catch (e) {
      return null;
    }
    return file;
  }

  writeOnPdf(String praticienNumer) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final font = await rootBundle.load("assets/fonts/OpenSans-Regular.ttf");
    final logo = (await rootBundle.load("assets/images/allo-logo.png"))
        .buffer
        .asUint8List();
    final ttf = pw.Font.ttf(font);
    final praticianNom = prefs.getString("praticianNom");
    final departement = prefs.getString("praticianDepartement");

    var url =
        "https://allodocteurplus.com/Images/sign/${widget.praticien.signaturePraticien}";
    var file =
        await getSignature(url, widget.praticien.signaturePraticien.toString());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(8),
        build: (pw.Context context) {
          return pw.Column(children: <pw.Widget>[
            pw.Header(
              margin: pw.EdgeInsets.all(10),
              padding: pw.EdgeInsets.all(10),
              level: 0,
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "${widget.patient.nomUtilisateur}",
                          style: pw.TextStyle(font: ttf),
                        ),
                        pw.Text(
                          "${widget.patient.numeroUtilisateur}",
                          style: pw.TextStyle(font: ttf),
                        ),
                        pw.Row(children: [
                          pw.Text(
                            "Service: ",
                            style: pw.TextStyle(font: ttf),
                          ),
                          pw.Text(
                            "$departement",
                            style: pw.TextStyle(font: ttf),
                          )
                        ])
                      ],
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Image(pw.MemoryImage(logo), width: 90, height: 60),
                        pw.Text(
                          "support@allodocteurplus.com",
                          style: pw.TextStyle(font: ttf),
                        ),
                        pw.Text(
                          "$praticienNumer",
                          style: pw.TextStyle(font: ttf, letterSpacing: -0.8),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            buildTitle(),
            pw.SizedBox(height: 1 * PdfPageFormat.cm),
            pw.ListView(
              padding: pw.EdgeInsets.symmetric(horizontal: 40),
              spacing: 1.4 * PdfPageFormat.cm,
              children: List.generate(
                prescriptionList.length,
                (index) {
                  return pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Text(
                        "${index + 1}/.  ",
                        style: pw.TextStyle(fontSize: 17),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          prescriptionList[index],
                          maxLines: 3,
                          // overflow: TextOverflow.ellipsis,
                          style: pw.TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            pw.Spacer(),
            pw.Divider(),
            pw.Footer(
              margin: pw.EdgeInsets.all(18),
              padding: pw.EdgeInsets.all(10),
              leading: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Text(
                    'Dr. $praticianNom',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  if (widget.praticien.signaturePraticien != null)
                    pw.Image(
                      pw.MemoryImage(file!.readAsBytesSync()),
                      width: 90,
                      height: 60,
                    ),
                ],
              ),
              trailing: pw.SizedBox(
                height: 30,
                width: 30,
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: "${widget.idDemande}",
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }

  Future savePdf() async {
    String userDossier =
        "../DossiersMedicaux/${widget.patient.emailUtilisateur}";
    final bytes = await pdf.save();
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String dir = documentDirectory.path;

    File file = File("$dir/BUL${DateTime.now().toString()}" + ".pdf");

    file.writeAsBytesSync(bytes, flush: true);

    file.path.split('/').last;
//  showFile(context, file.path);
    String nomDocument = 'BULLETIN';

    ApiService.uploadPraticianPrescription(
      context,
      file,
      "${widget.praticien.emailPraticien}",
      "${widget.praticien.nomPraticien}",
      "${widget.praticien.specialitePraticien}",
      nomDocument,
    );

    ApiService.uploadUserDoc(
      context,
      file,
      "${widget.patient.emailUtilisateur}",
      userDossier,
    ).then((value) {
      sendMessage();
      print("uploaded");
    });
    ApiService.updateConsultation(widget.idDemande);
    // PdfApi.openFile(file);
  }

  // Future openPdf() async {
  //   final bytes = await pdf.save();
  //   Directory documentDirectory = await getApplicationDocumentsDirectory();
  //   String dir = documentDirectory.path;

  //   File file = File("$dir/BUL${DateTime.now().toString()}" + ".pdf");

  //   file.writeAsBytesSync(bytes, flush: true);

  //   PdfApi.openFile(file);
  // }

  static pw.Widget buildTitle() {
    var date = DateFormat(
      'dd-MM-yyyy',
    ).format(
      DateTime.now(),
    );
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Text(
          'BULLETIN MÉDICAL',
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 0.6 * PdfPageFormat.cm),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 20),
              child: pw.Text(
                'Fait le $date',
                style: pw.TextStyle(
                  fontSize: 13,
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  showFile(BuildContext context, String filePath) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            iconTheme: IconThemeData(color: Colors.black),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close),
            ),
          ),
          body: PDFView(
            filePath: filePath,
          ),
        ),
      ),
    );
  }

  Future<String> getTypedUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = prefs.getString('userType').toString();
    return userType!;
  }

  Future<String> getUserID() async {
    Future.delayed(Duration(seconds: 20));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userID = prefs.getString('userID').toString();

    return userID;
  }

  Future<String> getPraticianID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String praticianID = prefs.getString('praticianID').toString();
    return praticianID;
  }

  Future<void> getID() async {
    String userType = await getTypedUserData();

    if (userType == "utilisateurs") {
      uid = await getUserID();
    } else {
      uid = await getPraticianID();
    }
  }

  void sendMessage() async {
    await _db
        .collection('chat/SzUELV4apD6ckKM8xHpY/channel')
        .doc(widget.idDemande)
        .collection("message")
        .add({
      'text':
          "Un bulletin médical vous a été assigné, vérifiez votre dossier médical",
      'sentAt': DateTime.now().toString(),
      'uid': uid,
    });
    addUserNotif();
  }

  Future<void> addUserNotif() async {
    var topic = widget.patient.emailUtilisateur!.split("@").first;
    if (topic.contains(".")) {
      topic = topic.split('.').last;
    }
    _db.collection("notifications/yBlfDOUJ9hair4CP2aC4/utilisateurs").add(
      {
        "title": "Nouveau bulletin",
        "body":
            "Un bulletin médical vous a été assigné, vérifiez votre dossier médical",
        "notif_date": Timestamp.now(),
        "topic_receiver": topic,
        "user_receiver": widget.patient.emailUtilisateur,
        "pratician_email": widget.praticien.emailPraticien,
        "channel": widget.idDemande,
        "isView": false,
        "route_name": ""
      },
    );
  }

  @override
  void initState() {
    getID();
    super.initState();
  }
  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // final consultationController =
    //     Provider.of<UserConsultationController>(context);
    // final currentConsulation = consultationController.listConsultations
    //     .where((consultation) => consultation.idDemande == widget.idDemande);

    final praticianController = Provider.of<PraticienController>(context);
    final currentPraticien = praticianController.listPraticiens.first;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData.fallback(),
        title: Text(
          'Nouveau bulletin',
          style: GoogleFonts.nunito(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              letterSpacing: -1,
              color: Colors.black,
            ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () async {
            prescriptionList.clear();
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.close,
            size: 17,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Container(
                // width: double.infinity,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Text(
                          '${index + 1} - ',
                          style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            prescriptionList[index],
                            style: GoogleFonts.nunito(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 3,
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              prescriptionList.remove(prescriptionList[index]);
                            });
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 18,
                          ),
                        ),
                      ],
                    );
                  },
                  itemCount: prescriptionList.length,
                  // itemExtent: 50,
                ),
              ),
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    // isScrollControlled: true,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return newPrescription();
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      prescriptionList.length == 0 ? 'Prescrire' : "Ajouter",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Icon(Icons.add),
                  ],
                ),
                style: TextButton.styleFrom(
                  elevation: 0.0,
                  fixedSize: Size(150, 40),
                ),
              )
            ],
          ),
        ),
      ),
      // floatingActionButton: prescriptionList.isEmpty
      //     ? Container()
      //     : Container(
      //         child: ButtonBar(
      //           alignment: MainAxisAlignment.center,
      //           children: [
      //             FloatingActionButton.extended(
      //               onPressed: () async {
      //                 await writeOnPdf("${currentPraticien.numeroPraticien}");
      //                 await openPdf();
      //               },
      //               backgroundColor: Colors.white,
      //               label: Text(
      //                 'Voir',
      //                 style: TextStyle(color: Colors.green),
      //               ),
      //             ),
      //             SizedBox(width: 10),
      //             FloatingActionButton.extended(
      //               onPressed: () async {
      //                 setState(() {
      //                   isLoading = true;
      //                 });
      //                 await writeOnPdf("${currentPraticien.numeroPraticien}");
      //                 await savePdf().then((value) {
      //                   Navigator.of(context).pop();
      //                 });
      //               },
      //               backgroundColor: Colors.green,
      //               label: isLoading == true
      //                   ? SizedBox(
      //                       height: 30,
      //                       width: 30,
      //                       child: CircularProgressIndicator.adaptive(),
      //                     )
      //                   : Text('Prescrire'),
      //             ),
      //           ],
      //         ),
      // ),

      floatingActionButton: prescriptionList.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await writeOnPdf("${currentPraticien.numeroPraticien}");
                await savePdf().then((value) {
                  Navigator.of(context).pop();
                });
              },
              backgroundColor: Colors.green,
              label: isLoading == true
                  ? SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : Text('Prescrire'),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget newPrescription() {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          children: [
            TextField(
              controller: inputController,
              decoration: InputDecoration(hintText: "Examens..."),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 2,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 20),
            TextButton.icon(
              style: TextButton.styleFrom(primary: Colors.green),
              onPressed: () {
                addPrescription(inputController.text);
              },
              icon: Icon(CupertinoIcons.add_circled),
              label: Text(
                'Ajouter',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
