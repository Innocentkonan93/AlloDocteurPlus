import 'dart:math';

import 'PayementWebView.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class PayementScreen extends StatefulWidget {
  final String? userID;
  final String? servicePrice;
  final String typeDemande;
  final String motDescription;
  final String departement;
  final String emailUser;
  final String tarif;
  final String userDoc;
  const PayementScreen(
      this.userID,
      this.servicePrice,
      this.typeDemande,
      this.motDescription,
      this.departement,
      this.emailUser,
      this.tarif,
      this.userDoc,
      {Key? key})
      : super(key: key);

  @override
  _PayementScreenState createState() => _PayementScreenState();
}

class _PayementScreenState extends State<PayementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                    child: Container(
                      height: max(
                        150,
                        MediaQuery.of(context).size.height * 0.2,
                      ),
                      child: Center(
                        child: Column(
                          // mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "Fermerture",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Voulez-vous quitter le paiement ?",
                              style: TextStyle(fontSize: 15),
                            ),
                            ButtonBar(
                              children: [
                                TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text('Annuler', style: TextStyle(color: Colors.red)),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                            Get.back();
                          },
                          child: Text('OK'),
                        )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                    // AlertDialog(
                    //   content: Text('Voulez-vous quitter le paiement ?'),
                    //   actions: [
                    //     TextButton(
                    //       onPressed: () {
                    //         Get.back();
                    //       },
                    //       child: Text('Annuler', style: TextStyle(color: Colors.red)),
                    //     ),
                    //     TextButton(
                    //       onPressed: () {
                    //         Get.back();
                    //         Get.back();
                    //       },
                    //       child: Text('OK'),
                    //     )
                    //   ],
                    // );
                  },);
            },
            icon: Icon(
              Icons.close,
              color: Colors.black,
              size: 17,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 40,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Methode de paiement',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -.8,
                    color: Colors.black.withAlpha(101),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 40),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.to(
                        () => PayementWebView(
                          widget.userID.toString(),
                          widget.servicePrice.toString(),
                          widget.typeDemande.toString(),
                          widget.motDescription.toString(),
                          widget.departement.toString(),
                          widget.emailUser.toString(),
                          widget.tarif.toString(),
                          widget.userDoc.toString(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0.0,
                      primary: Colors.grey.shade200,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.creditCard,
                          color: Colors.black87,
                          size: 35,
                        ),
                        Text(
                          'Paiement par carte',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(
                        () => PayementWebView(
                          widget.userID.toString(),
                          widget.servicePrice.toString(),
                          widget.typeDemande.toString(),
                          widget.motDescription.toString(),
                          widget.departement.toString(),
                          widget.emailUser.toString(),
                          widget.tarif.toString(),
                          widget.userDoc.toString(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0.0,
                      primary: Colors.blue[500],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.paypal,
                          color: Colors.white,
                          size: 35,
                        ),
                        Text(
                          'Payer avec Paypal',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.green.shade400,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Montant à payer',
                    style: TextStyle(fontSize: 11),
                  ),
                  Text(
                    widget.servicePrice.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.9,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
