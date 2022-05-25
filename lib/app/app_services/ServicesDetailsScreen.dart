import 'package:google_fonts/google_fonts.dart';

import '../users/screens/process/NewDemande.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ServicesDetailsScreen extends StatefulWidget {
  final String? serviceType;
  ServicesDetailsScreen({this.serviceType, Key? key}) : super(key: key);

  @override
  _ServicesDetailsScreenState createState() => _ServicesDetailsScreenState();
}

class _ServicesDetailsScreenState extends State<ServicesDetailsScreen> {
  FaIcon? icon;
  String? buttonText;
  Color? serviceTypeColor;

  String customDescription(){
    String? description;
    switch (widget.serviceType) {
      case "Consultation":
        description = "Faites vous téléconsulter par nos médecins experts et obtenez à la fin une prescription médicale si nécessaire";
        break;
      case "Interpretation d'examen":
        description = "Faites interpréter vos ordonnances, vos examens, vos documents médicaux ... \n\nObtenez à la fin des conseils de nos médecins experts";
        break;
      case "Informations":
 description = "Ayez toujours des reponses à vos questions. \n\nObtenez toutes sortes d'informations médicales dont vous avez besoin";
        break;
      default:
    }
    return description!;
  }

  @override
  void initState() {
    final serviceType = widget.serviceType;
    // if (serviceType == "Consultations") {}
    switch (serviceType) {
      case "Consultation":
        icon = FaIcon(
          FontAwesomeIcons.stethoscope,
          size: 175,
          color: Colors.white.withAlpha(70),
        );
        buttonText = 'Faire une consultation';
        serviceTypeColor = Colors.cyan;
        break;
      case "Interpretation d'examen":
        icon = FaIcon(
          FontAwesomeIcons.notesMedical,
          size: 175,
          color: Colors.white.withAlpha(70),
        );
        buttonText = 'Interprétation d\'examen';
        serviceTypeColor = Colors.black.withAlpha(303);
        break;
      case "Informations":
        icon = FaIcon(
          FontAwesomeIcons.infoCircle,
          size: 175,
          color: Colors.white.withAlpha(70),
        );
        buttonText = 'S\'informer';
        serviceTypeColor = Colors.brown;
        break;
      default:
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final serviceType = widget.serviceType;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        color: serviceTypeColor,
        child: Column(
          children: [
            AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
            ),
            Container(
              width: double.infinity,
              height: size.height / 3,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned(
                    top: 30,
                    right: -50,
                    child: icon!,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Service',
                          style: TextStyle(
                            color: Colors.white.withAlpha(100),
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "$serviceType",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w500,
                              fontSize: 40,
                            ),
                          // style: Theme.of(context).textTheme.headline3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Description',
                      style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      customDescription(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                      ),
                    ),
                    customButton("$serviceType")
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget customButton(String serviceType) {
    return SafeArea(
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) {
                return NewDemandes(serviceType: serviceType);
              },
            ),
          );
        },
        child: Text(buttonText!, style: GoogleFonts.nunitoSans(fontSize: 16),),
        style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            padding: EdgeInsets.all(12),
            elevation: 3.8,
            primary: serviceTypeColor),
      ),
    );
  }
}
