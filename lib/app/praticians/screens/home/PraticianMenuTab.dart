import 'package:google_fonts/google_fonts.dart';

import '../../../utils/widgets/PraticianTabNavigator.dart';
import '../../../../data/controllers/PraticienController.dart';
import '../../../../data/controllers/UserDemandeController.dart';
import '../../../../data/services/ApiService.dart';
import '../../../../data/services/FirestoreService.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PraticianTabMenu extends StatefulWidget {
  const PraticianTabMenu({Key? key}) : super(key: key);

  @override
  _PraticianTabMenuState createState() => _PraticianTabMenuState();
}

class _PraticianTabMenuState extends State<PraticianTabMenu> {
  FirestoreService firestoreService = FirestoreService();
  int currentIndex = 0;
  String currentPage = "Page1";
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> pageKeys = [
    "Page1",
    "Page2",
    "Page3",
    "Page4",
  ];

  Map<String, GlobalKey<NavigatorState>> navigationKeys = {
    "Page1": GlobalKey<NavigatorState>(),
    "Page2": GlobalKey<NavigatorState>(),
    "Page3": GlobalKey<NavigatorState>(),
    "Page4": GlobalKey<NavigatorState>(),
  };
   Future<List> getAllDemande() async {
    var provider =
        Provider.of<UserDemandeDemandeController>(context, listen: false);
    var resp = await ApiService.getAllDemandes();
    if (resp.isSuccesful) {
      provider.setUserDemandeList(resp.data);

      provider.isProces(resp.isSuccesful);
    }
    return resp.data;
  }

  void _selectTab(String tabItem, int index) {
    // if (tabItem == currentPage) {
    //   navigationKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    // } else {
    //   setState(() {
    //     currentPage = pageKeys[index];
    //     currentIndex = index;
    //   });
    // }
    setState(() {
      currentPage = pageKeys[index];
      currentIndex = index;
    });
    getAllDemande();
  }

  Future<String> getPraticianDepartement() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String departement =
        prefs.getString('praticianDepartement').toString();
    return departement;
  }


 

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<PraticienController>(context);
    final currentUser = userController.listPraticiens.first;
    final demandeController =
        Provider.of<UserDemandeDemandeController>(context);
    // final demandeList = demandeController.listUserDemandes
    //     .where((element) =>
    //         element.departementService == currentUser.specialitePraticien)
    //     .where((element) => element.statusDemande == "WAIT")
    //     .toList();
final demandeList = demandeController.listUserDemandes
        .where((element) => element.statusDemande == "WAIT")
        .toList();
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await navigationKeys[currentPage]!.currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          print(isFirstRouteInCurrentTab);
          if (currentPage != "Page1") {
            _selectTab("Page1", 1);
            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        key: scaffoldKey,
        body: IndexedStack(
          index: currentIndex,
          children: [
            _buildOffsetNavigator("Page1"),
            _buildOffsetNavigator("Page2"),
            _buildOffsetNavigator("Page3"),
            _buildOffsetNavigator("Page4"),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedLabelStyle: GoogleFonts.nunito(
            fontSize: 12,
          ),
          unselectedLabelStyle: GoogleFonts.nunito(),
          selectedItemColor: Color(0XFF101A69),
          backgroundColor: Colors.white,
          showUnselectedLabels: true,
          // unselectedFontSize: 0.0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              // backgroundColor: Colors.black12,
              icon: Icon(Icons.home_filled, size: 19),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
              icon: demandeList.length != 0
                  ? Badge(
                      child: FaIcon(FontAwesomeIcons.listUl),
                      elevation: 1,
                       position: BadgePosition.topEnd(top: -1, end: -10),
                      badgeContent: Container(
                        height: 1,
                        width: 1,
                        // decoration:
                        //     BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                      ),
                    )
                  : FaIcon(FontAwesomeIcons.listUl, size: 16),
              label: "Demandes",
            ),
            BottomNavigationBarItem(
              // icon: FaIcon(FontAwesomeIcons.bell),
              icon: StreamBuilder<QuerySnapshot>(
                  stream: firestoreService
                      .getPraticianNotif(currentUser.emailPraticien!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Icon(Icons.notifications_rounded);
                    } else {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      }
                      final notifs = snapshot.data!.docs;
                      FlutterAppBadger.updateBadgeCount(notifs.length);
                      return Badge(
                        position: BadgePosition.topEnd(top: -1, end: -10),
                        animationDuration: Duration(milliseconds: 300),
                        // animationType: BadgeAnimationType.slide,
                        toAnimate: false,
                        padding: EdgeInsets.all(5),
                        badgeContent: Text(
                          notifs.length.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: FaIcon(FontAwesomeIcons.bell, size: 19),
                      );
                    }
                  }),
              label: "Notifications",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_sharp, size: 19),
              label: "Compte",
            )
          ],
          unselectedItemColor: Colors.black26,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            _selectTab(pageKeys[index], index);
          },
        ),
      ),
    );
  }

  Widget _buildOffsetNavigator(String tabItem) {
    return PraticianTabNavigator(
      navigatorKey: navigationKeys["$tabItem"]!,
      tabItem: tabItem,
    );
  }
}
