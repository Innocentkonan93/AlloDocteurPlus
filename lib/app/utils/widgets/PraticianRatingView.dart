import 'dart:math';

import '../../../data/services/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PraticianRatingView extends StatefulWidget {
  const PraticianRatingView({
    required this.idConsultation,
    required this.idPraticien,
    required this.idUtilisateur,
    Key? key,
  }) : super(key: key);

  final String idConsultation;

  final String idUtilisateur;
  final String idPraticien;

  @override
  _PraticianRatingViewState createState() => _PraticianRatingViewState();
}

class _PraticianRatingViewState extends State<PraticianRatingView> {
  var _ratingPageController = PageController();
  var _starPosition = 140.0;
  var _consultationNote = 0.0;
  var _praticianNote = 0.0;
  int currentindex = 0;

  Future<void> sendNote() async {}
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // ratink text
          Container(
            height: max(200, MediaQuery.of(context).size.height * 0.3),
            child: PageView(
              onPageChanged: (index) {
                setState(() {
                  currentindex = index;
                });
              },
              controller: _ratingPageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildConsultNote(),
                _buildPraticiantNote(),
                _causeOfRating(),
              ],
            ),
          ),
          // done button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.blue[300],
              child: TextButton(
                onPressed: () {
                  
                  
                  print("consultation: " + _consultationNote.toString());
                  print("praticien: " + _praticianNote.toString());
                  Navigator.pop(context, _consultationNote);
                },
                child: Text(
                  "Terminer",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          //Skip button
          // Positioned(
          //   child: TextButton(
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //     child: Icon(Icons.close, size: 16),
          //   ),
          //   right: 0,
          // ),
          AnimatedPositioned(
            top: _starPosition,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    if (currentindex == 1) {
                      setState(() {
                        _starPosition = 50.0;
                        this._praticianNote = index + 1;
                      });
                      _ratingPageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                      print(_praticianNote);
                     ApiService.newNote(
                        "${_praticianNote}",
                        "${widget.idUtilisateur}",
                        "${widget.idPraticien}",
                        "${widget.idConsultation}",
                        "praticiens",
                      );
                    } else {
                      setState(() {
                        this._consultationNote = index + 1;
                      });
                      _ratingPageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                      print(_consultationNote);
                      ApiService.newNote(
                        "${_consultationNote}",
                        "${widget.idUtilisateur}",
                        "${widget.idPraticien}",
                        "${widget.idConsultation}",
                        "consultations",
                      );
                    }
                  },
                  icon: currentindex == 0
                      ? _consultationNote > index
                          ? Icon(Icons.star, size: 32)
                          : Icon(Icons.star_border, size: 32)
                      : _praticianNote > index
                          ? Icon(Icons.star, size: 32)
                          : Icon(Icons.star_border, size: 32),
                  color: Colors.deepOrangeAccent,
                );
              }),
            ),
            duration: Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  _buildConsultNote() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Notez votre consultation",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 21,
              fontWeight: FontWeight.w500,
              color: Colors.deepOrangeAccent,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Vous venez de terminer une consultation, nous somme heureux de recevoir votre avis',
              style: GoogleFonts.montserrat(
                color: Colors.black26,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  _buildPraticiantNote() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // SizedBox(
          //   height: 100,
          // ),
          Text(
            'Aidez-nous à améliorer la qualité de nos services',
            style: GoogleFonts.montserrat(
              color: Colors.black38,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            "Notez votre praticien",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 21,
              fontWeight: FontWeight.w500,
              color: Colors.deepOrangeAccent,
            ),
          ),
        ],
      ),
    );
  }

  _causeOfRating() {
    return Container(
      child: Center(
        child: Text(
          'Merci.',
          style: GoogleFonts.montserrat(
            fontSize: 21,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
