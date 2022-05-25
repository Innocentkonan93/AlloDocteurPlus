import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/User.dart';
import '../../../data/models/UserDocuments.dart';
import '../../../data/services/ApiService.dart';
import '../../../data/services/PDFApi.dart';
import 'package:badges/badges.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

class UserInfoModal extends StatefulWidget {
  final User currentUser;
  const UserInfoModal(this.currentUser, {Key? key}) : super(key: key);

  @override
  _UserInfoModalState createState() => _UserInfoModalState();
}

class _UserInfoModalState extends State<UserInfoModal> {
  String? userDossier;
  bool isLoading = false;
  Future<List<UserDocuments>>? userDocList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 6,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.black26, borderRadius: BorderRadius.circular(24)),
          ),
          Text(
            "Dossier médical",
            style: GoogleFonts.montserrat(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: Colors.blue[900]),
          ),
          Container(
            padding: const EdgeInsets.all(8),
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
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          '${widget.currentUser.tailleUtilisateur} cm',
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
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          '${widget.currentUser.poidsUtilisateur} kg',
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
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          '${widget.currentUser.gsUtilisateur}',
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
          Text(
            'Prescriptions et documents',
            style: GoogleFonts.nunito(),
          ),
          Expanded(
            child: Container(
              child: FutureBuilder<List<UserDocuments>>(
                future: ApiService.getAllUserDoc(
                    "${widget.currentUser.emailUtilisateur}"),
                builder: (BuildContext context,
                    AsyncSnapshot<List<UserDocuments>> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Une erreur s\'est produite'),
                    );
                  } else {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator.adaptive());
                    } else {
                      List<UserDocuments> documents = snapshot.data!;

                      return documents.length == 0
                          ? Center(
                              child: Text("Dossier médical vide"),
                            )
                          : GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1,
                              ),
                              padding: EdgeInsets.all(10),
                              itemBuilder: (context, i) {
                                final document = documents[i];
                                final userDoc =
                                    userDossier.toString().split("../").last;
                                final fileExt =
                                    document.fileName!.split('.').last;

                                return Column(
                                  key: ValueKey(i),
                                  // mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: documents.length - 1 == i
                                          ? Badge(
                                              shape: BadgeShape.square,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              position: BadgePosition.topEnd(
                                                  top: -1, end: -2),
                                              padding: EdgeInsets.all(2),
                                              badgeColor: Colors.blue,
                                              badgeContent: Text(
                                                'NEW',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  final endPoint =
                                                      "https://allodocteurplus.com/DossiersMedicaux/${widget.currentUser.emailUtilisateur}/${document.fileName}";
                                                  await PDFApi.loadNetwork(
                                                      endPoint);
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    // color: Colors.grey
                                                    //     .withAlpha(101),
                                                    color: Colors.blue
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
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
                                                        color: fileExt == "pdf"
                                                            ? Colors.red[800]
                                                            : Colors.blue,
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
                                                    "https://allodocteurplus.com/DossiersMedicaux/${widget.currentUser.emailUtilisateur}/${document.fileName}";
                                                await PDFApi.loadNetwork(
                                                    endPoint);
                                                print('josco');
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Colors.blue
                                                      .withOpacity(0.1),
                                                  // color: Colors.grey
                                                  //     .withAlpha(101),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    FaIcon(
                                                      fileExt == "pdf"
                                                          ? FontAwesomeIcons
                                                              .solidFilePdf
                                                          : FontAwesomeIcons
                                                              .image,
                                                      color: fileExt == "pdf"
                                                          ? Colors.red[800]
                                                          : Colors.blue,
                                                      size: 50,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      child: Text(
                                        "${document.fileName}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 11),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                );
                              },
                              itemCount: documents.length,
                            );
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
