import '../../widgets/TimeAgo.dart';

import 'message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Messages extends StatefulWidget {
  final String? channelID;

  Messages(this.channelID, {Key? key}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final listKey = GlobalKey<AnimatedListState>();
  String? id;
  bool isVideoCall = false;

  Future<String> getTypedUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userType = prefs.getString('userType').toString();
    return userType;
  }

  Future<String> getUserID() async {
    Future.delayed(Duration(seconds: 20));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userID = prefs.getString('userID').toString();
    return userID;
  }

  Future<String> getPraticianID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String praticianID = prefs.getString('praticianID').toString();
    return praticianID;
  }

  Future<String> getID() async {
    String userType = await getTypedUserData();

    if (userType == "utilisateurs") {
      id = await getUserID();
    } else {
      id = await getPraticianID();
    }
    return id!;
  }

  @override
  void initState() {
    getID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final channelID = widget.channelID;
    return Stack(
      children: [
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chat/SzUELV4apD6ckKM8xHpY/channel')
                .snapshots(),
            builder: (_, s) {
              if (s.hasData) {
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chat/SzUELV4apD6ckKM8xHpY/channel')
                      .doc(channelID)
                      .collection("message")
                      .orderBy("sentAt", descending: true)
                      .snapshots(),
                  builder: (__, s2) {
                    if (s2.hasData) {
                      return s2.data!.docs.length == 0
                          ? Center(
                              child: Text('Aucun message'),
                            )
                          : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                              key: listKey,
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              // controller: _controller,
                              reverse: true,
                              itemCount: s2.data!.docs.length,
                              itemBuilder: (context, index) {
                                final message = s2.data!.docs[index];

                                final msg = s2.data!.docs[index].get("text");
                                if (msg == "Video") {
                                  isVideoCall = true;
                                  print(
                                      "isVideoCall:" + isVideoCall.toString());
                                }
                                // var sentDate = DateFormat.MMMd
                                var date = DateFormat(
                                  'HH:mm',
                                ).format(DateTime.tryParse(message["sentAt"])!);
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    MessageBubble(
                                      message["text"],
                                      message["uid"] == id,
                                      desciprionOrMotif: message["uid"],
                                      key: ValueKey(message.id),
                                    ),
                                    // if( message["uid"] != "descriptionOrMotif")
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 1,
                                        horizontal: 8,
                                      ),
                                      child: message["uid"] !=
                                              "descriptionOrMotif"
                                          ? Row(
                                              mainAxisAlignment:
                                                  message["uid"] == id
                                                      ? MainAxisAlignment.start
                                                      : MainAxisAlignment.end,
                                              children: [
                                                  Text(
                                                    // date.toString(),
                                                    TimeAgo.timeAgoSinceDate(
                                                        message["sentAt"]),
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey
                                                    ),
                                                  ),
                                              ],
                                            )
                                          : Container(),
                                    ),
                                  ],
                                );
                              },
                            );
                    } else {
                      return Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
            }),
      ],
    );
  }
}
