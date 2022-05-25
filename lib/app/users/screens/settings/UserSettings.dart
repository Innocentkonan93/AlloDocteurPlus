import 'package:google_fonts/google_fonts.dart';

import 'EditUserPassword.dart';
import '../../../../data/services/LoginService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import 'EditUserPhoto.dart';
import '../../../../data/controllers/UsersController.dart';
import '../../../../data/models/User.dart';
import '../../../../data/services/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettings extends StatefulWidget {
  final List<User> _currentUserList;
  const UserSettings(this._currentUserList, {Key? key}) : super(key: key);

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
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

  void _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditUserPhoto()),
    );
    if (result != null && result == "updated") {
      await getCurrentUserData();
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Photo modifiée'),
          backgroundColor: Colors.green,
        ));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentUser = widget._currentUserList.first;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gestion du compte',
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            letterSpacing: -1,
          ),
        ),
        centerTitle: true,
        elevation: 0.9,
      ),
      body: Container(
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: new CircleAvatar(
                  radius: size.width / 6,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: size.width / 6.5,
                    backgroundImage: currentUser.imageUtilisateur != null
                        ? NetworkImage(
                            "https://allodocteurplus.com/api/${currentUser.imageUtilisateur}",
                          )
                        : null,
                    child: currentUser.imageUtilisateur == null
                        ? Icon(
                            Icons.person,
                            color: Colors.white.withOpacity(0.23),
                            size: 60,
                          )
                        : null,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _navigateAndDisplaySelection(context);
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Modifier photo',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  "Nom complet",
                  style: GoogleFonts.nunito(
                    color: Colors.grey,
                  ),
                ),
                subtitle: Text(
                  "${currentUser.nomUtilisateur}",
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  "Email",
                  style: GoogleFonts.nunito(
                    color: Colors.grey,
                  ),
                ),
                subtitle: Text(
                  "${currentUser.emailUtilisateur}",
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // trailing: Icon(
                //   Icons.arrow_forward_ios_rounded,
                //   size: 15,
                // ),
                // onTap: (){
                //   Get.to(() =>
                //       EditUserEmail("${currentUser.emailUtilisateur}"));
                // },
              ),
              ListTile(
                title: Text(
                  "Mot de passe",
                  style: GoogleFonts.nunito(
                    color: Colors.grey,
                  ),
                ),
                subtitle: Text(
                  "**********",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                ),
                onTap: () {
                  Get.to(() =>
                      EditUserPassword("${currentUser.emailUtilisateur}"));
                },
              ),
              ListTile(
                title: Text(
                  "Numéro",
                  style: GoogleFonts.nunito(
                    color: Colors.grey,
                  ),
                ),
                subtitle: Text(
                  "${currentUser.numeroUtilisateur}",
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // trailing: Icon(
                //   Icons.arrow_forward_ios_rounded,
                //   size: 15,
                // ),
              ),
              Divider(
                height: 0.2,
              ),
              SwitchListTile.adaptive(
                value: true,
                onChanged: (val) {},
                title: Text(
                  "Notifications",
                  style: GoogleFonts.montserrat(),
                ),
              ),
              Divider(
                height: 0.2,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Déconnexion',
                        style: GoogleFonts.montserrat(),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red[600],
                    elevation: 0.0,
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Déconnexion',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                'Vous allez vous déconnecter !',
                                style: GoogleFonts.montserrat(),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Annuler',
                                  style: TextStyle(color: Colors.red)),
                            ),
                            OkWidget(currentUser),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class OkWidget extends StatefulWidget {
  final User currentUser;

  OkWidget(this.currentUser);

  @override
  _OkWidgetState createState() => _OkWidgetState();
}

class _OkWidgetState extends State<OkWidget> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  bool isOk = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        setState(() {
          isOk = true;
        });
        String usertopic =
            widget.currentUser.emailUtilisateur!.split("@").first;
        if (usertopic.contains(".")) {
          usertopic = usertopic.split(".").last;
        }
        await messaging
            .unsubscribeFromTopic(usertopic)
            .then((value) => print('unsuscribed'));
        LoginService().userLogout(context);
      },
      child: isOk
          ? SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator.adaptive())
          : Text("Ok"),
    );
  }
}
