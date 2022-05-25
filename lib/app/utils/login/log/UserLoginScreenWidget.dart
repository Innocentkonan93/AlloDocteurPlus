import 'dart:io';

import 'package:google_fonts/google_fonts.dart';

import '../../../users/widgets/ForgotPassword.dart';

import 'RegisterScreenWidget.dart';
import '../../widgets/LoadingWidgets.dart';
import '../../../../data/services/LoginService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserLoginScreenWidget extends StatefulWidget {
  const UserLoginScreenWidget({Key? key}) : super(key: key);

  @override
  _UserLoginScreenWidgetState createState() => _UserLoginScreenWidgetState();
}

class _UserLoginScreenWidgetState extends State<UserLoginScreenWidget> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  LoadingWidget loadingWidget = LoadingWidget();
  TextEditingController _idController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  LoginService loginService = LoginService();
  bool showPassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color(0XFF00B4FF).withOpacity(0.88),
        ),
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Container(
          height: size.height,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/wall.png'),
              fit: BoxFit.cover,
            ),
            color: Color(0XFF00B4FF).withOpacity(0.88),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Connexion',
                style: GoogleFonts.nunito(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                // height: size.height / 4.5,
                width: double.infinity,
                decoration: BoxDecoration(
                    // border: Border.all(),
                    ),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Votre identifiant",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 15,
                              letterSpacing: -1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: _idController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Votre identifiant";
                          }
                          if (!val.contains('@')) {
                            return "Identifiant non valide";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Votre e-mail',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.white)),
                        ),
                      ),
                      // Spacer(),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Text(
                            "Votre mot de passe",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 15,
                              letterSpacing: -1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Votre mot de passe";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                          fillColor: Colors.white,
                          hintText: 'Mot de passe',
                          filled: true,
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.white)),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                            icon: Icon(showPassword
                                ? CupertinoIcons.eye_fill
                                : CupertinoIcons.eye_slash_fill),
                          ),
                        ),
                        obscureText: showPassword,
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(
                            () => ForgotPassword(),
                          );
                        },
                        child: Text(
                          'Mot de passe oublié ?',
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    await loginService
                        .userLogin(
                      context,
                      _idController.text.trim(),
                      _passwordController.text.trim(),
                    )
                        .then((value) {
                      setState(() {
                        isLoading = false;
                      });
                    });
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Connexion'.toUpperCase(),
                      style: GoogleFonts.nunito(
                        fontSize: 15, color: Color(0XFF00B4FF),
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    if (isLoading)
                      Platform.isIOS
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CupertinoActivityIndicator(),
                            )
                          : SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator.adaptive(),
                            )
                  ],
                ),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.all(12),
                    elevation: 2.0,
                    primary: Colors.white),
              )
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: size.height * 0.05,
            color: Color(0XFF363636),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                        () => RegisterScreenWidget(),
                        fullscreenDialog: true,
                      );
                    },
                    child: Container(
                      height: double.infinity,
                      color: Colors.white,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Pas de compte ? ",
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Inscritpion",
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
