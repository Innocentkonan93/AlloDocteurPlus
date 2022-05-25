// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:io';
import 'package:app_allo_docteur_plus/data/controllers/UsersController.dart';
import 'package:app_allo_docteur_plus/data/models/UserDocuments.dart';
import 'package:app_allo_docteur_plus/data/services/ApiService.dart';
import 'package:app_allo_docteur_plus/data/services/PDFApi.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserMedicalInfo extends StatefulWidget {
  const UserMedicalInfo({Key? key}) : super(key: key);

  @override
  _UserMedicalInfoState createState() => _UserMedicalInfoState();
}

class _UserMedicalInfoState extends State<UserMedicalInfo> {
  File? file;
  String status = "";
  String? base64Image;
  String? fileName;
  String? userEmail;
  String? userDossier;
  bool isLoading = false;
  Future<List<UserDocuments>>? userDocList;

  Future<String> getUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('userEmail').toString();
    userDossier = prefs.getString('userDossier').toString();
    setState(() {});
    return userEmail!;
  }

  Future chooseImage(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
    );

    if (result != null) {
      final filesPaths = result.files.single.path;
      setState(() {
        file = File(filesPaths!);
        base64Image = file!.readAsBytesSync().toString();

        fileName = (file!.path.split('/').last);
        print(fileName);
      });
      ApiService.uploadUserDoc(context, file!, "$userEmail", "$userDossier")
          .then((value) {
        setState(() {});
      });
    } else {
      return;
    }
  }

  Future uploadDoc(
    BuildContext context,
    File imageFile,
    String userEmail,
    String userDossier,
  ) async {
// ignore: deprecated_member_use
    var stream = new http.ByteStream(StreamView(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse("https://allodocteurplus.com/api/uploadUserDoc.php");

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);
    request.fields['name'] = imageFile.path.split('/').last;
    request.fields['nom_document'] = "document";
    request.fields['email_utilisateur'] = userEmail;
    request.fields['dossier_utilisateur'] = userDossier;

    var respond = await request.send();
    if (respond.statusCode == 200) {
      print("Image Uploaded");
      final respStr = await respond.stream.bytesToString();
      print(respStr);
      if (respStr == "updated") {
        Navigator.of(context).pop("updated");
      }
    } else {
      print("Upload Failed");
    }
  }

  @override
  void initState() {
    getUserEmail();
    ApiService.getAllUtilisateurs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final users = Provider.of<UsersController>(context);
    final currentUserList = users.listUsers;
    final currentUser = currentUserList.first;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // leading: IconButton(
        //   iconSize: 17,
        //   icon: Icon(
        //     Icons.cancel,
        //     size: 25,
        //     color: Colors.red[300],
        //   ),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        // title: Text(
        //   'Dossier médical',
        //   style: GoogleFonts.quicksand(
        //     color: Colors.black,
        //     fontSize: 22,
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.folder_badge_person_crop,
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
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: FutureBuilder<List<UserDocuments>>(
                  future: ApiService.getAllUserDoc("$userEmail"),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<UserDocuments>> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Une erreur s\'est produite'),
                      );
                    } else {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        );
                      } else {
                        List<UserDocuments> documents = snapshot.data!;

                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(0, 0),
                                      blurRadius: 2,
                                      spreadRadius: 5,
                                    )
                                  ]),
                              child: Column(
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
                                                  BorderRadius.circular(12)),
                                          child: Text(
                                            '${currentUser.tailleUtilisateur} cm',
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                                color: Colors.blue[900]),
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
                                                  BorderRadius.circular(12)),
                                          child: Text(
                                            '${currentUser.poidsUtilisateur} kg',
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                                color: Colors.blue[900]),
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
                                                  BorderRadius.circular(12)),
                                          child: Text(
                                            '${currentUser.gsUtilisateur}',
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                                color: Colors.red[900]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: documents.length == 0
                                  ? Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            CupertinoIcons.zzz,
                                            size: 50,
                                          ),
                                          SizedBox(height: 20),
                                          // Icon(CupertinoIcons.doc, size: 70,),
                                          Text(
                                            "Dossier médical vide",
                                            style: GoogleFonts.nunito(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Scrollbar(
                                      radius: Radius.circular(12),
                                      child: GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                          childAspectRatio: 1,
                                        ),
                                        padding: EdgeInsets.all(15),
                                        itemBuilder: (context, i) {
                                          final document = documents[i];
                                          final userDoc = userDossier
                                              .toString()
                                              .split("../")
                                              .last;
                                          final fileExt = document.fileName!
                                              .split('.')
                                              .last;

                                          return Column(
                                            // mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                child: documents.length - 1 == i
                                                    ? Badge(
                                                        shape:
                                                            BadgeShape.square,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        position: BadgePosition
                                                            .topEnd(
                                                                top: -1,
                                                                end: -2),
                                                        padding:
                                                            EdgeInsets.all(2),
                                                        badgeColor: Colors.blue,
                                                        badgeContent: Text(
                                                          'NEW',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            final endPoint =
                                                                "https://allodocteurplus.com/DossiersMedicaux/$userEmail/${document.fileName}";
                                                            await PDFApi
                                                                .loadNetwork(
                                                                    endPoint);
                                                          },
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                              // color: Colors.grey
                                                              //     .withAlpha(101),
                                                              color: Colors.blue
                                                                  .withOpacity(
                                                                      0.1),

                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                FaIcon(
                                                                  fileExt ==
                                                                          "pdf"
                                                                      ? FontAwesomeIcons
                                                                          .solidFilePdf
                                                                      : FontAwesomeIcons
                                                                          .image,
                                                                  color: fileExt ==
                                                                          "pdf"
                                                                      ? Colors.red[
                                                                          800]
                                                                      : Colors
                                                                          .blue,
                                                                  size: 50,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : GestureDetector(
                                                        onTap: () async {
                                                          final endPoint =
                                                              "https://allodocteurplus.com/DossiersMedicaux/$userEmail/${document.fileName}";
                                                          await PDFApi
                                                              .loadNetwork(
                                                                  endPoint);
                                                        },
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            // color: Colors.grey
                                                            //     .withAlpha(101),
                                                            color: Colors.blue
                                                                .withOpacity(
                                                                    0.1),

                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              FaIcon(
                                                                fileExt == "pdf"
                                                                    ? FontAwesomeIcons
                                                                        .solidFilePdf
                                                                    : FontAwesomeIcons
                                                                        .image,
                                                                color: fileExt ==
                                                                        "pdf"
                                                                    ? Colors.red[
                                                                        800]
                                                                    : Colors
                                                                        .blue,
                                                                size: 50,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2),
                                                child: Text(
                                                  "${document.fileName}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style:
                                                      TextStyle(fontSize: 11),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            ],
                                          );
                                        },
                                        itemCount: documents.length,
                                      ),
                                    ),
                            ),
                          ],
                        );
                      }
                    }
                  },
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 0),
                  blurRadius: 2,
                  spreadRadius: 5,
                )
              ]),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        chooseImage(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.orange.withAlpha(152),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.square_arrow_down),
                            SizedBox(width: 15),
                            Text(
                              'Ajouter doc.',
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  letterSpacing: -0.1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(width: 10),
                  // Expanded(
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       Get.to(() => Scaffold());
                  //     },
                  //     child: Container(
                  //       padding: EdgeInsets.all(10),

                  //       decoration: BoxDecoration(
                  //         color: Colors.blue.withAlpha(152),
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       // width: double.infinity,
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           Icon(CupertinoIcons.pencil_ellipsis_rectangle),
                  //           SizedBox(width: 15),
                  //           Text(
                  //             'Modifier info.',
                  //             style: GoogleFonts.montserrat(
                  //                 fontWeight: FontWeight.w500,
                  //                 fontSize: 14,
                  //                 letterSpacing: -0.1),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
