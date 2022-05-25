import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/ActivitesPraticiens.dart';
import '../../../data/services/PDFApi.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class PraticianActivitsCard extends StatefulWidget {
  final ActivitesPraticiens activites;
  const PraticianActivitsCard(this.activites, {Key? key}) : super(key: key);

  @override
  _PraticianActivitsCardState createState() => _PraticianActivitsCardState();
}

class _PraticianActivitsCardState extends State<PraticianActivitsCard> {
  @override
  Widget build(BuildContext context) {
    var date = DateFormat(
      'dd.MM.yy HH:mm',
    ).format(DateTime.tryParse(widget.activites.dateActivite!)!.toLocal());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        leading: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.filePrescription,
              color: Colors.green[200],
            ),
          ),
        ),
        title: Text(
          "${widget.activites.nomDocument}",
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          children: [
            Row(
              children: [
                Text('Prescrit par', style: GoogleFonts.nunito(),),
                SizedBox(width: 5),
                Text(
                  "Dr. " + "${widget.activites.nomPraticien}".split(' ').first,
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
                  '${widget.activites.specialitePraticien}',
                  // style: TextStyle(
                  //   color: Colors.black87,
                  //   fontWeight: FontWeight.bold,
                  // ),
                  style: GoogleFonts.quicksand(),
                ),
              ],
            ),
          ],
        ),
        trailing: Container(
          width: 90,
          // color: Colors.grey,
          child: Column(
            children: [
              Text(
                "$date",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              FaIcon(
                FontAwesomeIcons.folderOpen,
                size: 30,
                color: Color(0XFF101A69).withOpacity(0.4),
              )
            ],
          ),
        ),
        // isThreeLine: true,
        tileColor: Colors.grey[200],

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () async {
          final endPoint =
              "https://allodocteurplus.com/DossiersPraticiens/${widget.activites.emailPraticien}/${widget.activites.fileName}";
          await PDFApi.loadNetwork(endPoint);
        },
      ),
    );
  }
}
