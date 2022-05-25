import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingWidget {
  // loading dialog
  showLoadingDialog(BuildContext context, bool showLoading) {
    if (showLoading == true)
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(30),
            backgroundColor: Colors.white70,
            elevation: 0.0,
            content: Container(
              // height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('CHARGEMENT...', style: GoogleFonts.nunito(),),
                    ],
                  ),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      );
  }

  //logout dialog

  showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white70,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Déconnexion",
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text('Vous allez vous déconnecter'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(result: false);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                Get.back(result: true);
              },
              child: Text('OK'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    );
  }
}
