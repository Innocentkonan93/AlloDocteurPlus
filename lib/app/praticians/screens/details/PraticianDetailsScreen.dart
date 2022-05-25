import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../data/controllers/PraticienController.dart';
import '../../../../data/controllers/PraticienCurriculum.dart';
import '../../../../data/controllers/ServicesTypeController.dart';
import '../../../users/screens/process/NewDemande.dart';

class PraticianDetailsScreen extends StatefulWidget {
  final String praticienID;
  const PraticianDetailsScreen(this.praticienID, {Key? key}) : super(key: key);

  @override
  _PraticianDetailsScreenState createState() => _PraticianDetailsScreenState();
}

class _PraticianDetailsScreenState extends State<PraticianDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final praticienCurriculumContrllr =
        Provider.of<PraticienCurriculum>(context);
    final praticienCurriculumList = praticienCurriculumContrllr.listCurriculums
        .where((pratician) => pratician.idPraticien == widget.praticienID)
        .toList();

    final praticianController = Provider.of<PraticienController>(context);
    final praticianList = praticianController.listPraticiens
        .where((pratician) => pratician.idPraticien == widget.praticienID)
        .toList();
    final currentPratician = praticianList.first;
    final typesDeService = Provider.of<ServicesTypeController>(context);
    final services = typesDeService.listServicesTypes;
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: Image.asset(
          'assets/images/allo-logo.png',
          height: 30,
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: Icon(Icons.more_horiz),
        //   ),
        // ],
      ),
      body: Container(
        height: size.height,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: size.height * 0.2,
                    margin: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: currentPratician.imagePraticien == null
                              ? Container(
                                  height: size.height * 0.2,
                                  width: size.height * 0.2,
                                  padding: EdgeInsets.all(15),
                                  color: Colors.black38.withAlpha(14),
                                  child: Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.userMd,
                                      color: Colors.black.withAlpha(70),
                                      size: 145,
                                    ),
                                  ),
                                )
                              : Image.network(
                                  "https://allodocteurplus.com/api/${currentPratician.imagePraticien}",
                                  fit: BoxFit.cover,
                                  height: size.height * 0.2,
                                  width: size.height * 0.2,
                                ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.solidCircle,
                                    size: 12,
                                    color: currentPratician.online == 'online'
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                  SizedBox(width: 10),
                                  if (currentPratician.online == 'online')
                                    Text(
                                      "Disponible",
                                      style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  if (currentPratician.online != 'online')
                                    Text(
                                      "Non disponible",
                                      style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Dr. ${currentPratician.nomPraticien}',
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        // overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                '${currentPratician.specialitePraticien}',
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0XFF101A69),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '${currentPratician.statutPraticien}',
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'À propos',
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Colors.black45),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.black.withAlpha(10),
                              ),
                              child: praticienCurriculumList.isEmpty
                                  ? Center(
                                      child: Text(
                                        'Aucune information',
                                        style: GoogleFonts.nunito(),
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: praticienCurriculumList.length,
                                      itemBuilder: (context, index) {
                                        final curriculum =
                                            praticienCurriculumList[index];
                                        return Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              size: 5,
                                              color: Colors.blue[900],
                                            ),
                                            SizedBox(width: 8),
                                            Flexible(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${curriculum.formation}',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400),
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
                                                            color: Colors.grey),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        '${curriculum.dateDiplome}',
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.grey),
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
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Divider(
            //   height: 1,
            // ),
            Container(
              height: size.height * 0.17,
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              width: double.infinity,
              // color: Colors.black.withAlpha(12),
              child: Align(
                alignment: Alignment.center,
                child: ListView.builder(
                  itemCount: services.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    final service = services[i];
                    var color;
                    if (i == 0) color = Colors.cyan;
                    if (i == 1) color = Colors.orange.shade400;
                    if (i == 2) color = Colors.brown.shade200;
                    return GestureDetector(
                      onTap: () {
                        Get.to(
                          () => NewDemandes(
                            serviceType: service.nomService,
                            departementService:
                                currentPratician.specialitePraticien,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              height: size.width * 0.17,
                              width: size.width * 0.17,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: i == 0
                                    ? FaIcon(
                                        FontAwesomeIcons.stethoscope,
                                        size: 40,
                                        color: Colors.white,
                                      )
                                    : i == 1
                                        ? Icon(
                                            CupertinoIcons.doc_append,
                                            size: 50,
                                            color: Colors.white,
                                          )
                                        : Icon(
                                            CupertinoIcons.info_circle_fill,
                                            size: 50,
                                            color: Colors.white,
                                          ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '${service.nomService!.split(" ").first}',
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),

                //  Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                // Column(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     CircleAvatar(
                //       radius: 50,
                //       backgroundColor: Colors.deepOrangeAccent,
                //       child: Icon(
                //         Icons.info_outline_rounded,
                //         color: Colors.white,
                //         size: 40,
                //       ),
                //     ),
                //     SizedBox(height: 20),
                //     Text('S\'informer')
                //   ],
                // ),
                //     Column(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         CircleAvatar(
                //           radius: 50,
                //           backgroundColor: Colors.cyan,
                //           child: Icon(
                //             Icons.task,
                //             color: Colors.white,
                //             size: 40,
                //           ),
                //         ),
                //         SizedBox(height: 20),
                //         Text('Interpreter')
                //       ],
                //     ),
                //     Column(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         CircleAvatar(
                //           radius: 50,
                //           backgroundColor: Color(0XFF101A69),
                //           child: FaIcon(
                //             FontAwesomeIcons.stethoscope,
                //             size: 40,
                //             color: Colors.white,
                //           ),
                //         ),
                //         SizedBox(height: 20),
                //         Text('Consulter')
                //       ],
                //     ),
                //   ],
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
