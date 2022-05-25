import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../widgets/ModalWidgets.dart';
import '../../../../data/services/ApiService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class NewMessage extends StatefulWidget {
  final String? channelID;
  final String? userEmail;
  final String? fichierConsultation;
  const NewMessage(this.channelID,
      {Key? key, this.userEmail, this.fichierConsultation})
      : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  ModalWidgets modalWidgets = ModalWidgets();
  // ScrollController _controller = ScrollController();
  FirebaseFirestore _db = FirebaseFirestore.instance;

  XFile? xFile;
  final ImagePicker _picker = ImagePicker();
  var messageText = "";
  String? uid;
  String? userDossier;
  String? userType;
  File? file;
  String status = "";
  String? base64Image;
  String? fileName;
  bool isLoading = false;
  final messageController = TextEditingController();

  Future chooseCameraImage(BuildContext context) async {
    Get.back();

    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      // maxWidth: maxWidth,
      // maxHeight: maxHeight,
      imageQuality: 100,
    );
    setState(() {
      xFile = pickedFile;
    });

    if (xFile == null) return;


      final filesPaths = xFile!.path;
      setState(() {
        file = File(filesPaths);
        base64Image = file!.readAsBytesSync().toString();
        fileName = (file!.path.split('/').last);
        print(fileName);
      });

    // send image path to the chat
    String newfilePath =
        "https://allodocteurplus.com/DossiersMedicaux/${widget.userEmail}/$fileName";

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.95),
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        content: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Spacer(),
            Image.file(
              file!,
              fit: BoxFit.contain,
            ),
            Spacer(),
            ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  label: Text(
                    'Annuler',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.orange[800],
                  ),
                ),
                TextButton.icon(
                  label: Text(
                    'Envoyer',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    Get.back();
                    await ApiService.uploadUserDoc(
                      context,
                      file!,
                      "${widget.userEmail}",
                      "$userDossier",
                    ).then((value) {
                      setState(() {
                        file = null;
                      });
                    });
                    await _db
                        .collection('chat/SzUELV4apD6ckKM8xHpY/channel')
                        .doc(widget.channelID)
                        .collection("message")
                        .add({
                      'text': newfilePath,
                      'sentAt': DateTime.now().toString(),
                      'uid': uid,
                    });
                  },
                  icon: Icon(Icons.send_rounded),
                ),
              ],
            )
          ],
        ),
      ),
    );
    //add file user medial folder

    messageController.clear();
    setState(() {
      messageText = "";
    });
  }

  Future chooseImage(BuildContext context) async {
    Get.back();
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.media,
    );
    if (result == null) return;
      final filesPaths = result.files.single.path;
      setState(() {
        file = File(filesPaths!);
        base64Image = file!.readAsBytesSync().toString();

        fileName = (file!.path.split('/').last);
        print(fileName);
      });

      // send image path to the chat
      String newfilePath =
          "https://allodocteurplus.com/DossiersMedicaux/${widget.userEmail}/$fileName";

      showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.95),
        builder: (context) => AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          content: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Spacer(),
              Image.file(
                file!,
                fit: BoxFit.contain,
              ),
              Spacer(),
              ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    label: Text(
                      'Annuler',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.orange[800],
                    ),
                  ),
                  TextButton.icon(
                    label: Text(
                      'Envoyer',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      Get.back();
                      await ApiService.uploadUserDoc(
                        context,
                        file!,
                        "${widget.userEmail}",
                        "$userDossier",
                      ).then((value) {
                        setState(() {
                          file = null;
                        });
                      });
                      await _db
                          .collection('chat/SzUELV4apD6ckKM8xHpY/channel')
                          .doc(widget.channelID)
                          .collection("message")
                          .add({
                        'text': newfilePath,
                        'sentAt': DateTime.now().toString(),
                        'uid': uid,
                      });
                    },
                    icon: Icon(Icons.send_rounded),
                  ),
                ],
              )
            ],
          ),
        ),
      );
      //add file user medial folder

      messageController.clear();
      setState(() {
        messageText = "";
      });
    
  }

  Future uploadDoc(
    BuildContext context,
    File imageFile,
    String userEmail,
    String userDossier,
  ) async {
// ignore: deprecated_member_use
    var stream = new http.ByteStream(StreamView(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse("https://allodocteurplus.com/api/uploadUserDoc.php");

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);
    request.fields['name'] = imageFile.path.split('/').last;
    request.fields['nom_document'] = "document";
    request.fields['email_utilisateur'] = userEmail;
    request.fields['dossier_utilisateur'] = userDossier;

    var respond = await request.send();
    if (respond.statusCode == 200) {
      print("Image Uploaded");
      final respStr = await respond.stream.bytesToString();
      print(respStr);
      if (respStr == "updated") {
        Navigator.of(context).pop("updated");
      }
    } else {
      print("Upload Failed");
    }
  }

  Future<String> getTypedUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = prefs.getString('userType').toString();
    return userType!;
  }

  Future<String> getUserID() async {
    Future.delayed(Duration(seconds: 20));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userID = prefs.getString('userID').toString();
    userDossier = prefs.getString('userDossier');
    print(userDossier);
    return userID;
  }

  Future<String> getPraticianID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String praticianID = prefs.getString('praticianID').toString();
    return praticianID;
  }

  Future<void> getID() async {
    String userType = await getTypedUserData();

    if (userType == "utilisateurs") {
      uid = await getUserID();
    } else {
      uid = await getPraticianID();
    }
  }

  void sendMessage() async {
    _db
        .collection('chat/SzUELV4apD6ckKM8xHpY/channel')
        .doc(widget.channelID)
        .collection("message")
        .add({
      'text': messageText,
      'sentAt': DateTime.now().toString(),
      'uid': uid,
    });
    messageController.clear();
    setState(() {
      messageText = "";
    });
    // FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    getTypedUserData();
    getID();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          // BoxShadow(
          //   offset: Offset(1, -1.6),
          //   color: Colors.black12.withOpacity(0.017),
          // ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                width: 0.4,
                color: Colors.grey.withOpacity(0.6),
              ),
              // bottom: BorderSide(
              //   width: 0.4,
              //   color: Colors.grey.withOpacity(0.6),
              // ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (userType == "utilisateurs")
                    IconButton(
                      onPressed: () {
                        ModalWidgets().addFileToChat(
                          context,
                          () async {
                            chooseCameraImage(context);
                          },
                          () async {
                            chooseImage(context);
                          },
                        );
                      },
                      icon: Icon(Icons.add_circle_outline_rounded),
                      color: Colors.blue,
                      // iconSize: 30,
                      padding: EdgeInsets.symmetric(horizontal: 1),
                    ),
                  Expanded(
                    child: Form(
                      child: TextField(
                        textInputAction: messageText == ""
                            ? TextInputAction.done
                            : TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines:
                            10, // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.
                        // expands: true,
                        controller: messageController,
                        onChanged: (val) {
                          setState(() {
                            messageText = val;
                          });
                        },

                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          hintText: "Écrire un message",
                          filled: true,
                          fillColor: Colors.white,
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          focusColor: Colors.green,
                          focusedBorder: OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderRadius: BorderRadius.circular(24),
                            borderSide:
                                BorderSide(color: Colors.green, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderRadius: BorderRadius.circular(24),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0),
                          ),
                          isDense: true,
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        autocorrect: true,
                        // expands: true,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: messageText.trim().isEmpty ? null : sendMessage,
                    child: Center(
                        child: Icon(
                      Icons.send_rounded,
                      size: 22,
                    )),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      fixedSize: Size(30, 30),
                      padding: EdgeInsets.all(5),
                      minimumSize: Size(30, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  )
                ],
              ),
              // if(userType != "utilisateurs")
              // Padding(
              //   padding: const EdgeInsets.all(5.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: [
              //       IconButton(
              //         onPressed: widget.fichierConsultation == null ? null : () {},
              //         icon: Icon(
              //           Icons.dock,

              //         ),
              //       ),
              //       IconButton(
              //         onPressed: () {},
              //         icon: Icon(
              //           Icons.camera_enhance_rounded,

              //         ),
              //       ),
              //       IconButton(
              //         onPressed: () {},
              //         icon:  Icon(Icons.list)
              //       ),

              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
