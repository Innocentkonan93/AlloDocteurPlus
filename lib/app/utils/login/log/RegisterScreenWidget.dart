import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../terms_and_conditions/TermsAndCondition.dart';

import '../../widgets/LoadingWidgets.dart';
import '../../../../data/services/LoginService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreenWidget extends StatefulWidget {
  const RegisterScreenWidget({Key? key}) : super(key: key);

  @override
  _RegisterScreenWidgetState createState() => _RegisterScreenWidgetState();
}

class _RegisterScreenWidgetState extends State<RegisterScreenWidget> {
  PageController _controller = PageController();
  LoadingWidget loadingWidget = LoadingWidget();
  String? _page;
  bool showPassword = true;
  bool isLoading = false;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  TextEditingController _nomController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _tailleController = TextEditingController();
  TextEditingController _poidsController = TextEditingController();
  TextEditingController _gpController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _ageController.dispose();
    _tailleController.dispose();
    _poidsController.dispose();
    _gpController.dispose();
    _numberController.dispose();
    _emailController.dispose();
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
        // backgroundColor: Colors.white,
        // backgroundColor: Color(0XFF00B4FF).withOpacity(0.88),
        appBar: AppBar(
          // backgroundColor: Color(0XFF00B4FF).withOpacity(0.88),

          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                size: 17,
              )),
          elevation: 0.0,
          title: Text(
            'Inscription',
            style: GoogleFonts.nunito(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: _page != null
                  ? Text(
                      "$_page / 3",
                      style: TextStyle(color: Colors.black),
                    )
                  : Container(),
            )
          ],
        ),
        body: isLoading
            ? Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator.adaptive(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Enregistrément en cours...',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Container(
                height: size.height,
                child: PageView(
                  controller: _controller,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    // Nom et prenom
                    Scaffold(
                      // backgroundColor: Color(0XFF363636),
                      body: Container(
                        height: size.height,
                        width: double.infinity,
                        // color: Color(0XFF00B4FF).withOpacity(0.88),
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 40),
                              // height: size.height / 4.5,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  // border: Border.all(),
                                  ),
                              child: Form(
                                key: _formKey1,
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Nom et prénom",
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                            letterSpacing: -1,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      controller: _nomController,
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(12, 8, 12, 8),
                                        fillColor: Colors.blue[50],
                                        filled: true,
                                        hintText: 'Nom complet',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        prefixIcon: Icon(Icons.person),
                                      ),
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "Saisir votre nom complet";
                                        }
                                        return null;
                                      },
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    // Spacer(),
                                    Row(
                                      children: [
                                        Text(
                                          "Date de naissance",
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                            letterSpacing: -1,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      onTap: () async {
                                        FocusScope.of(context).unfocus();

                                        final datePicked = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2900),
                                        );
                                        if (datePicked == null) return;
                                        final date = DateFormat("dd-MM-yyyy")
                                            .format(datePicked);
                                        setState(() {
                                          _ageController.text = date.toString();
                                        });
                                      },
                                      onChanged: (val) {
                                        setState(() {
                                          _ageController.text = val;
                                        });
                                      },
                                      validator: (val) {
                                        // if (val!.isEmpty) {
                                        //   return "Votre âge";
                                        // }
                                        print(val!);
                                        final birthDay = val.split('-');
                                        print(birthDay);
                                        final day = int.parse(birthDay[0]);
                                        final month = int.parse(birthDay[1]);
                                        final year = int.parse(birthDay[2]);
                                        if (year.toString().length != 4 &&
                                            month.toString().length != 2 &&
                                            day.toString().length != 2) {
                                          return "Entrez une date correct";
                                        }
                                        return null;
                                      },
                                      controller: _ageController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(12, 8, 12, 8),
                                        fillColor: Colors.blue[50],
                                        hintText: 'Date de naissance',
                                        filled: true,
                                        prefixIcon: Icon(Icons.accessibility),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                                    Get.back();
                                  },
                                  child: Center(
                                    child: Text(
                                      "Annuler".toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        // fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (_formKey1.currentState!.validate()) {
                                      setState(() {
                                        _page = (_controller.page!.toInt() + 1)
                                            .toString();
                                        _controller.keepPage;
                                      });
                                      _controller.nextPage(
                                          duration: Duration(milliseconds: 200),
                                          curve: Curves.linear);
                                    }
                                  },
                                  child: Container(
                                    height: double.infinity,
                                    color: Colors.white,
                                    child: Center(
                                      child: Text(
                                        "Suivant".toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          // fontWeight: FontWeight.bold,
                                        ),
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

                    /// Taille poids sanguin
                    Scaffold(
                      // backgroundColor: Color(0XFF363636),
                      body: Container(
                        height: size.height,
                        width: double.infinity,
                        // color: Color(0XFF00B4FF).withOpacity(0.88),
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 40),
                              // height: size.height / 3,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  // border: Border.all(),
                                  ),
                              child: Form(
                                key: _formKey2,
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Vôtre taille",
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                            letterSpacing: -1,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      controller: _tailleController,
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "Votre tille";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(12, 8, 12, 8),
                                        fillColor: Colors.blue[50],
                                        filled: true,
                                        hintText: 'Taille',
                                        prefixIcon: Icon(Icons.accessibility),
                                        suffix: Text(
                                          'cm',
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                      ),
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Votre poids",
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                            letterSpacing: -1,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      controller: _poidsController,
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "Votre poids";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(12, 8, 12, 8),
                                        fillColor: Colors.blue[50],
                                        filled: true,
                                        hintText: 'Poids',
                                        prefixIcon: Icon(Icons.fitness_center),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Vôtre groupe sanguin",
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                            letterSpacing: -1,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      controller: _gpController,
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      keyboardType: TextInputType.text,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "Votre groupe sanguin";
                                        }
                                        return null;
                                      },
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(12, 8, 12, 8),
                                        fillColor: Colors.blue[50],
                                        filled: true,
                                        hintText: 'Groupe sanguin',
                                        prefixIcon: Icon(Icons.bloodtype),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                                    _controller.previousPage(
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.linear);
                                  },
                                  child: Center(
                                    child: Text(
                                      "Retour".toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        // fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (_formKey2.currentState!.validate()) {
                                      setState(() {
                                        _page = (_controller.page!.toInt() + 1)
                                            .toString();
                                      });
                                      _controller.keepPage;
                                      _controller.nextPage(
                                          duration: Duration(milliseconds: 200),
                                          curve: Curves.linear);
                                    }
                                  },
                                  child: Container(
                                    height: double.infinity,
                                    color: Colors.white,
                                    child: Center(
                                      child: Text(
                                        "Suivant".toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          // fontWeight: FontWeight.bold,
                                        ),
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

                    /// numero email mdp
                    Scaffold(
                      // backgroundColor: Color(0XFF363636),
                      body: Container(
                        height: size.height,
                        width: double.infinity,
                        // color: Color(0XFF00B4FF).withOpacity(0.88),
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 40),
                              // height: size.height / 2.8,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  // border: Border.all(),
                                  ),
                              child: Form(
                                key: _formKey3,
                                child: ListView(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Vôtre numéro de télephone",
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                            letterSpacing: -1,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      controller: _numberController,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "Votre numéro de téléphone";
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(12, 8, 12, 8),
                                        fillColor: Colors.blue[50],
                                        hintText: 'Téléphone',
                                        filled: true,
                                        prefixIcon: Icon(Icons.phone),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                      ),
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                    ),
                                    // Spacer(),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Votre adresse email",
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                            letterSpacing: -1,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (val) {
                                        if (val!.isEmpty ||
                                            !val.contains("@")) {
                                          return "Votre adresse email";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(12, 8, 12, 8),
                                        fillColor: Colors.blue[50],
                                        filled: true,
                                        hintText: 'E-mail',
                                        prefixIcon: Icon(Icons.email),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                      ),
                                    ),
                                    // Spacer(),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Mot de passe",
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                            letterSpacing: -1,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      controller: _passwordController,
                                      keyboardType: TextInputType.text,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "Votre mot de passe";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(12, 8, 12, 8),
                                        fillColor: Colors.blue[50],
                                        filled: true,
                                        hintText: 'Mot de passe',
                                        prefixIcon: Icon(Icons.lock),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              showPassword = !showPassword;
                                            });
                                          },
                                          icon: Icon(showPassword
                                              ? Icons.remove_red_eye
                                              : Icons
                                                  .panorama_fish_eye_outlined),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                      ),
                                      obscureText: showPassword,
                                    ),
                                    SizedBox(height: 10),
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      children: [
                                        Text(
                                          'En vous inscrivant vous acceptez nos',
                                          style: GoogleFonts.nunito(
                                            fontSize: 12,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(
                                              () => TermsAndConditions(
                                                isStarting: false,
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'conditions générales d\'utilisation',
                                            style: GoogleFonts.nunito(
                                                fontSize: 12,
                                                color: Colors.blue),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
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
                                    _controller.previousPage(
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.linear);
                                  },
                                  child: Center(
                                    child: Text(
                                      "Retour".toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        // fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    if (_formKey3.currentState!.validate()) {
                                      setState(() {
                                        isLoading = true;
                                        _page = (_controller.page!.toInt() + 1)
                                            .toString();
                                      });
                                      final result =
                                          await LoginService().userRegistration(
                                        context,
                                        _nomController.text,
                                        _ageController.text,
                                        _tailleController.text,
                                        _poidsController.text,
                                        _emailController.text,
                                        _numberController.text,
                                        _passwordController.text,
                                        _gpController.text,
                                      );
                                      print(result);
                                      // .then((value) => setState(() {
                                      //       isLoading = false;
                                      //     }));
                                      if (result ==
                                          "Un compte a déjà été associé avec l'email indiqué") {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: double.infinity,
                                    color: Colors.green,
                                    child: Center(
                                      child: Text(
                                        "Inscritpion".toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            // fontWeight: FontWeight.bold,
                                            color: Colors.white),
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
                  ],
                ),
              ),
      ),
    );
  }
}
