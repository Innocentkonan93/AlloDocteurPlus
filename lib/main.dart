import 'dart:async';


import 'package:app_allo_docteur_plus/data/controllers/PharmaciesController.dart';
import 'package:app_allo_docteur_plus/data/controllers/ProgrammeController.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/onbord/OnboardScreen.dart';
import 'app/utils/login/log/LogScreenWidget.dart';
import 'data/controllers/DepartementController.dart';
import 'data/controllers/PraticienController.dart';
import 'data/controllers/PraticienCurriculum.dart';
import 'data/controllers/PraticiensAcitivitesController.dart';
import 'data/controllers/ServicesController.dart';
import 'data/controllers/ServicesTypeController.dart';
import 'data/controllers/UserActivitesController.dart';
import 'data/controllers/UserConsultationController.dart';
import 'data/controllers/UserDemandeController.dart';
import 'data/controllers/UsersController.dart';
import 'data/services/NotificationApi.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  // FlutterAppBadger.updateBadgeCount(1);
  print(message.data.toString());
}


int? isViewed;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  NotificationApi.init(initSchedule: true);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      // statusBarColor: Colors.transparent,
  ));

  SharedPreferences prefs = await SharedPreferences.getInstance();
  isViewed = prefs.getInt("onBoard");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of my application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UsersController(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserDemandeDemandeController(),
        ),
        ChangeNotifierProvider(
          create: (_) => ServicesTypeController(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserConsultationController(),
        ),
        ChangeNotifierProvider(
          create: (_) => DepartementController(),
        ),
        ChangeNotifierProvider(
          create: (_) => PraticienController(),
        ),
        ChangeNotifierProvider(
          create: (_) => ServicesController(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserActivitesController(),
        ),
        ChangeNotifierProvider(
          create: (_) => PraticienCurriculum(),
        ),
        ChangeNotifierProvider(
          create: (_) => PraticiensActivitesController(),
        ),
         ChangeNotifierProvider(
          create: (_) => PharmacieController(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProgrammeController(),
        ),
      ],
      child: OverlaySupport.global(
        child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('fr', 'FR'),
            ],
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            title: 'Allo Docteur plus',
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              primarySwatch: Colors.blue,
              highlightColor: Colors.grey,
              // highlightColor: Colors.indigo[900],
              dialogTheme: DialogTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                backgroundColor: Colors.white,
              ),
              // primaryColor: Color(0XFF06B3FF),
            ),
            home: isViewed == 0 ? LogScreenWidget() : OnBoardScreen(),)
            // home: LoginSuccess(),
            // home: RTCView(title: 'title'),
            // home: LogScreenWidget(),
            // home: MapScreen()),
      ),
    );
  }
}
