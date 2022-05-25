import '../../../../data/controllers/UserActivitesController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHistoriques extends StatefulWidget {
  const UserHistoriques({Key? key}) : super(key: key);

  @override
  _UserHistoriquesState createState() => _UserHistoriquesState();
}

class _UserHistoriquesState extends State<UserHistoriques> {
  String? currentUserEmail;
  void getCurrentUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserEmail = prefs.getString('userEmail');
    });
    print("currentUserEmail  : $currentUserEmail");
  }

  @override
  void initState() {
    getCurrentUserEmail();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
 final size = MediaQuery.of(context).size;
    final userActivitesController =
        Provider.of<UserActivitesController>(context);
    final userUserActivites = userActivitesController.listUserActivites
        .where((activites) => activites.acteurActivite == currentUserEmail)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Historiques',
          style: Theme.of(context).textTheme.headline6,
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,

        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Container(
        height: size.height,
        child: ListView.builder(
          itemCount: userUserActivites.length,
          itemBuilder: (context, i) {
            final activites = userUserActivites[i];
            return Column(
                children: [
                Divider(
                  height: 0.1,
                ),
                ListTile(
                    title: Text("${activites.activite}"),
                  subtitle: Text("${activites.dateActivite}"),
                  // trailing: Text(
                  //   '${activites.dateActivite}',
                  //   style: TextStyle(color: Colors.grey),
                  // ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
