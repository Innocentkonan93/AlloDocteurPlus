import 'package:google_fonts/google_fonts.dart';

import '../../../../data/controllers/UsersController.dart';
import '../../../../data/services/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditUserPassword extends StatefulWidget {
  final String userEmail;
  const EditUserPassword(this.userEmail, {Key? key}) : super(key: key);

  @override
  _EditUserPasswordState createState() => _EditUserPasswordState();
}

class _EditUserPasswordState extends State<EditUserPassword> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmationController = TextEditingController();
  bool showNewPassword = false;
  bool showOldPassword = false;
  bool showConfirmPassword = false;

  bool isLoading = false;

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

  Future<void> _verifyPassword(String currentUserEmail) async {
    setState(() {
      isLoading = true;
    });
    final oldPassword = oldPasswordController.text;
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmationController.text;

    if (oldPassword.isNotEmpty &&
        newPassword.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        newPassword == confirmPassword) {
      final result = await ApiService.editUserPassword(
          currentUserEmail, oldPassword, newPassword);
      if (result == "updated") {
        await getCurrentUserData().then((value) {
          Navigator.pop(context);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Votre mot de passe bien été modifié",
            ),
            backgroundColor: Colors.green,
            duration: Duration(
              seconds: 5,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$result"),
            backgroundColor: Colors.red,
            duration: Duration(
              seconds: 15,
            ),
          ),
        );
      }
    }
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
            'Modifier mot de passe',
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              letterSpacing: -1,
              color: Colors.black,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  'Ancien'.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: oldPasswordController,
                  obscureText: !showOldPassword,
                  decoration: InputDecoration(
                    // label: Text("Ancien mot de passe"),
                    hintText: 'Ancien mot de passe',
                    filled: true,
                    border: InputBorder.none,
                    fillColor: Colors.blue[50],
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showOldPassword = !showOldPassword;
                        });
                      },
                      icon: Icon(!showOldPassword
                          ? Icons.remove_red_eye
                          : Icons.panorama_fish_eye_rounded),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Nouveau mot de passe'.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: !showNewPassword,
                  decoration: InputDecoration(
                    // label: Text(""),
                    hintText: 'Nouveau mot de passe',
                    filled: true,
                    border: InputBorder.none,
                    fillColor: Colors.blue[50],
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showNewPassword = !showNewPassword;
                        });
                      },
                      icon: Icon(!showNewPassword
                          ? Icons.remove_red_eye
                          : Icons.panorama_fish_eye_rounded),
                    ),
                    // suffix: Icon
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: confirmationController,
                  obscureText: !showConfirmPassword,
                  decoration: InputDecoration(
                    // label: Text("Confirmation"),
                    hintText: 'Confirmation',
                    filled: true,
                    border: InputBorder.none,
                    fillColor: Colors.blue[50],
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          showConfirmPassword = !showConfirmPassword;
                        });
                      },
                      icon: Icon(!showConfirmPassword
                          ? Icons.remove_red_eye
                          : Icons.panorama_fish_eye_rounded),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                    onPressed: () async {
                      _verifyPassword(widget.userEmail).then((value) {
                        setState(() {
                          isLoading = false;
                        });
                      });
                    },
                    child: isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator.adaptive(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white)),
                          )
                        : Text("Modifier"),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      fixedSize: isLoading ? Size(22, 22) : null,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
