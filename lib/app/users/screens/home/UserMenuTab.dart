import 'package:google_fonts/google_fonts.dart';

import '../../../utils/widgets/UserTabNavigator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserMenuTab extends StatefulWidget {
  const UserMenuTab({Key? key}) : super(key: key);

  @override
  _UserMenuTabState createState() => _UserMenuTabState();
}

class _UserMenuTabState extends State<UserMenuTab> {
  int? currentIndex;
  String? currentPage;
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

  void _selectTab(String tabItem, int index) {
    if (tabItem == currentPage) {
      navigationKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        currentPage = pageKeys[index];
        currentIndex = index;
      });
    }
  }

  final _items = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      // backgroundColor: Colors.black12,
      icon: Icon(Icons.home_filled, size: 19,),
      label: "Accueil",
    ),
    BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.briefcaseMedical, size: 16,),
      label: "Outils",
    ),
    BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.bookMedical, size: 16,),
      label: "Consultations", 
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person, size: 19,),
      label: "Compte",

    )
  ];

  @override
  void initState() {
    currentIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        // key: scaffoldKey,
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
          backgroundColor: Colors.white,
          showUnselectedLabels: true,
          // unselectedFontSize: 0.0,
          unselectedItemColor: Colors.black26,
          selectedItemColor: Colors.blue,
          items: _items,
          currentIndex: currentIndex!,
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            // _selectTab(pageKeys[index], index);
            setState(() {
              currentPage = pageKeys[index];
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  Widget _buildOffsetNavigator(String tabItem) {
    return UserTabNavigator(
      navigatorKey: navigationKeys[tabItem]!,
      tabItem: tabItem,
      key: navigationKeys[tabItem],
    );
  }
}
