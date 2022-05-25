import 'package:flutter/material.dart';

import '../../praticians/screens/DemandesScreenWidegt.dart';
import '../../praticians/screens/NotificationScreenWidget.dart';
import '../../praticians/screens/PCompteScreenWidget.dart';
import '../../praticians/screens/PHomeScreenWidget.dart';

class PraticianTabNavigator extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;

  const PraticianTabNavigator(
      {Key? key, required this.navigatorKey, required this.tabItem})
      : super(key: key);

  @override
  State<PraticianTabNavigator> createState() => _PraticianTabNavigatorState();
}

class _PraticianTabNavigatorState extends State<PraticianTabNavigator> {
  @override
  Widget build(BuildContext context) {
    Widget child = Scaffold();

    if (widget.tabItem == "Page1") {
      setState(() {
        child = PHomeScreenWidget();
      });
    } else if (widget.tabItem == "Page2") {
      setState(() {
        child = DemandesScreenWidget();
      });
    } else if (widget.tabItem == "Page3") {
      setState(() {
        child = NotificationScreenWidget();
      });
    } else if (widget.tabItem == "Page4") {
      setState(() {
        child = PCompteScreenWidget();
      });
    }

    // return Container(
    //   child: child,
    // );
    return Navigator(
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => child,
          settings: routeSettings,
        );
      },
    );
  }
}
