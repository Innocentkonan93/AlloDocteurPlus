import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NoInternetWidget extends StatefulWidget {
  final bool hasInternet;
  final ConnectivityResult result;
  const NoInternetWidget(this.hasInternet, this.result, {Key? key})
      : super(key: key);

  @override
  State<NoInternetWidget> createState() => _NoInternetWidgetState();
}

class _NoInternetWidgetState extends State<NoInternetWidget> {
  @override
  Widget build(BuildContext context) {
    var hasInternet = widget.hasInternet;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/no-internet.png",
              height: 150,
              width: 150,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Vous êtes hors connexion",
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            Text(
              "Vérifier votre connexion internet et réessayez",
              style: GoogleFonts.quicksand(
                // fontWeight: FontWeight.w400,
                color: Colors.black45,
                fontSize: 17,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 100),
            TextButton(
              onPressed: () {
                InternetConnectionChecker().onStatusChange.listen((status) {
                  var statusInternet =
                      status == InternetConnectionStatus.connected;

                  setState(() {
                    hasInternet = statusInternet;
                  });
                });
                // print(hasInternet);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Réessayez',
                    style: GoogleFonts.nunito(
                        fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.refresh),
                ],
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(200, 40),
                elevation: 0.0,
              ),
            ),
            // SizedBox(
            //   height: 40,
            // )
          ],
        ),
      ),
    );
  }
}
