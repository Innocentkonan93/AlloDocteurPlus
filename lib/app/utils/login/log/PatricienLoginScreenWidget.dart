import 'dart:io';

import 'package:google_fonts/google_fonts.dart';

import '../../widgets/LoadingWidgets.dart';
import '../../../../data/services/LoginService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PraticienLoginScreenWidget extends StatefulWidget {
  final PageController pageController;
  const PraticienLoginScreenWidget(this.pageController, {Key? key})
      : super(key: key);

  @override
  _PraticienLoginScreenWidgetState createState() =>
      _PraticienLoginScreenWidgetState();
}

class _PraticienLoginScreenWidgetState
    extends State<PraticienLoginScreenWidget> {
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
    widget.pageController.dispose();
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
        key: _scaffoldKey,
        backgroundColor: Color(0XFF101A69),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: InkWell(
            onTap: () {
              widget.pageController.previousPage(
                  duration: Duration(seconds: 2), curve: Curves.fastOutSlowIn);
            },
            child: SizedBox(
              width: 50,
              height: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
        body: Container(
          height: size.height,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/wall.png'),
            fit: BoxFit.cover,
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Connexion',
                style: GoogleFonts.nunito(
                  fontSize: 25,
                  fontWeight: FontWeight.w300,
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
                    shrinkWrap: true,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Votre identifiant",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
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
                              color: Colors.white,
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
                        .praticianLogin(
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
                        fontSize: 15,
                        color: Color(0XFF101A69).withOpacity(0.88),
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
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
                  primary: Colors.white,
                ),
              )
            ],
          ),
        ),
        // bottomNavigationBar: SafeArea(
        //   child: Container(
        //     height: size.height * 0.05,
        //     color: Color(0XFF363636),
        //     child: Row(
        //       children: [
        //         Expanded(
        //           child: GestureDetector(
        //             onTap: () {
        //               Get.to(
        //                 () => RegisterScreenWidget(),
        //                 fullscreenDialog: true,
        //               );
        //             },
        //             child: Container(
        //               height: double.infinity,
        //               color: Colors.white,
        //               child: Center(
        //                 child: Row(
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   children: [
        //                     Text(
        //                       "Pas de compte ? ",
        //                       style: TextStyle(
        //                         fontSize: 16,
        //                       ),
        //                     ),
        //                     Text(
        //                       "Inscritpion",
        //                       style: TextStyle(
        //                         fontSize: 16,
        //                         fontWeight: FontWeight.bold,
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
