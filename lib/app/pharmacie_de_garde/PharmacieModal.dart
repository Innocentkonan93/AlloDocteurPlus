import 'package:app_allo_docteur_plus/data/models/Pharmacies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class PharmacieModal extends StatefulWidget {
  const PharmacieModal({Key? key, required this.pharmacie}) : super(key: key);
  final Pharmacie pharmacie;

  @override
  State<PharmacieModal> createState() => _PharmacieModalState();
}

class _PharmacieModalState extends State<PharmacieModal> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pharmacie = widget.pharmacie;
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
          Row(
            children: [
              Text(
                "${pharmacie.statutPharmacie}".capitalizeFirst.toString(),
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: pharmacie.statutPharmacie == 'ouverte'
                      ? Colors.green
                      : pharmacie.statutPharmacie == 'de garde'
                          ? Colors.orange
                          : Colors.red,
                ),
              ),
              Spacer(),
              if (pharmacie.statutPharmacie == 'de garde')
                SizedBox(
                  child: Image.asset(
                    "assets/images/24-hours.png",
                    height: 20,
                    width: 20,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
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
                    if (await canLaunch(url)) {
                      launch(url);
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
