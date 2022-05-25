import 'package:flutter/material.dart';

import '../../users/screens/ConsultationScreenWidget.dart';
import '../../users/screens/HomeMenuWidget.dart';
import '../../users/screens/HomeScreenWidget.dart';
import '../../users/screens/CompteScreenWidget.dart';

class UserTabNavigator extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;

  const UserTabNavigator(
      {Key? key, required this.navigatorKey, required this.tabItem})
      : super(key: key);

  @override
  _UserTabNavigatorState createState() => _UserTabNavigatorState();
}

class _UserTabNavigatorState extends State<UserTabNavigator> {
  @override
  Widget build(BuildContext context) {
    Widget? child;

    if (widget.tabItem == "Page1" || widget.tabItem.isEmpty)
      setState(() {
        child = HomeMenuWidget();
      });
    else if (widget.tabItem == "Page2")
      setState(() {
        child = HomeScreenWidget();
      });
    else if (widget.tabItem == "Page3")
      setState(() {
        child = ConsultationScreenWidget();
      });
    else if (widget.tabItem == "Page4")
      setState(() {
        child = CompteScreenWidget();
      });

    // return Container(
    //   child: child,
    // );
    return Navigator(
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => child!,
          settings: routeSettings,
        );
      },
    );
  }
}
