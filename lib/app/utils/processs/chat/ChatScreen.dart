import 'dart:io';
import 'package:chatview/chatview.dart';

import '../../../../data/controllers/UserDemandeController.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/models/Praticien.dart';

import '../../../praticians/screens/process/BulletinScreen.dart';
import '../../../praticians/screens/process/PrescriptionScreen.dart';
import '../../../users/screens/home/UserMenuTab.dart';
import 'messages.dart';
import 'new_message.dart';
import '../../widgets/ModalWidgets.dart';
import '../../widgets/UserInfoModal.dart';
import '../../../../data/controllers/PraticienController.dart';
import '../../../../data/controllers/UserConsultationController.dart';
import '../../../../data/controllers/UsersController.dart';
import '../../../../data/models/User.dart';
import '../../../../data/services/ApiService.dart';
import '../../../../data/services/PDFApi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final String emailUser;
  final String emailPraticien;
  final String idDemande;
  final String? descritpionOrMotif;
  const ChatScreen(this.emailUser, this.emailPraticien, this.idDemande,
      {Key? key, this.descritpionOrMotif})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  ModalWidgets modalWidgets = ModalWidgets();

  // ScrollController _controller = ScrollController();
  String? messageText;
  bool isReceiver = false;
  bool isLoading = false;
  String? userType;
  String? emailUser;
  String? emailPraticien;
  String? idDemande;
  // Stream<QuerySnapshot>? streamMessage;

  final serverText = TextEditingController();
  final roomText = TextEditingController(text: "plugintestroom");
  final subjectText = TextEditingController(text: "Consultation");
  final nameText = TextEditingController(text: "Allô Docteur+ User");
  final iosAppBarRGBAColor =
      TextEditingController(text: "#0080FF80"); //transparent blue
  bool? isAudioOnly = false;
  bool? isAudioMuted = false;
  bool? isVideoMuted = false;

  final messageController = TextEditingController();

  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Color(0XFF101A69) : Colors.white,
        ),
      );
    },
  );

  Future<String> getUserType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = prefs.getString('userType');
    return userType!;
  }

  void addNotif(String emailUser) async {
    var topic = emailUser.split("@").first;
    if (topic.contains(".")) {
      topic = topic.split('.').last;
    }
    _db.collection("notifications/yBlfDOUJ9hair4CP2aC4/chatNotifications").add(
      {
        "title": "Appel vidéo",
        "body": "Appel vidéo entrant",
        "notif_date": Timestamp.now(),
        "topic_receiver": topic,
        "user_receiver": emailUser,
        "channel": idDemande,
      },
    );
    // _db
    //     .collection("notifications/yBlfDOUJ9hair4CP2aC4/chatNotifications")
    //     .doc(idDemande)
    //     .set({
    //   "title": "Appel vidéo",
    //   "body": "Appel vidéo entrant",
    //   "notif_date": Timestamp.now(),
    //   "topic_receiver": topic,
    //   "user_receiver": emailUser,
    //   "channel": idDemande,
    // });
  }

  void createBulletin(User user, Praticien praticien) async {
    Navigator.of(context).pop();
    Future.delayed(Duration(milliseconds: 200), () {});
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BulletinScreen("$idDemande", user, praticien),
        fullscreenDialog: true,
      ),
    );
  }

  void onPresciption(User user, Praticien praticien) async {
    Navigator.of(context).pop();
    Future.delayed(Duration(milliseconds: 200), () {});
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PrescriptionScreen("$idDemande", user, praticien),
        fullscreenDialog: true,
      ),
    );
  }

  void onSuspended(String idConsultation, String emailPraticien) async {
    Navigator.of(context).pop();
    setState(() {
      isLoading = true;
    });
    final result =
        await ApiService.suspendedConsultation(idConsultation, emailPraticien);
    print(result);

    var topic = emailUser!.split("@").first;
    if (topic.contains(".")) {
      topic = topic.split('.').last;
    }
    await _db.collection("notifications/yBlfDOUJ9hair4CP2aC4/utilisateurs").add(
      {
        "title": "Consultation",
        "body": "Votre médecin en charge a suspendu la consultation",
        "notif_date": Timestamp.now(),
        "topic_receiver": topic,
        "user_receiver": emailUser,
        "channel": idDemande,
        "pratician_email": emailPraticien,
        "isView": false,
        "route_name": "consultation_screen"
      },
    );
    Get.back();
    setState(() {});
  }

  void onDone(String idConsultation, String emailPraticien) async {
    Navigator.of(context).pop();
    setState(() {
      isLoading = true;
    });
    final result =
        await ApiService.doneConsultation(idConsultation, emailPraticien);
    print(result);
    var topic = emailUser!.split("@").first;
    if (topic.contains(".")) {
      topic = topic.split('.').last;
    }
    await _db.collection("notifications/yBlfDOUJ9hair4CP2aC4/utilisateurs").add(
      {
        "title": "Consultation",
        "body": "Votre médecin en charge a terminé la consultation",
        "notif_date": Timestamp.now(),
        "topic_receiver": topic,
        "user_receiver": emailUser,
        "channel": idDemande,
        "pratician_email": emailPraticien,
        "isView": false,
        "route_name": "consultation_screen"
      },
    );
    Get.back(result: "done");
  }

  void setVideoNotif() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = await prefs.getString('userType');
    print(userType);
    if (userType != "praticiens") {
      // catch video call messaging
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null &&
            message.notification!.title == "Appel vidéo") {
          print(message.notification!.body);
          print(message.notification!.title);
          if (Vibrate.canVibrate == true) {
            Vibrate.vibrate();
          }

          if (mounted)
            Get.snackbar(
              "",
              "",
              titleText: Text(
                "Consultation vidéo",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              messageText: ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.videocam,
                        color: Colors.green,
                        size: 35,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  "Rejoindre",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          _joinMeeting();
                        },
                        child: Icon(
                          Icons.call,
                          color: Colors.green,
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Icons.call_end,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              duration: Duration(minutes: 5),
              borderRadius: 10.0,
              backgroundColor: Colors.black.withOpacity(0.75),
              padding: EdgeInsets.all(10),
              animationDuration: Duration(milliseconds: 100),
              boxShadows: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 5,
                  offset: Offset(0.0, 0.0),
                )
              ],
            );
        }
      });
    }
  }

  Future<List> getAllConsultations() async {
    var provider =
        Provider.of<UserConsultationController>(context, listen: false);
    var resp = await ApiService.getAllConsultations();
    if (resp.isSuccesful) {
      provider.setConsultationsList(resp.data);

      provider.isProces(resp.isSuccesful);
    }
    return resp.data;
  }

  Future<void> getCurrentUserData() async {
    // var userID = await getUserID();
    var resp = await ApiService.getAllUtilisateurs();
    var provider = Provider.of<UsersController>(context, listen: false);

    if (resp.isSuccesful) {
      provider.setUserList(resp.data);

      provider.isProces(resp.isSuccesful);
    }
  }

  void sendFirstMessage() async {
    if (widget.descritpionOrMotif != null &&
        widget.descritpionOrMotif!.isNotEmpty) {
      _db
          .collection('chat/SzUELV4apD6ckKM8xHpY/channel')
          .doc(widget.idDemande)
          .collection("message")
          .add({
        'text': widget.descritpionOrMotif,
        'sentAt': DateTime.now().toString(),
        'uid': "descriptionOrMotif",
      });
      messageController.clear();
      setState(() {
        messageText = "";
      });
    }

    // FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    emailUser = widget.emailUser;
    emailPraticien = widget.emailPraticien;
    idDemande = widget.idDemande;
    _messaging.subscribeToTopic("$idDemande");
    //  getUserType();
    sendFirstMessage();
    getAllConsultations();
    print(getUserType());
    getCurrentUserData();

    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));

    // suscribe to topic
    if (mounted) setVideoNotif();

    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // get current consultation
    final consultationController =
        Provider.of<UserConsultationController>(context);
    final currentConsulation = consultationController.listConsultations
        .where((consultation) => consultation.idDemande == widget.idDemande);

    // get current demande
    final demandeController =
        Provider.of<UserDemandeDemandeController>(context);
    final currentDemande = demandeController.listUserDemandes
        .where((demande) => demande.idDemande == widget.idDemande);

    // get current praticien
    final praticienController = Provider.of<PraticienController>(context);
    final currentPraticien = praticienController.listPraticiens.where(
        (praticien) => praticien.emailPraticien == widget.emailPraticien);

    // get current patient
    final patientController = Provider.of<UsersController>(context);
    final currentPatient = patientController.listUsers
        .where((patient) => patient.emailUtilisateur == widget.emailUser);
    List<Message> messageList = [
      Message(
        id: '1',
        message: "Hi",
        createdAt: DateTime.now(),
        sendBy: "1",
      ),
      Message(
        id: '2',
        message: "Hello",
        createdAt: DateTime.now().add(Duration(seconds: 10)),
        sendBy: "2",
      ),
    ];
    final chatController = ChatController(
      initialMessageList: messageList,
      scrollController: ScrollController(),
    );
    //
    return patientController.isProcessing &&
            consultationController.isProcessing &&
            praticienController.isProcessing
        ? Stack(
            children: [
              WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Scaffold(
                      resizeToAvoidBottomInset: true,
                      appBar: AppBar(
                        backgroundColor: Colors.white,
                        automaticallyImplyLeading: false,
                        title: userType == "praticiens"
                            ? Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      '${currentPatient.first.nomUtilisateur}',
                                      style: GoogleFonts.nunito(
                                        color: Colors.black,
                                        letterSpacing: -0.8,
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Dr. ${currentPraticien.first.nomPraticien}',
                                      style: GoogleFonts.nunito(
                                        color: Colors.black,
                                        letterSpacing: -0.8,
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        iconTheme: IconThemeData(color: Colors.black),
                        elevation: 1,
                        actions: [
                          // if (userType == "praticiens")
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(24))),
                                builder: (context) {
                                  return Container(
                                    height: size.height * 0.9,
                                    color: Colors.transparent,
                                    child: UserInfoModal(currentPatient.first),
                                  );
                                },
                              );
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.idCardAlt,
                              size: 20,
                              color: Colors.blue[900],
                            ),
                          ),
                          if (userType == "praticiens")
                            if (consultationController.isProcessing &&
                                currentConsulation.isNotEmpty &&
                                currentConsulation.first.fichierConsultation !=
                                    "null")
                              PopupMenuButton<String>(
                                padding: EdgeInsets.all(5),
                                tooltip: "Fichier à interpréter",
                                icon: Icon(
                                  Icons.file_present_rounded,
                                  color: Colors.deepOrange[700],
                                ),
                                color: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onSelected: (String result) {
                                  setState(() {});
                                },
                                itemBuilder: (BuildContext context) {
                                  final consulationFile = currentConsulation
                                      .first.fichierConsultation;
                                  final fileExt =
                                      consulationFile!.split(".").last;
                                  return <PopupMenuEntry<String>>[
                                    PopupMenuItem<String>(
                                      value: "doc",
                                      child: fileExt == "pdf"
                                          ? GestureDetector(
                                              onTap: () async {
                                                final endPoint =
                                                    "https://allodocteurplus.com/DossiersMedicaux/${currentConsulation.first.emailPatient}/$consulationFile";
                                                await PDFApi.loadNetwork(
                                                    endPoint);
                                              },
                                              child: Container(
                                                width: 150,
                                                child: Row(
                                                  children: [
                                                    FaIcon(FontAwesomeIcons
                                                        .filePdf),
                                                    SizedBox(width: 10),
                                                    Flexible(
                                                      child: Text(
                                                        "$consulationFile",
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          : SizedBox(
                                              width: 300,
                                              height: 400,
                                              child: Center(
                                                child: Image.network(
                                                  "https://allodocteurplus.com/DossiersMedicaux/${currentConsulation.first.emailPatient}/$consulationFile",
                                                  fit: BoxFit.cover,
                                                  scale: 1,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ];
                                },
                              ),
                          if (userType == "praticiens")
                            IconButton(
                              tooltip: "Appel vidéo",
                              onPressed: () {
                                _joinMeeting();
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.video,
                                size: 20,
                                color: Colors.teal,
                              ),
                            ),
                          if (userType == "praticiens")
                            IconButton(
                              tooltip: "Menu consultation",
                              onPressed: () {
                                modalWidgets.chatScreenModalActions(
                                  context,
                                  currentDemande.first.typeDemande.toString(),
                                  () {
                                    createBulletin(currentPatient.first,
                                        currentPraticien.first);
                                  },
                                  () {
                                    onPresciption(currentPatient.first,
                                        currentPraticien.first);
                                  },
                                  () {
                                    onSuspended(
                                      "${currentConsulation.first.idConsultation}",
                                      "$emailPraticien",
                                    );
                                  },
                                  () {
                                    onDone(
                                      "${currentConsulation.first.idConsultation}",
                                      "$emailPraticien",
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.more_vert,
                              ),
                            ),
                          if (userType != "praticiens" &&
                              consultationController.isProcessing)
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text(
                                            'Annuler',
                                            style: GoogleFonts.nunito(),
                                          ),
                                          style: TextButton.styleFrom(
                                              primary: Colors.red),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Get.offAll(
                                              () => UserMenuTab(),
                                            );
                                          },
                                          child: Text(
                                            'OK',
                                            style: GoogleFonts.nunito(),
                                          ),
                                        ),
                                      ],
                                      content: Container(
                                        padding: EdgeInsets.all(12),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Fermerture",
                                              style: GoogleFonts.nunito(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.red),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "Voulez vous quitter la consultation ?",
                                              style: GoogleFonts.montserrat(
                                                fontSize: 18,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.close, size: 17),
                            ),
                        ],
                      ),
                    // body: ChatView(
                    //   sender: ChatUser(id: '1', name: 'Flutter'),
                    //   receiver: ChatUser(id: '2', name: 'Simform'),
                    //   chatController: chatController,
                    //   onSendTap: (m, rm) {},
                    // )

                    body: Container(
                        height: size.height,
                      decoration: BoxDecoration(color: Colors.white),
                        child: Column(
                          children: [
                            Expanded(
                              child: Messages(
                                idDemande,
                              ),
                            ),
                            NewMessage(
                              idDemande,
                              userEmail: widget.emailUser,
                            )
                          ],
                        ),
                    ),
                  ),
                ),
              ),
              if (isLoading)
                Opacity(
                  opacity: 1,
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: spinkit,
                    ),
                  ),
                ),
            ],
          )
        : Container(
            color: Colors.white,
            child: Center(
              // child: spinkit,
              child: CircularProgressIndicator.adaptive(),
            ),
          );
  }

  _joinMeeting() async {
    // String? serverUrl = null;

    // Enable or disable any feature flag here
    // If feature flag are not provided, default values will be used
    // Full list of feature flags (and defaults) available in the README
    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };
    if (!kIsWeb) {
      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
        featureFlags[FeatureFlagEnum.CHAT_ENABLED] = false;
        featureFlags[FeatureFlagEnum.ADD_PEOPLE_ENABLED] = false;
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
        featureFlags[FeatureFlagEnum.RAISE_HAND_ENABLED] = false;
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        // featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
        // featureFlags[FeatureFlagEnum.CHAT_ENABLED] = false;
        // featureFlags[FeatureFlagEnum.ADD_PEOPLE_ENABLED] = false;

        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
        featureFlags[FeatureFlagEnum.CHAT_ENABLED] = false;
        featureFlags[FeatureFlagEnum.ADD_PEOPLE_ENABLED] = false;
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
        featureFlags[FeatureFlagEnum.RAISE_HAND_ENABLED] = false;
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }
    }
    // Define meetings options here
    var options = JitsiMeetingOptions(room: widget.idDemande)
      ..subject = "Consultation vidéo"
      ..userDisplayName = "Allô Docteur"
      ..userEmail = emailPraticien
      ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
      ..audioOnly = isAudioOnly
      ..audioMuted = isAudioMuted
      ..videoMuted = isVideoMuted
      ..featureFlags.addAll(featureFlags)
      ..webOptions = {
        "roomName": widget.idDemande,
        "width": "100%",
        "height": "100%",
        "enableWelcomePage": false,
        "chromeExtensionBanner": null,
        "userInfo": {"displayName": nameText.text}
      };

    debugPrint("JitsiMeetingOptions: $options");
    if (userType == "praticiens") {
      addNotif(widget.emailUser);
    }
    await JitsiMeet.joinMeeting(
      options,
      listener: JitsiMeetingListener(
        onError: (message) {
          print("error:" + message);
        },
        onConferenceWillJoin: (message) {
          debugPrint("${options.room} will join with message: $message");
        },
        onConferenceJoined: (message) {
          debugPrint("${options.room} joined with message: $message");
        },
        onConferenceTerminated: (message) {
          debugPrint("${options.room} terminated with message: $message");
          // Get.back();
        },
        genericListeners: [
          JitsiGenericListener(
            eventName: 'readyToClose',
            callback: (dynamic message) {
              debugPrint("readyToClose callback");
            },
          ),
        ],
      ),
    );
  }

  void _onConferenceWillJoin(message) {
    // debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined(message) {
    // debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated(message) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
    if (userType != "praticiens") {
      Future.delayed(Duration(seconds: 4), () {
        Get.back();
      });
    }
    print(
        'Appel vidéo terminé ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss');
  }

  _onError(error) {
    // debugPrint("_onError broadcasted: $error");
  }
}
