import 'dart:async';
import 'dart:typed_data';

import 'package:google_fonts/google_fonts.dart';

import '../../../praticians/screens/home/PraticianMenuTab.dart';
import '../../../users/screens/home/UserMenuTab.dart';
import 'PatricienLoginScreenWidget.dart';
import 'UserLoginScreenWidget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:overlay_support/overlay_support.dart';
import '../../widgets/LoadingWidgets.dart';
import '../../../../data/controllers/PraticienController.dart';
import '../../../../data/controllers/UsersController.dart';
import '../../../../data/services/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class LogScreenWidget extends StatefulWidget {
  const LogScreenWidget({Key? key}) : super(key: key);

  @override
  _LogScreenWidgetState createState() => _LogScreenWidgetState();
}

class _LogScreenWidgetState extends State<LogScreenWidget> {
  String? userT;
  String? userID;
  String? praticienID;
  bool isLogged = false;
  bool hasInternet = true;
  Uint8List? assets;
  String _appBadgeSupported = "Inconnu";
  late StreamSubscription internetsubscription;
  LoadingWidget loadingWidget = LoadingWidget();
  PageController pageController = PageController();
  ConnectivityResult result = ConnectivityResult.none;

  Future<String> getTypedUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userType = prefs.getString('userType').toString();

    if (userType == "praticiens" && hasInternet) {
      //
      loadingWidget.showLoadingDialog(context, true);
      await getCurrentPraticienData();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (contex) => PraticianTabMenu(),
          ),
          (route) => false);
    }

    if (userType == "utilisateurs" && hasInternet) {
      //
      loadingWidget.showLoadingDialog(context, true);

      await getCurrentUserData();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (contex) => UserMenuTab(),
          ),
          (route) => false);
    }
    if (userType == "null") {
      FlutterAppBadger.removeBadge();

      Future.delayed(Duration(seconds: 2), () {
        Provider.of<UsersController>(context, listen: false).cleanUserData();
        Provider.of<PraticienController>(context, listen: false)
            .cleanPraticienData();
      });

      setState(() {});
    }
    userT = userType;
    print("usertype " + userT.toString());
    setState(() {});
    return userType;
  }

  //user
  Future<String> getUserID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID').toString();
    // print(userID);
    return userID!;
  }

  Future<void> getCurrentUserData() async {
    var userID = await getUserID();
    var resp = await ApiService.getCurrentUser(userID);
    var provider = Provider.of<UsersController>(context, listen: false);

    if (resp.isSuccesful) {
      provider.setUserList(resp.data);

      provider.isProces(resp.isSuccesful);
    }

    return resp.data;
  }

// praticien
  Future<String> getPraticianID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    praticienID = prefs.getString('praticianID').toString();
    // print(praticienID);
    return praticienID!;
  }

  Future<List> getCurrentPraticienData() async {
    var praticienID = await getPraticianID();

    var resp = await ApiService.getCurrentPraticien(praticienID);
    var provider = Provider.of<PraticienController>(context, listen: false);
    if (resp.isSuccesful) {
      provider.setPraticienList(resp.data);
      provider.isProces(resp.isSuccesful);
    }
    return resp.data;
  }

  void loadImage() async {
    final ByteData imageData = await NetworkAssetBundle(
            Uri.parse("https://allodocteurplus.com/Images/check.png"))
        .load("");
    setState(() {
      this.assets = imageData.buffer.asUint8List();
    });
  }

  @override
  void initState() {
    initPlatformState();
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {});
    internetsubscription =
        InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() {
        this.hasInternet = hasInternet;
      });
      final color = hasInternet ? Colors.green : Colors.red;
      final text =
          hasInternet ? "Connexion rétablie" : "Aucune connexion internet";
      switch (status) {
        case InternetConnectionStatus.connected:
          // ignore: avoid_print
          // showSimpleNotification(Text("$text"),
          //     elevation: 0.0, context: context, background: color);
          break;
        case InternetConnectionStatus.disconnected:
          // ignore: avoid_print
          showSimpleNotification(
            Text(
              "$text",
            ),
            leading: Icon(Icons.warning_amber_rounded),
            subtitle: Text('Vérifiez connexion internet'),
            elevation: 0.0,
            context: context,
            background: color,
            duration: Duration(seconds: 5),
          );
          break;
      }
    });
    getTypedUserData();

    super.initState();
  }

  @override
  void dispose() {
    internetsubscription.cancel();
    super.dispose();
  }

  initPlatformState() async {
    String appBadgeSupported;
    try {
      bool res = await FlutterAppBadger.isAppBadgeSupported();
      print(res);
      if (res) {
        appBadgeSupported = 'Supported';
        print(appBadgeSupported);
      } else {
        appBadgeSupported = 'Not supported';
        print(appBadgeSupported);
      }
    } on PlatformException {
      appBadgeSupported = 'Failed to get badge support.';
      print(appBadgeSupported);
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _appBadgeSupported = appBadgeSupported;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        scrollDirection: Axis.vertical,
        scrollBehavior: ScrollBehavior(),
        children: [
          Scaffold(
            body: Container(
              padding: EdgeInsets.fromLTRB(10, 40, 10, 0),
              height: size.height,
              width: double.infinity,
              // decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage('assets/images/wall.png'),
              //   fit: BoxFit.cover,
              // ),
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
         
                  Column(
                    children: [
                      Image.asset(
                        "assets/images/AlloDoc_Logo-01.png",
                        height: size.height / 2.5,
                        // height: 350,
                      ),
                      Text(
                        'Consultez un médecin 7j/7'
                        ' où que vous soyez.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 19,
                          color: Colors.black54,
                          letterSpacing: -1,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      hasInternet =
                          await InternetConnectionChecker().hasConnection;
                      if (hasInternet) {
                        Get.to(
                          () => UserLoginScreenWidget(),
                        );
                      } else {
                        showSimpleNotification(
                          Text(
                            "Aucune connexion internet",
                          ),
                          leading: Icon(Icons.warning_amber_rounded),
                          subtitle: Text('Vérifiez connexion internet'),
                          elevation: 0.0,
                          context: context,
                          background: Colors.red,
                          duration: Duration(seconds: 5),
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Inscription / Connexion",
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      minimumSize: Size(size.width / 1.5, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      primary: Color(0XFF06B3FF),
                    ),
                  ),
                ],
              ),
            ),
            extendBody: true,
            bottomNavigationBar: Container(
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        hasInternet =
                            await InternetConnectionChecker().hasConnection;
                        if (hasInternet) {
                          pageController.nextPage(
                              duration: Duration(seconds: 2),
                              curve: Curves.fastOutSlowIn);
                        } else {
                          showSimpleNotification(
                            Text(
                              "Aucune connexion internet",
                            ),
                            leading: Icon(Icons.warning_amber_rounded),
                            subtitle: Text('Vérifiez connexion internet'),
                            elevation: 0.0,
                            context: context,
                            background: Colors.red,
                            duration: Duration(seconds: 5),
                          );
                        }
                      },
                      child: Text(
                        'Vous êtes praticien ?',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.primaryDelta! > 24.0) {
                  pageController.previousPage(
                      duration: Duration(seconds: 2),
                      curve: Curves.fastOutSlowIn);
                }
              },
              child: PraticienLoginScreenWidget(pageController),
            ),
          ),
        ],
      ),
    );
  }
}
