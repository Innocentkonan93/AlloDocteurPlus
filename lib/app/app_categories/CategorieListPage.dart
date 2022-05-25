import 'package:google_fonts/google_fonts.dart';

import '../../data/models/Departement.dart';
import 'package:flutter/cupertino.dart';

import 'CategorieDetailsScreen.dart';
import '../../data/controllers/DepartementController.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:provider/provider.dart';

class CategorieListPage extends StatefulWidget {
  const CategorieListPage({Key? key}) : super(key: key);

  @override
  _CategorieListPageState createState() => _CategorieListPageState();
}

class _CategorieListPageState extends State<CategorieListPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final departementProvider = Provider.of<DepartementController>(context);
    final List<Departement> departementList =
        departementProvider.listDepartements;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          'Nos spécialités',
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            letterSpacing: -1,
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Scrollbar(
        radius: Radius.circular(10),
        // thumbVisibility: true,
        thickness: CupertinoScrollbar.defaultThickness,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: departementList.length,
          itemBuilder: (context, index) {
            departementList.sort((a, b) =>
                a.departementService!.compareTo(b.departementService!));
            final departement = departementList[index];
            // var departImg;
            // switch (index) {
            //   case 0:
            //     departImg = "medgen.png";
            //     break;
            //   case 1:
            //     departImg = "gyneco.png";
            //     break;
            //   case 2:
            //     departImg = "pharma.png";
            //     break;
            //   case 3:
            //     departImg = "urgence.png";
            //     break;
            //   default:
            // }
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CategoriesDetailsScreen(
                        "${departement.departementService}"),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(400),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.14),
                        offset: Offset(2, 2),
                        blurRadius: 2)
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: Image.network(
                        "http://allodocteurplus.com/images/departement_service/${departement.departementImage}",
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator.adaptive(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),

                      // Image.asset(
                      //       'assets/images/$departImg'),
                      // ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${departement.departementService}'
                          .capitalizeFirst
                          .toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
