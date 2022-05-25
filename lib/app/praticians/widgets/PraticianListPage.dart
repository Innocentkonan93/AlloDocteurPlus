import 'package:google_fonts/google_fonts.dart';

import '../screens/details/PraticianDetailsScreen.dart';
import '../../../data/controllers/PraticienController.dart';
import '../../../data/controllers/PraticienCurriculum.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PraticianListPage extends StatefulWidget {
  const PraticianListPage({Key? key}) : super(key: key);

  @override
  _PraticianListPageState createState() => _PraticianListPageState();
}

class _PraticianListPageState extends State<PraticianListPage> {
  bool isGrid = true;

  Iterable<TimeOfDay> getTimes(
      TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }

  @override
  Widget build(BuildContext context) {
    final startTime = TimeOfDay(hour: 9, minute: 0);
    final endTime = TimeOfDay(hour: 12, minute: 0);
    final step = Duration(minutes: 30);

    final times = getTimes(startTime, endTime, step)
        .map((tod) => tod.format(context))
        .toList();

    print(times.length);

    final size = MediaQuery.of(context).size;
    final praticienController = Provider.of<PraticienController>(context);
    final praticienList = praticienController.listPraticiens
        .where((praticien) => praticien.verifProf == 'oui')
        .toList();

    final praticienCurriculumContrllr =
        Provider.of<PraticienCurriculum>(context);
    final praticienCurriculumList = praticienCurriculumContrllr.listCurriculums;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          'Nos praticiens',
          style: GoogleFonts.nunito(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              letterSpacing: -1,
              color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     setState(() {
          //       isGrid = !isGrid;
          //     });
          //   },
          //   icon: isGrid
          //       ? Icon(Icons.calendar_view_day_rounded)
          //       : Icon(Icons.border_all_rounded),
          //   color: Colors.blue,
          // )
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isGrid ? 2 : 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: isGrid ? 1 : 2),
        itemCount: praticienList.length,
        itemBuilder: (context, index) {
          // sort by pratician Specialty
          praticienList.sort(
            (praticianA, praticianB) => (praticianA.specialitePraticien)!
                .compareTo(praticianB.specialitePraticien!),
          );
          final praticien = praticienList[index];

          final curriculum = praticienCurriculumList
              .where((curriculum) =>
                  curriculum.idPraticien == praticien.idPraticien)
              .toList();

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PraticianDetailsScreen(
                    praticien.idPraticien.toString(),
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(10),
              width: size.width / 2.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.14),
                    offset: Offset(2, -2),
                    blurRadius: 20,
                  )
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Expanded(
                          flex: isGrid ? 3 : 1,
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black38.withAlpha(14),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: praticien.imagePraticien == null
                                ? Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.userMd,
                                      color: Colors.black.withAlpha(70),
                                      size: 45,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      "https://allodocteurplus.com/api/${praticien.imagePraticien}",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (!isGrid)
                                      Text(praticien.online == 'online'
                                          ? 'disponible'
                                          : 'indisponible'),
                                    if (!isGrid) SizedBox(width: 5),
                                    FaIcon(
                                      FontAwesomeIcons.solidCircle,
                                      size: 12,
                                      color: praticien.online == 'online'
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                                  ],
                                ),
                                if (!isGrid)
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                      width: double.infinity,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            praticienCurriculumList.length,
                                        itemBuilder: (context, index) {
                                          final curriculum =
                                              praticienCurriculumList[index];
                                          return
                                              // ListTile(
                                              //   leading: Icon(Icons.circle, size: 9,),
                                              //   title: Text("${curriculum.formation}"),

                                              // );
                                              Row(
                                            children: [
                                              Icon(
                                                Icons.circle,
                                                size: 9,
                                              ),
                                              SizedBox(width: 8),
                                              Flexible(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${curriculum.formation}',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 3),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '${curriculum.lieuDiplome}',
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          '${curriculum.dateDiplome}',
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      height: 2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                'Dr. ${praticien.nomPraticien}',
                                overflow: TextOverflow.clip,
                                style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${praticien.specialitePraticien}',
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.w500,
                                color: Color(0XFF59BCC4),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
