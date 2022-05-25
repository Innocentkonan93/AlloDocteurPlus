// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:allo_docteur_plus/data/credentials/AgoraAppID.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// class AgoraViewScreen extends StatefulWidget {
//   const AgoraViewScreen({Key? key}) : super(key: key);

//   @override
//   _AgoraViewScreenState createState() => _AgoraViewScreenState();
// }

// class _AgoraViewScreenState extends State<AgoraViewScreen> {
//   RtcEngine? rtcEngine;
//   List<AgoraUser> userList = [];

//   @override
//   void initState() async {
//     rtcEngineInit();
//     super.initState();
//   }

//   void rtcEngineInit (){
//     RtcEngine.createWithContext(RtcEngineContext(AgoraAppId)).then((engine) {
//       rtcEngine = engine
//         ..setEventHandler(
//           RtcEngineEventHandler(
//             userJoined: (uid, elapsed) {
//               setState(() {
//                 userList.add(AgoraUser(uid.toString(), uid));
//               });
//             },
//             userOffline: (uid, elapsed) {
//               setState(() {
//                 userList.removeWhere((user) => user.agoraId == uid);
//               });
//             },
//           ),
//         );
//     });

//   }
// @override
//   void dispose() {
//     rtcEngine!.leaveChannel();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: SafeArea(
//           child: Stack(
//             children: [],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AgoraUser {
//   final String name;
//   final int agoraId;
//   AgoraUser(this.name, this.agoraId);
// }
