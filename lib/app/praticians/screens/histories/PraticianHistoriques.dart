import '../../../../data/controllers/UserActivitesController.dart';
import '../../../../data/services/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PraticianHistoriques extends StatefulWidget {
  const PraticianHistoriques({Key? key}) : super(key: key);

  @override
  _PraticianHistoriquesState createState() => _PraticianHistoriquesState();
}

class _PraticianHistoriquesState extends State<PraticianHistoriques> {
  String? currentPraticienEmail;
  void getCurrentUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentPraticienEmail = prefs.getString('praticianEmail');
    });
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
        .where((activites) => activites.acteurActivite == currentPraticienEmail)
        .toList();
    return Scaffold(
      appBar: AppBar(
           backgroundColor: Color(0XFF101A69),
        title: Text('Historiques'),
        centerTitle: true,
      ),
      body: Container(
        height: size.height,
        child: RefreshIndicator(
          onRefresh: () {
            return ApiService.getAllActivites();
          },
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
      ),
    );
  }
}
