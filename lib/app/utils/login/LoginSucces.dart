// ignore_for_file: unused_local_variable

import 'dart:typed_data';

import 'package:app_allo_docteur_plus/app/praticians/screens/home/PraticianMenuTab.dart';
import 'package:app_allo_docteur_plus/app/users/screens/home/UserMenuTab.dart';
import 'package:app_allo_docteur_plus/data/controllers/PraticienController.dart';
import 'package:app_allo_docteur_plus/data/controllers/UsersController.dart';
import 'package:app_allo_docteur_plus/data/services/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginSuccess extends StatefulWidget {
  const LoginSuccess({Key? key}) : super(key: key);

  @override
  _LoginSuccessState createState() => _LoginSuccessState();
}

class _LoginSuccessState extends State<LoginSuccess> {
  String? userT;
  bool isDone = false;
  Uint8List? imageMemory;
  //user
  Future<String> getUserID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userID = prefs.getString('userID').toString();
    return userID;
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
    final String userID = prefs.getString('praticianID').toString();
    return userID;
  }

  Future<List> getCurrentPraticien() async {
    var userID = await getPraticianID();

    var resp = await ApiService.getCurrentPraticien(userID);
    var provider = Provider.of<PraticienController>(context, listen: false);
    if (resp.isSuccesful) {
      provider.setPraticienList(resp.data);
      provider.isProces(resp.isSuccesful);
    }
    return resp.data;
  }

  //user Type

  Future<String> getTypedUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userType = prefs.getString('userType').toString();
    if (userType == "praticiens") getCurrentPraticien();
    if (userType == "utilisateurs") getCurrentUserData();
    userT = userType;
    return userType;
  }

  void loadImage() async {
    final ByteData imageData = await NetworkAssetBundle(
            Uri.parse("https://allodocteurplus.com/Images/login_success.png"))
        .load("");
    setState(() {
      this.imageMemory = imageData.buffer.asUint8List();
    });
  }

  @override
  void initState() {
    getTypedUserData();
    loadImage();
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        isDone = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UsersController>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (imageMemory != null)
              SizedBox(
                height: 150,
                width: 150,
                child: Image.memory(imageMemory!),
              ),
              SizedBox(height: size.height / 16),
            Opacity(
              opacity: isDone == true ? 1 : 0,
              child: Text(
                "Enregistrément réussi.",
                style: GoogleFonts.montserrat(
                  // color: Color.fromRGBO(0, 211, 78, 1),
                  color: Colors.black45,
                  fontSize: 20,
                  letterSpacing: -0.7,
                ),
              ),
            ),
            SizedBox(height: size.height / 4),
            Opacity(
              opacity: isDone == true ? 1 : 0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (contex) => userT == "praticiens"
                            // ? PraticianHomeScreen()
                            // : UserHomeScreen(),

                            ? PraticianTabMenu()
                            : UserMenuTab(),
                      ),
                      (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  primary: Color.fromRGBO(0, 211, 78, 1),
                ),
                child: Text(
                  'Commencer',
                  style: GoogleFonts.nunito(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
