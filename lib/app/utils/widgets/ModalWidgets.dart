import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ModalWidgets {
  chatScreenModalActions(
    BuildContext context,
    String typeDemande,
    VoidCallback createBulletin,
    VoidCallback onPrescription,
    VoidCallback onSuspended,
    VoidCallback onDone,
  ) {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text(
              "Options de consultations",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            actions: [
              if (typeDemande != "Informations")
                CupertinoActionSheetAction(
                  onPressed: createBulletin,
                  child: Text("Bulletin"),
                ),
              if (typeDemande != "Informations")
                CupertinoActionSheetAction(
                  onPressed: onPrescription,
                  child: Text("Ordonnance"),
                ),
              CupertinoActionSheetAction(
                onPressed: onSuspended,
                child: Text("Suspendre la consultation"),
              ),
              CupertinoActionSheetAction(
                onPressed: onDone,
                child: Text("Terminer la consultation"),
                isDestructiveAction: true,
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
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
                if (typeDemande != "Informations")
                  ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.newspaper,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Bulletin',
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: createBulletin,
                  ),
                if (typeDemande != "Informations")
                  ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.filePrescription,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Ordonnance',
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: onPrescription,
                  ),
                ListTile(
                  leading: Icon(Icons.pause, color: Colors.black),
                  title: Text(
                    'Suspendre la consultation',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: onSuspended,
                ),
                ListTile(
                  leading: Icon(Icons.check, color: Colors.black),
                  title: Text(
                    'Terminer la consultation',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: onDone,
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.close, color: Colors.red),
                  title: Text(
                    'Annuler',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  addFileToChat(
    BuildContext context,
    VoidCallback openCamera,
    VoidCallback openGallery,
  ) {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            message: Text(
              'Envoyez des flichiers',
            ),
            actions: [
              CupertinoActionSheetAction(
                onPressed: openCamera,
                child: Text("Camera"),
              ),
              CupertinoActionSheetAction(
                onPressed: openGallery,
                child: Text("Galérie Photo et Vidéo"),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Annuler"),
              isDestructiveAction: true,
            ),
          );
        },
      );
    } else {
      showModalBottomSheet(
        isDismissible: false,
        context: context,
        barrierColor: kCupertinoModalBarrierColor,
        builder: (context) {
          return Container(
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.camera,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Camera',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: openCamera,
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.image,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Galérie Photo et Vidéo',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: openGallery,
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.close, color: Colors.red),
                  title: Text(
                    'Annuler',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
