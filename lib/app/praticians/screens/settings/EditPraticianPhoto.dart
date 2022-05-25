// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPraticianPhoto extends StatefulWidget {
  const EditPraticianPhoto({Key? key}) : super(key: key);

  @override
  _EditPraticianPhotoState createState() => _EditPraticianPhotoState();
}

class _EditPraticianPhotoState extends State<EditPraticianPhoto> {
  File? file;
  XFile? xFile;
  String status = "";
  String? base64Image;
  String? fileName;
  String? praticianEmail;
  File? tmpFile;
  bool isLoading = false;
  bool isCamera = false;
  String errMessage = "Error lors du téléchargement";
  final ImagePicker _picker = ImagePicker();

  Future<String> getPraticianID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    praticianEmail = prefs.getString('praticianEmail').toString();
    print(praticianEmail);
    return praticianEmail!;
  }

  Future chooseGalerieImage() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );

    if (result != null) {
      final filesPaths = result.files.single.path;
      setState(() {
        isCamera = true;
        file = File(filesPaths!);
        base64Image = file!.readAsBytesSync().toString();

        fileName = (file!.path.split('/').last);
        print(fileName);
      });
    }
  }

  Future chooseCameraImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      // maxWidth: maxWidth,
      // maxHeight: maxHeight,
      imageQuality: 100,
    );
    setState(() {
      xFile = pickedFile;
    });

    if (xFile != null) {
      final filesPaths = xFile!.path;
      setState(() {
        file = File(filesPaths);
        base64Image = file!.readAsBytesSync().toString();
        isCamera = true;
        fileName = (file!.path.split('/').last);
        print(fileName);
      });
    }
  }

  Future uploadImage(BuildContext context, File imageFile) async {
    setState(() {
      isLoading = true;
    });
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer " + "ghjklljhggjhk"
    };
// ignore: deprecated_member_use
    var stream = new http.ByteStream(StreamView(imageFile.openRead()));
    var length = await imageFile.length();
    var uri =
        Uri.parse("https://allodocteurplus.com/api/uploadPraticianImage.php");

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));

    request.headers.addAll(headers);
    request.files.add(multipartFile);
    request.fields['name'] = imageFile.path.split('/').last;
    request.fields['email_praticien'] = praticianEmail!;
// request.fields['producttype'] = controllerType.text;
// request.fields['product_owner'] = globals.restaurantId;

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

  @override
  void initState() {
    getPraticianID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Modifier votre photo",
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            letterSpacing: -1,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (Platform.isIOS) {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return CupertinoActionSheet(
                        actions: [
                          CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.pop(context);
                              chooseGalerieImage();
                            },
                            child: Text("Galérie"),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.pop(context);
                              chooseCameraImage();
                            },
                            child: Text("Caméra"),
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          isDestructiveAction: true,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Annuler"),
                        ),
                      );
                    },
                  );
                } else {
                  showModalBottomSheet(
                    context: context,
                    barrierColor: kCupertinoModalBarrierColor,
                    builder: (context) {
                      return Container(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            ListTile(
                              leading: FaIcon(
                                FontAwesomeIcons.images,
                                color: Colors.black,
                              ),
                              title: Text(
                                'Galérie',
                                style: TextStyle(color: Colors.black),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                chooseGalerieImage();
                              },
                            ),
                            ListTile(
                              leading: FaIcon(
                                FontAwesomeIcons.camera,
                                color: Colors.black,
                              ),
                              title: Text(
                                'Caméra',
                                style: TextStyle(color: Colors.black),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                chooseCameraImage();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
              child: file == null
                  ? CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.grey[100],
                      child: Icon(Icons.photo_camera, size: 45),
                    )
                  : CircleAvatar(
                      radius: 100,
                      backgroundImage: FileImage(
                        file!,
                      ),
                      child: Container(),
                    ),
            ),
            if (file != null)
              if (isLoading == false)
                ElevatedButton(
                  onPressed: () {
                    uploadImage(context, file!);
                  },
                  child: Text('Télécharger'),
                ),
            SizedBox(height: 10),
            if (isLoading)
              SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator.adaptive(),
              )
          ],
        ),
      ),
    );
  }
}
