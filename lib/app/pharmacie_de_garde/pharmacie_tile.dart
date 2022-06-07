import 'package:app_allo_docteur_plus/app/pharmacie_de_garde/PharmacieModal.dart';
import 'package:app_allo_docteur_plus/data/models/Pharmacies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/controllers/ProgrammeController.dart';

class PharmacieTile extends StatefulWidget {
  const PharmacieTile({Key? key, required this.pharmacie}) : super(key: key);
  final Pharmacie pharmacie;

  @override
  State<PharmacieTile> createState() => _PharmacieTileState();
}

class _PharmacieTileState extends State<PharmacieTile> {
  TextStyle openStyle =
      TextStyle(color: Colors.green, fontWeight: FontWeight.w600);
  TextStyle closeStyle =
      TextStyle(color: Colors.red, fontWeight: FontWeight.w600);
  TextStyle gardeStyle =
      TextStyle(color: Colors.orange, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
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
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return PharmacieModal(pharmacie: pharmacie);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  offset: Offset(2, 2),
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.03),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    // pharmacieProgramme.isNotEmpty &&
                    //         (DateTime.parse(pharmacieProgramme.last.finGarde!)
                    //             .isAfter(DateTime.now()))
                    //     ? Text(
                    //         "De garde",
                    //         style: GoogleFonts.montserrat(
                    //           fontSize: 12,
                    //           fontWeight: FontWeight.bold,
                    //           color: Colors.orange,
                    //         ),
                    //       )
                    //     : Text(
                    //         (DateFormat('EEEE').format(now) != 'Saturday' ||
                    //                     DateFormat('EEEE').format(now) !=
                    //                         'Sunday') &&
                    //                 open.isBefore(now) &&
                    //                 close.isAfter(now)
                    //             ? 'Ouverte'
                    //             : "Fermée",
                    //         style: GoogleFonts.montserrat(
                    //           fontSize: 12,
                    //           fontWeight: FontWeight.bold,
                    //           color: open.isBefore(now) && close.isAfter(now)
                    //               ? Colors.green
                    //               : Colors.red,
                    //         ),
                    //       ),
                    (pharmacieProgramme.isNotEmpty)
                        ? DateTime.parse(pharmacieProgramme.last.finGarde!)
                                .isAfter(now)
                            ? Text(
                                'De garde',
                                style: gardeStyle,
                              )
                            : DateFormat('EEEE').format(now) == 'Saturday' ||
                                    DateFormat('EEEE').format(now) == 'Sunday'
                                ? Text(
                                    'Fermée',
                                    style: closeStyle,
                                  )
                                : Text(
                                    open.isBefore(now) && close.isAfter(now)
                                        ? 'Ouvert'
                                        : 'Fermée',
                                    style:
                                        open.isBefore(now) && close.isAfter(now)
                                        ? openStyle
                                        : closeStyle,
                                  )
                        : DateFormat('EEEE').format(now) == 'Saturday' ||
                                DateFormat('EEEE').format(now) == 'Sunday'
                            ? Text(
                                'Fermée',
                                style: closeStyle,
                              )
                            : Text(
                                open.isBefore(now) && close.isAfter(now)
                                    ? 'Ouvert'
                                    : 'Fermée',
                                style:
                                    close.isAfter(now) ? openStyle : closeStyle,
                              )
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        pharmacie.nomPharmacie.toString(),
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0XFF434343),
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.map_pin,
                      size: 16,
                    ),
                    Flexible(
                      child: Text(
                        pharmacie.adressePharmacie
                            .toString()
                            .capitalizeFirst
                            .toString(),
                        style: GoogleFonts.montserrat(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0XFF3DA7CE),
                        ),
                        maxLines: 2,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
