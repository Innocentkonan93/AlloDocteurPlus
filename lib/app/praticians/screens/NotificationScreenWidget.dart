import 'dart:async';

import '../../utils/widgets/TimeAgo.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/controllers/PraticienController.dart';
import '../../../data/services/FirestoreService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationScreenWidget extends StatefulWidget {
  const NotificationScreenWidget({Key? key}) : super(key: key);

  @override
  _NotificationScreenWidgetState createState() =>
      _NotificationScreenWidgetState();
}

class _NotificationScreenWidgetState extends State<NotificationScreenWidget> {
  List notifs = [];
  FirestoreService firestoreService = FirestoreService();
  bool hasInternet = true;
  late StreamSubscription internetsubscription;
  @override
  void initState() {
    internetsubscription =
        InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() {
        this.hasInternet = hasInternet;
      });
      print(hasInternet);
    });
    super.initState();
  }

  @override
  void dispose() {
    internetsubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final praticienController = Provider.of<PraticienController>(context);
    final praticienList = praticienController.listPraticiens;
    final currentPraticien = praticienList.first;
    return hasInternet
        ? Container(
            child: StreamBuilder<QuerySnapshot>(
                stream: firestoreService
                    .getPraticianNotif(currentPraticien.emailPraticien!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  final List notifcations = [];
                  snapshot.data!.docs.forEach((doc) {
                    notifcations.add(doc);
                  });

                  notifcations.sort(
                    (a, b) => -a["notif_date"].compareTo(b["notif_date"]),
                  );
                  // FlutterAppBadger.removeBadge();
                  return Scaffold(
                    appBar: AppBar(
                      systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarBrightness: Brightness.dark),
                      title: Text(
                        'Notifications',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          letterSpacing: -1,
                        ),
                      ),
                      // ignore: deprecated_member_use
                      brightness: Brightness.dark,
                      elevation: 0.0,
                      backgroundColor: Color(0XFF101A69),
                      actions: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "${notifcations.length}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 17),
                            ),
                          ),
                        )
                      ],
                    ),
                    body: Container(
                      height: size.height,
                      child: notifcations.length == 0
                          ? Container(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Image.asset(
                                      "assets/images/notifications.png",
                                    ),
                                  ),
                                  // Spacer(),
                                  Text(
                                    'Aucune nouvelle notification',
                                    style: GoogleFonts.nunito(),
                                  ),
                                ],
                              ),
                            )
                          : Scrollbar(
                              radius: Radius.circular(20),
                              thickness: 5,
                              child: ListView.builder(
                                itemCount: notifcations.length,
                                itemBuilder: (context, i) {
                                  final praticienNotif = notifcations[i];
                                  Timestamp timeStampNotif =
                                      praticienNotif["notif_date"];
                                  DateTime notifDate = timeStampNotif.toDate();
                                  String notifDateDay = DateFormat("dd-MM-yyyy")
                                      .format(notifDate)
                                      .toString();
                                  String notifTime = DateFormat("h:s")
                                      .format(notifDate)
                                      .toString();
                                  return Column(
                                    children: [
                                      Divider(
                                        height: 0.1,
                                      ),
                                      ListTile(
                                        onTap: () async {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  title: Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .notifications_rounded,
                                                        color: Colors.blue,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Flexible(
                                                        child: Text(
                                                          "${praticienNotif["title"]}",
                                                          style: TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        "${praticienNotif["body"]}",
                                                      ),
                                                      SizedBox(height: 10),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "${notifDateDay}",
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                          SizedBox(width: 5),
                                                          Text(
                                                            "à",
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                          SizedBox(width: 5),
                                                          Text(
                                                            "${notifTime}",
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                );
                                              });
                                          await firestoreService
                                              .updatePraticianNotif(
                                                  praticienNotif.id, {
                                            "isView": true,
                                          });
                                          // setState(() {

                                          // });
                                        },
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        tileColor:
                                            praticienNotif["isView"] == true
                                                ? Colors.blue.withOpacity(0.3)
                                                : Colors.white,
                                        // enabled: false,
                                        leading: SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: CircleAvatar(
                                            backgroundColor: Color(0XFF101A69)
                                                .withOpacity(0.53),
                                            child: Icon(
                                              Icons.notifications_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          "${praticienNotif["title"]}",
                                          style: GoogleFonts.nunito(
                                            fontWeight:
                                                !praticienNotif["isView"]
                                                    ? FontWeight.bold
                                                    : FontWeight.w300,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${praticienNotif["body"]}",
                                          style: GoogleFonts.nunito(
                                              fontSize: 12,
                                              fontWeight:
                                                  !praticienNotif["isView"]
                                                      ? FontWeight.w500
                                                      : null),
                                        ),
                                        trailing: SizedBox(
                                          width: 60,
                                          height: 40,
                                          child: Text(
                                            // "${notifDateDay}",
                                            TimeAgo.timeAgoSinceDate(notifDate.toString()),
                                            style: TextStyle(
                                              fontSize: 10,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                    ),
                  );
                }),
          )
        : NotificationScreenWidget();
  }
}
