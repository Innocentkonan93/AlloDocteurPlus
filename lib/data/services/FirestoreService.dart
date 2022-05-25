import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  var channelCollection = FirebaseFirestore.instance
      .collection('chat/SzUELV4apD6ckKM8xHpY/channel');

// get all messages
  Stream<QuerySnapshot<Object?>> getAllMessages() {
    return _db.collection('chat/SzUELV4apD6ckKM8xHpY/messages').snapshots();
  }

// get pratician notifications
  Stream<QuerySnapshot<Object?>> getPraticianNotif(String praticianReceiver) {
    return _db
        .collection('notifications/yBlfDOUJ9hair4CP2aC4/praticiens')
        .where("pratician_receiver", isEqualTo: praticianReceiver,)
        .where("isView", isEqualTo: false)
        .snapshots();
  }

  // update pratician notifications
  Future<void> updatePraticianNotif(String docID, Map<String, dynamic> data) {
    return _db
        .collection('notifications/yBlfDOUJ9hair4CP2aC4/praticiens')
        .doc(docID)
        .update(data);
  }

  // get users notifications
  Stream<QuerySnapshot<Object?>> getUserNotif(String userReceiver) {
    return _db
        .collection('notifications/yBlfDOUJ9hair4CP2aC4/utilisateurs')
        .where("user_receiver", isEqualTo: userReceiver)
        .where("isView", isEqualTo: false)
        .snapshots();
  }

  // update user notifications
  Future<void> updateUsernNotif(String docID, Map<String, dynamic> data) {
    return _db
        .collection('notifications/yBlfDOUJ9hair4CP2aC4/utilisateurs')
        .doc(docID)
        .update(data);
  }

  Future<void> createChannel(String channelID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("channelID", channelID);
    channelCollection
        .doc(channelID)
        .collection("message")
        .add({'text': '', 'uid': ''});
  }

  Stream<QuerySnapshot<Object?>> channelMessages(String docID) {
    return channelCollection
        .doc(docID)
        .collection("message")
        .orderBy('creatAt', descending: true)
        .snapshots();
  }
}
