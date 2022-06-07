import 'package:app_allo_docteur_plus/data/models/Pharmacies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/controllers/ProgrammeController.dart';

class PharmacieModal extends StatefulWidget {
  const PharmacieModal({Key? key, required this.pharmacie}) : super(key: key);
  final Pharmacie pharmacie;

  @override
  State<PharmacieModal> createState() => _PharmacieModalState();
}

class _PharmacieModalState extends State<PharmacieModal> {
  TextStyle openStyle =
      TextStyle(color: Colors.green, fontWeight: FontWeight.w600);
  TextStyle closeStyle =
      TextStyle(color: Colors.red, fontWeight: FontWeight.w600);
  TextStyle gardeStyle =
      TextStyle(color: Colors.orange, fontWeight: FontWeight.w600);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pharmacie = widget.pharmacie;

    final now = DateTime.now();
    // final now = DateTime.now().add(Duration(days: 3));
    DateTime open = DateTime(now.year, now.month, now.day, 07, 00);
    DateTime close = DateTime(now.year, now.month, now.day, 20, 00);

    final programmeController = Provider.of<ProgrammeController>(context);
    final programmeList = programmeController.listProgrammes;
    final pharmacieProgramme = programmeList
        .where((programme) => programme.idPharmacie == pharmacie.idPharmacie)
        .toList();
    print(DateFormat('EEEE').format(now));
    return Container(
      height: size.height / 3.2,
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 3,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Color(0XFF434343).withOpacity(0.5),
                borderRadius: BorderRadius.circular(5)),
          ),
          // Row(
          //   children: [
          // Text(
          //   "${pharmacie.statutPharmacie}".capitalizeFirst.toString(),
          //   style: GoogleFonts.montserrat(
          //     fontSize: 12,
          //     fontWeight: FontWeight.bold,
          //     color: pharmacie.statutPharmacie == 'ouverte'
          //         ? Colors.green
          //         : pharmacie.statutPharmacie == 'de garde'
          //             ? Colors.orange
          //             : Colors.red,
          //   ),
          // ),
          // (pharmacieProgramme.isNotEmpty)
          //     ? DateTime.parse(pharmacieProgramme.last.finGarde!)
          //             .isAfter(now)
          //         ? Text(
          //             'De garde',
          //             style: gardeStyle,
          //           )
          //         : DateFormat('EEEE').format(now) == 'Saturday' ||
          //                 DateFormat('EEEE').format(now) == 'Sunday'
          //             ? Text(
          //                 'Fermée',
          //                 style: closeStyle,
          //               )
          //             : Text(
          //                 open.isBefore(now) && close.isAfter(now)
          //                     ? 'Ouvert'
          //                     : 'Fermée',
          //                 style:
          //                     close.isAfter(now) ? openStyle : closeStyle,
          //               )
          //     : DateFormat('EEEE').format(now) == 'Saturday' ||
          //             DateFormat('EEEE').format(now) == 'Sunday'
          //         ? Text(
          //             'Fermée',
          //             style: closeStyle,
          //           )
          //         : Text(
          //             open.isBefore(now) && close.isAfter(now)
          //                 ? 'Ouvert'
          //                 : 'Fermée',
          //             style: close.isAfter(now) ? openStyle : closeStyle,
          //           ),

          //   ],
          // ),
          // const SizedBox(height: 8),
          Row(
            children: [
              Flexible(
                child: Text(
                  pharmacie.nomPharmacie.toString(),
                  style: GoogleFonts.montserrat(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0XFF434343),
                  ),
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                CupertinoIcons.map_pin,
                size: 20,
              ),
              Flexible(
                child: Text(
                  pharmacie.adressePharmacie
                      .toString()
                      .capitalizeFirst
                      .toString(),
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0XFF3DA7CE),
                  ),
                  maxLines: 2,
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          ...pharmacie.numeroPharmacie!.split("/").map(
            (number) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    final url = "tel:${number}";
                    // if (await canLaunch(url)) {
                    //   launch(url);
                    // }
                    if (await canLaunchUrl(Uri.parse(url))) {
                      launchUrl(Uri.parse(url));
                    }
                  },
                  onLongPress: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: number,
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/svg-icon/phone-call.svg",
                        height: 18,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                          number,
                          style: GoogleFonts.nunito(
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                            color: Color(0XFF3DA7CE),
                          ),
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
