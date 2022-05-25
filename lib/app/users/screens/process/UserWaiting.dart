import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/processs/chat/ChatScreen.dart';
import '../../../../data/controllers/PraticienController.dart';
import '../../../../data/controllers/UserDemandeController.dart';
import '../../../../data/services/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class UserWaiting extends StatefulWidget {
  const UserWaiting({required this.idDemande, Key? key}) : super(key: key);
  final String idDemande;

  @override
  _UserWaitingState createState() => _UserWaitingState();
}

class _UserWaitingState extends State<UserWaiting> {
  // FirebaseFirestore _db = FirebaseFirestore.instance;
  String? demandeID;
  String? demandeStatus;
  PageController pageController = PageController();
  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.blue : Colors.green,
        ),
      );
    },
  );

  Stream<String> get demandStatusStream async* {
    for (var i = 0; i <= 10000; i++) {
      await Future.delayed(Duration(seconds: 5));

      yield await ApiService.getDemandeStatus(widget.idDemande);
      i++;
    }
  }

  Future<void> getAllDemandes() async {
    var provider =
        Provider.of<UserDemandeDemandeController>(context, listen: false);
    var resp = await ApiService.getAllDemandes();
    if (resp.isSuccesful) {
      provider.setUserDemandeList(resp.data);
      provider.isProces(resp.isSuccesful);
    }
  }

  Future<List> getAllPraticiens() async {
    var provider = Provider.of<PraticienController>(context, listen: false);
    var resp = await ApiService.getAllPraticien();
    if (resp.isSuccesful) {
      provider.setPraticienList(resp.data);
      provider.isProces(resp.isSuccesful);
    }
    return resp.data;
  }

  void beginConsult() async {
    await getAllDemandes();
    final demandeController =
        Provider.of<UserDemandeDemandeController>(context, listen: false);
    final currentDemande = demandeController.listUserDemandes
        .where((element) => element.idDemande == widget.idDemande)
        .toList();
    print(currentDemande.first.emailUtilisateur);
    print(currentDemande.first.emailPraticien);
    Get.off(
      () => ChatScreen(
        "${currentDemande.first.emailUtilisateur}",
        "${currentDemande.first.emailPraticien}",
        widget.idDemande,
      ),
    );
  }

  @override
  void initState() {
    demandeID = widget.idDemande;
    getAllDemandes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final demandeController =
        Provider.of<UserDemandeDemandeController>(context);
    final currentDemande = demandeController.listUserDemandes
        .where((element) => element.idDemande == widget.idDemande)
        .toList();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   elevation: 0.0,
        // ),
        backgroundColor: Colors.white,
        body: StreamBuilder<String>(
          stream: demandStatusStream,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.active) {
                demandeStatus = snapshot.data!;
                if (demandeStatus != null) print(demandeStatus);
                return Scaffold(
                  // backgroundColor: Colors.black.withAlpha(5),
                  body: SafeArea(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Demande validée",
                                    ),
                                    if (demandeID != null)
                                      Text(
                                        "n° " + demandeID!,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                      ),
                                  ],
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              ],
                            ),
                          ),
                          if (demandeStatus == "WAIT")
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                spinkit,
                                SizedBox(height: 5),
                                Text(
                                  'Veuillez patienter, nous vous mettons en relation avec un médecin',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                                // SizedBox(
                                //   height: 80,
                                // ),
                                // Text(
                                //   'En fermant cette page vous pouvez à tout moment ré',
                                // ),
                              ],
                            ),
                          if (demandeStatus != "WAIT")
                            Container(
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: beginConsult,
                                  child: Text("Commencer"),
                                ),
                              ),
                            ),
                          SafeArea(
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.shield_lefthalf_fill,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    'En fermant cette page vous serez notifié une fois la mis en rélation effectuée !',
                                    style: TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      spinkit,
                      Text('Traitement en cours...', style:
                            GoogleFonts.montserrat(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                );
              }
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  spinkit,
                  Text('Demande en cours...',
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
