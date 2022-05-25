// import 'package:allo_docteur_plus/app/utils/processs/chat/ChatScreen.dart';
// import 'package:allo_docteur_plus/app/utils/processs/videos/VideoScreen.dart';
// import 'package:flutter/material.dart';

// class MeetScreen extends StatefulWidget {
//   final String emailUser;
//   final String emailPraticien;
//   final String idDemande;
//   final PageController pageController;

//   const MeetScreen(this.emailUser, this.emailPraticien, this.idDemande, this.pageController,
//       {Key? key})
//       : super(key: key);

//   @override
//   _MeetScreenState createState() => _MeetScreenState();
// }

// class _MeetScreenState extends State<MeetScreen> {
//   final pageController = PageController();
//   @override
//   Widget build(BuildContext context) {
//     return PageView(
//       controller: pageController,
//       children: [
//         ChatScreen(
//           widget.emailUser,
//           widget.emailPraticien,
//           widget.idDemande,
//           pageController
//         ),
//         VideoScreen(),
//       ],
//     );
//   }
// }
