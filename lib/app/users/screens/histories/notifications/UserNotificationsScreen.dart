import '../../../../utils/processs/chat/ChatScreen.dart';
import '../../../../utils/widgets/TimeAgo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../data/controllers/UsersController.dart';
import '../../../../../data/services/FirestoreService.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserNotificationScreen extends StatefulWidget {
  const UserNotificationScreen({Key? key}) : super(key: key);

  @override
  _UserNotificationScreenState createState() => _UserNotificationScreenState();
}

class _UserNotificationScreenState extends State<UserNotificationScreen> {
  FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userController = Provider.of<UsersController>(context);
    final currentUser = userController.listUsers.first;
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getUserNotif(currentUser.emailUtilisateur!),
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

            notifcations
                .sort((a, b) => -a["notif_date"].compareTo(b["notif_date"]));
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xFF0392CF),
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
                centerTitle: true,
                elevation: 0.0,
                leading: IconButton(
                  iconSize: 17,
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
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
                child: snapshot.data!.docs.length == 0
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
                          key: PageStorageKey('notifs'),
                          itemCount: notifcations.length,
                          itemBuilder: (context, i) {
                            final userNotif = notifcations[i];
                            Timestamp timeStampNotif = userNotif["notif_date"];
                            DateTime notifDate = timeStampNotif.toDate();
                            String notifDateDay = DateFormat("dd-MM")
                                .format(notifDate)
                                .toString();
                            String notifTime =
                                DateFormat("h:s").format(notifDate).toString();
                            return Column(
                              children: [
                                Divider(
                                  height: 0.1,
                                ),
                                Slidable(
                                  key: ValueKey(i),
                                  // startActionPane: ActionPane(
                                  //   motion: const ScrollMotion(),
                                  //   dismissible: DismissiblePane(
                                  //     onDismissed: () {},
                                  //   ),
                                  //   children: const [
                                  //     SlidableAction(
                                  //       onPressed: null,
                                  //       backgroundColor: Color(0xFFFE4A49),
                                  //       foregroundColor: Colors.white,
                                  //       icon: Icons.delete,
                                  //       label: 'Delete',
                                  //     ),
                                  //     SlidableAction(
                                  //       onPressed: null,
                                  //       backgroundColor: Color(0xFF21B7CA),
                                  //       foregroundColor: Colors.white,
                                  //       icon: Icons.share,
                                  //       label: 'Share',
                                  //     ),
                                  //   ],
                                  // ),
                                  endActionPane: ActionPane(
                                    motion: ScrollMotion(),
                                    children: [
                                      // SlidableAction(
                                      //   // An action can be bigger than the others.
                                      //   flex: 2,
                                      //   onPressed: null,
                                      //   backgroundColor: Color(0xFFFE4A49),
                                      //   foregroundColor: Colors.white,
                                      //   icon: CupertinoIcons.delete,
                                      //   label: 'Supprimer',
                                      // ),
                                      SlidableAction(
                                        flex: 1,
                                        onPressed: (context) async {
                                          final praticienEmail =
                                              userNotif['pratician_email'];
                                          final userReceiver =
                                              userNotif['user_receiver'];
                                          final channel = userNotif['channel'];
                                          print(userNotif['route_name']);
                                          if (userNotif['route_name'] ==
                                              "chat_screen") {
                                            Get.to(
                                              () => ChatScreen(userReceiver,
                                                  praticienEmail, channel),
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return NotificationAlert(
                                                  userNotif: userNotif,
                                                  notifDateDay: notifDateDay,
                                                  notifTime: notifTime,
                                                );
                                              },
                                            );
                                          }

                                          await firestoreService
                                              .updateUsernNotif(userNotif.id, {
                                            "isView": true,
                                          });
                                        },
                                        backgroundColor: Color(0xFF0392CF),
                                        foregroundColor: Colors.white,
                                        icon: CupertinoIcons.eye,
                                        label: 'Voir',
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    onTap: () async {
                                      final praticienEmail =
                                          userNotif['pratician_email'];
                                      final userReceiver =
                                          userNotif['user_receiver'];
                                      final channel = userNotif['channel'];
                                      print(userNotif['route_name']);
                                      if (userNotif['route_name'] ==
                                          "chat_screen") {
                                        Get.to(
                                          () => ChatScreen(userReceiver,
                                              praticienEmail, channel),
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return NotificationAlert(
                                              userNotif: userNotif,
                                              notifDateDay: notifDateDay,
                                              notifTime: notifTime,
                                            );
                                          },
                                        );
                                      }

                                      await firestoreService
                                          .updateUsernNotif(userNotif.id, {
                                        "isView": true,
                                      });
                                    },
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    tileColor: userNotif["isView"] == true
                                        ? Colors.blue.withOpacity(0.3)
                                        : Colors.white,
                                    // enabled: false,
                                    leading: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.black12,
                                        child: Icon(
                                          Icons.notifications_rounded,
                                          color: Colors.deepOrange,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      "${userNotif["title"]}",
                                      style: TextStyle(
                                        fontWeight: userNotif["isView"] != true
                                            ? FontWeight.w500
                                            : FontWeight.w300,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "${userNotif["body"]}",
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
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
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
              ),
            );
          }),
    );
  }
}

class NotificationAlert extends StatelessWidget {
  const NotificationAlert({
    Key? key,
    required this.userNotif,
    required this.notifDateDay,
    required this.notifTime,
  }) : super(key: key);

  final dynamic userNotif;
  final String notifDateDay;
  final String notifTime;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Row(
        children: [
          Icon(
            Icons.notifications_rounded,
            color: Colors.blue,
          ),
          SizedBox(width: 5),
          Flexible(
            child: Text(
              "${userNotif["title"]}",
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${userNotif["body"]}",
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
  }
}
