import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../users/screens/process/NewDemande.dart';
import '../../data/controllers/ServicesController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CategoriesDetailsScreen extends StatefulWidget {
  final String departement;
  const CategoriesDetailsScreen(this.departement, {Key? key}) : super(key: key);

  @override
  _CategoriesDetailsScreenState createState() =>
      _CategoriesDetailsScreenState();
}

class _CategoriesDetailsScreenState extends State<CategoriesDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final departement = widget.departement;
    final serviceController = Provider.of<ServicesController>(context);
    final servicesList = serviceController.listServicess
        .where((services) => services.departementService == departement)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          departement.toUpperCase(),
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            letterSpacing: -1,
          ),
        ),
        elevation: 0.9,
        centerTitle: true,
      ),
      body: Container(
        height: size.height,
        child: ListView.builder(
          itemBuilder: (context, index) {
            final service = servicesList[index];

            // switch (departement) {
            //   case "Generale":
            //     color = Colors.blue;
            //     break;
            //   case "Gynecologie":
            //     color = Colors.deepOrange;
            //     break;
            //   case "Pharmacie":
            //     color = Colors.greenAccent;
            //     break;
            //   case "Urgence":
            //     color = Colors.red[600];
            //     break;
            //   default:
            // }
            return Container(
              padding: EdgeInsets.all(5),
              child: Card(
                color: Colors.white,
                shadowColor: Colors.black26,
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [ 
                            if (service.nomService == "Consultation")
                              FaIcon(FontAwesomeIcons.stethoscope),
                            if (service.nomService == "Interpretation d'examen")
                              Icon(CupertinoIcons.doc_append),
                            if (service.nomService == "Informations")
                              Icon(CupertinoIcons.info),
                            SizedBox(width: 10),
                            Text(
                              "${service.nomService}",
                              style: GoogleFonts.montserrat(
                                color: Colors.black87,
                                fontSize: 19,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(13),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "${service.descriptionService}",
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.8,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${service.prixService}",
                            style: GoogleFonts.montserrat(
                              letterSpacing: -1,
                              fontWeight: FontWeight.w600,
                              color: service.prixService != "Gratuit"
                                  ? Colors.blueGrey
                                  : Colors.green,
                              fontSize: 20,
                            ),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(
                              color: service.prixService != "Gratuit"
                                  ? Colors.blueGrey
                                  : Colors.green,
                              width: 0.6,
                            )),
                            onPressed: () {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     fullscreenDialog: true,
                              //     builder: (context) => NewDemandes(
                              //           serviceType: service.nomService,
                              //           departementService:
                              //               service.departementService,
                              //         )));

                              Get.to(
                                  () => NewDemandes(
                                        serviceType: service.nomService,
                                        departementService:
                                            service.departementService,
                                      ),
                                  fullscreenDialog: true);
                            },
                            child: Text(
                              "Demander",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                letterSpacing: -0.5,
                                color: service.prixService != "Gratuit"
                                    ? Colors.blueGrey
                                    : Colors.green,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: servicesList.length,
        ),
      ),
    );
  }
}
