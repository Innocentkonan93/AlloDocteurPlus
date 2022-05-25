import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/Pharmacies.dart';
import '../utils/widgets/GlassMorphism.dart';

class PharmacieOption extends StatefulWidget {
  const PharmacieOption({Key? key, required this.pharmacie}) : super(key: key);
  final Pharmacie pharmacie;

  @override
  State<PharmacieOption> createState() => _PharmacieOptionState();
}

class _PharmacieOptionState extends State<PharmacieOption> {
  double minSheetSize = 0.1;
  double maxSheetSize = 0.95;
  double initSheetSize = 0.3;
  @override
  Widget build(BuildContext context) {
    final pharmacie = widget.pharmacie;
    final size = MediaQuery.of(context).size;
    return GlassMorphism(
      blur: 15,
      opacity: 0.6,
      child: Container(
        height: size.height * (initSheetSize),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.cancel_rounded,
                    size: 20,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  pharmacie.nomPharmacie!,
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  pharmacie.adressePharmacie! +
                      ' - ' +
                      pharmacie.paysPharmacie!.trim(),
                  style: GoogleFonts.nunito(),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Text(
                  'Ouvert',
                  style: GoogleFonts.quicksand(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 27, 180, 129),),
                ),
                SizedBox(width: 5),
                Icon(
                  CupertinoIcons.check_mark_circled_solid,
                  color: Color.fromARGB(255, 27, 180, 129),
                  size: 20,
                )
              ],
            ),
             Row(
              children: [
                Text(
                  '7:00 - 19:00',
                  style: GoogleFonts.quicksand(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 27, 180, 129),),
                ),
              ],
            ),
            SizedBox(height: 25),
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Appeler',
                        style: GoogleFonts.montserrat(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
