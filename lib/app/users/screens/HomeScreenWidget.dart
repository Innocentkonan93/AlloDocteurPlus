import 'dart:async';

import 'package:app_allo_docteur_plus/app/pharmacie_de_garde/pharmacies_screen.dart';

import '../../utils/widgets/NewPinScreen.dart';
import '../../utils/widgets/PinScreen.dart';
import '../../../data/controllers/UsersController.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../utils/widgets/NoInternetWidget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  bool hasInternet = true;
  late StreamSubscription internetsubscription;
  late StreamSubscription connectivitySubscription;
  ConnectivityResult result = ConnectivityResult.none;

 


  @override
  void initState() {
    connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((status) {
      setState(() => result = status);
    });
    internetsubscription =
        InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() {
        this.hasInternet = hasInternet;
      });
      print(hasInternet);
    });
    super.initState();
  }

  @override
  void dispose() {
    internetsubscription.cancel();
    connectivitySubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UsersController>(context);
    final currentUser = userController.listUsers.first;
    return hasInternet
        ? Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: Text(
                'Outils',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  letterSpacing: -1,
                ),
              ),
              centerTitle: true,
            ),
            body: userController.isProcessing
                ? Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Colors.white,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        GridView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            childAspectRatio: 1.4,
                          ),
                          padding: EdgeInsets.all(15),
                          children: [
                            // GestureDetector(
                            //   onTap: () {
                            //     Get.to(
                            //       () => NewDemandes(
                            //         serviceType: "Consultation",
                            //       ),
                            //     );
                            //   },
                            //   child: Container(
                            //     padding: EdgeInsets.all(10),
                            //     decoration: BoxDecoration(
                            //       color: Colors.white,
                            //       borderRadius: BorderRadius.circular(10),
                            //       boxShadow: [
                            //         BoxShadow(
                            //           color: Colors.black.withOpacity(0.14),
                            //           offset: Offset(2, -2),
                            //           blurRadius: 20,
                            //         )
                            //       ],
                            //     ),
                            //     child: Column(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         FaIcon(
                            //           FontAwesomeIcons.stethoscope,
                            //           size: 50,
                            //           color: Colors.green,
                            //         ),
                            //         SizedBox(
                            //           height: 5,
                            //         ),
                            //         Text(
                            //           'Nouvelle consultation ',
                            //           textAlign: TextAlign.center,
                            //           style: GoogleFonts.nunito(),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            GestureDetector(
                              onTap: () async {
                                if (currentUser.pinUtilisateur == null) {
                                  print("pin : ${currentUser.pinUtilisateur}");
                                  Get.to(
                                    () => NewPinScreen(currentUser:currentUser),
                                    fullscreenDialog: true,
                                  );
                                } else {
                                  print("pin : ${currentUser.pinUtilisateur}");
                                  Get.to(
                                    () => PinScreen(
                                      pinUtilisateur:
                                          currentUser.pinUtilisateur.toString(),
                                    ),
                                    fullscreenDialog: true,
                                  );
                                  // Get.to(()=>NewPinScreen());
                                }
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     fullscreenDialog: true,
                                //     builder: (context) => PinScreen(),
                                //     // builder: (context) => UserMedicalInfo(),
                                //   ),
                                // );
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.14),
                                      offset: Offset(2, -2),
                                      blurRadius: 20,
                                    )
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.idCardAlt,
                                      size: 50,
                                      color: Colors.blue[900],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Mon dossier médical',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.nunito(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(
                                  () =>PharmacieScreen(),
                                  // () =>FindPharmacy()
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.14),
                                      offset: Offset(2, -2),
                                      blurRadius: 20,
                                    )
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.search,
                                      size: 50,
                                      color: Colors.green,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Trouver pharmacie ',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.nunito(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(child: Container())
                      ],
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
          )
        : NoInternetWidget(hasInternet, result);
  }
}
