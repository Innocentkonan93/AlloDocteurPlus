import 'package:google_fonts/google_fonts.dart';


import '../../widgets/PraticianAcitviteCard.dart';
import '../../../../data/controllers/PraticienController.dart';
import '../../../../data/controllers/PraticiensAcitivitesController.dart';
import '../../../../data/services/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PraticianActivites extends StatefulWidget {
  const PraticianActivites({Key? key}) : super(key: key);

  @override
  _PraticianActivitesState createState() => _PraticianActivitesState();
}

class _PraticianActivitesState extends State<PraticianActivites> {
  Future<List> getAllActivitesPraticiens() async {
    var provider =
        Provider.of<PraticiensActivitesController>(context, listen: false);
    var resp = await ApiService.getAllActivitesPraticiens();
    if (resp.isSuccesful) {
      provider.setActivitesPraticiensList(resp.data);

      provider.isProces(resp.isSuccesful);
    }
    return resp.data;
  }

  @override
  void initState() {
    getAllActivitesPraticiens();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final praticienController = Provider.of<PraticienController>(context);
    final praticienlist = praticienController.listPraticiens;
    final currentPraticien = praticienlist.first;
    final praticienActivitesConteoller =
        Provider.of<PraticiensActivitesController>(context);
    final currentPraticienActivitesList =
        praticienActivitesConteoller.listActivitesPraticiens
            .where(
              (element) =>
                  element.emailPraticien == currentPraticien.emailPraticien,
            )
            .toList();

    final praticienActivitesList =
        praticienActivitesConteoller.listActivitesPraticiens;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          title: Text(
            'Prescriptions',
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              letterSpacing: -1,
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: null,
              child: Text(
                "${praticienActivitesList.length}",
              ),
            )
          ],
          // backgroundColor: Color(0XFF101A69),
          backgroundColor: Colors.white,
          elevation: 0.0,

          centerTitle: true,
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: TabBar(
                  automaticIndicatorColorAdjustment: true,
                  indicatorWeight: 1,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Color(0XFF101A69),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.userNurse,
                            color: Color(0XFF101A69),
                            size: 18,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Moi',
                            style: GoogleFonts.montserrat(
                              color: Color(0XFF101A69),
                            ),
                          )
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.users,
                            color: Color(0XFF101A69),
                            size: 18,
                          ),
                          Text(
                            'Tous les praticiens',
                            style: GoogleFonts.montserrat(
                              color: Color(0XFF101A69),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: !praticienActivitesConteoller.isProcessing
                    ? Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : TabBarView(
                        children: [
                          // first list
                          Container(
                            child: Scrollbar(
                              thickness: 3,
                              radius: Radius.circular(10),
                              child: currentPraticienActivitesList.isEmpty
                                  ? Center(
                                      child: Text(
                                        'Aucune prescription',
                                        style: GoogleFonts.montserrat(
                                          color: Color(0XFF101A69),
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount:
                                          currentPraticienActivitesList.length,
                                      itemBuilder: (context, index) {
                                        final currentPraticienActivites =
                                            currentPraticienActivitesList[
                                                index];
                                        return PraticianActivitsCard(
                                          currentPraticienActivites,
                                        );
                                      },
                                    ),
                            ),
                          ),
                          // second list
                          Container(
                            child: Scrollbar(
                              thickness: 3,
                              radius: Radius.circular(10),
                              child: praticienActivitesList.isEmpty
                                  ? Center(
                                      child: Text(
                                        'Aucune prescription',
                                        style: GoogleFonts.montserrat(
                                          color: Color(0XFF101A69),
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: praticienActivitesList.length,
                                      itemBuilder: (context, index) {
                                        final praticienActivites =
                                            praticienActivitesList[index];
                                        return PraticianActivitsCard(
                                          praticienActivites,
                                        );
                                      },
                                    ),
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
  }
}
