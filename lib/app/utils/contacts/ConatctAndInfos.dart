import 'dart:io';

import 'package:google_fonts/google_fonts.dart';

import '../widgets/AppRatingView.dart';
import '../../../data/services/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactAndInfo extends StatefulWidget {
  const ContactAndInfo({Key? key}) : super(key: key);

  @override
  _ContactAndInfoState createState() => _ContactAndInfoState();
}

class _ContactAndInfoState extends State<ContactAndInfo> {
  final nomController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? appName;
  String? packageName;
  String? version;
  String? buildNumber;
  String? buildSignature;
  String? userType;

  bool isLoading = false;

  void getAppInfos() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
      buildSignature = packageInfo.buildSignature;
    });
  }

  Future<String> getUserType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userType = prefs.getString('userType');
    setState(() {
      this.userType = userType;
    });
    return userType!;
  }

  @override
  void initState() {
    getAppInfos();
    getUserType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Contacts et informations',
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              letterSpacing: -1,
            ),
          ),
          elevation: 0.9,
          centerTitle: true,
          backgroundColor:
              userType == "utilisateurs" ? Colors.blue : Color(0XFF101A69),
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                // Container(
                //   decoration: BoxDecoration(
                //     color: Colors.grey[300],
                //     borderRadius: BorderRadius.circular(5),
                //   ),
                //   padding: EdgeInsets.all(5),
                //   child: Row(
                //     children: [
                //       Text("Service client"),
                //     ],
                //   ),
                // )
                // ElevatedButton(
                //   onPressed: () {},
                //   child: Row(
                //     children: [
                //       Text(
                //         "Contactez-nous",
                //         style: TextStyle(
                //           fontSize: 16,
                //         ),
                //       ),
                //       Spacer(),
                //       Icon(Icons.call)
                //     ],
                //   ),
                //   style: ElevatedButton.styleFrom(
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     primary: Colors.black12,
                //     elevation: 0.0,
                //     padding: EdgeInsets.all(15),
                //     onPrimary: Colors.black87,
                //     // onPrimary: Color(0XFF101A69),
                //   ),
                // ),
                // SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (Platform.isIOS) {
                      Share.share('https://allodocteurplus.com',
                          subject: 'Télécharge l\'appli.');
                    } else {
                      Share.share(
                        'https://play.google.com/store/apps/details?id=com.creative.appallodocteurplus&hl=fr&gl=US',
                        subject: 'Télécharge l\'appli.',
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        "Inviter un ami",
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.share)
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    primary: Colors.black12,
                    padding: EdgeInsets.all(15),
                    elevation: 0.0,
                    onPrimary: Colors.black87,
                    // onPrimary: Color(0XFF101A69),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        openRatingDialog(context);
                      },
                      icon: Icon(Icons.star),
                      label: Text('Notez-nous !'),
                      style: TextButton.styleFrom(
                        primary: Colors.deepOrangeAccent,
                      ),
                    )
                  ],
                ),
                Divider(),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black12,
                  ),
                  padding: EdgeInsets.all(10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'Laissez un message',
                            style: GoogleFonts.quicksand(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: nomController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                            hintText: "Nom",
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Un nom ? un pseudo ?";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                            hintText: "Email",
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Une adresse mail ?";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: messageController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                            hintText: "Message",
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Un message ?";
                            }
                            return null;
                          },
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: 4,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              await ApiService.newFeedback(
                                nomController.text,
                                emailController.text,
                                messageController.text,
                              ).then((value) {
                                nomController.clear();
                                emailController.clear();
                                messageController.clear();
                                setState(() {
                                  isLoading = false;
                                });
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Message envoyé",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 75,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                                Future.delayed(Duration(seconds: 2), () {
                                  Get.back();
                                });
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(120, 45),
                              fixedSize: Size(120, 45),
                              shape: StadiumBorder(),
                              primary: Colors.deepOrangeAccent),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Envoyer',
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              if (isLoading)
                                SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                Text(
                  "$appName",
                  style: TextStyle(
                    color: Colors.black26,
                  ),
                ),
                Text(
                  "N° build $version. $buildSignature.$buildNumber",
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  openRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          child: AppRatingView(),
        );
      },
    );
  }
}
