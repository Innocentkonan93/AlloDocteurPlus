
// import 'package:app_allo_docteur_plus/data/RTC/signaling.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';

// class RTCView extends StatefulWidget {
//   const RTCView({Key? key, required this.title}) : super(key: key);

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<RTCView> createState() => _RTCViewState();
// }

// class _RTCViewState extends State<RTCView> {
//   Signaling signaling = Signaling();
//   RTCVideoRenderer _localRenderer = RTCVideoRenderer();
//   RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
//   String? roomId;
//   TextEditingController textEditingController = TextEditingController(text: '');

//   @override
//   void initState() {
//     _localRenderer.initialize();
//     _remoteRenderer.initialize();

//     signaling.onAddRemoteStream = ((stream) {
//       _remoteRenderer.srcObject = stream;
//       setState(() {});
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _localRenderer.dispose();
//     _remoteRenderer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Column(
//         children: [
//           Row(
//             children: [
//               ElevatedButton(
//                   onPressed: () async {
//                     signaling.openUserMedia(_localRenderer, _remoteRenderer);
//                   },
//                   child: const Text('Open microphone & camera')),
//               ElevatedButton(
//                   onPressed: () async {
//                     roomId = await signaling.createRoom(_remoteRenderer);
//                     textEditingController.text = roomId!;
//                   },
//                   child: const Text('Create Room')),
//               ElevatedButton(
//                   onPressed: () async {
//                     // roomId = await signaling.createRoom(_remoteRenderer);
//                     await signaling.joinRoom(roomId!);
//                   },
//                   child: const Text('Join Room')),
//             ],
//           ),
//           Expanded(child: RTCVideoView(_localRenderer, mirror: true,)),
//           Expanded(child: RTCVideoView(_remoteRenderer)),

//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Text('Join room'),
//                 Flexible(
//                   child: TextFormField(
//                     controller: textEditingController,
//                   ),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//       // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
