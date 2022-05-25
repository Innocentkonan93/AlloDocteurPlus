import 'package:app_allo_docteur_plus/app/pharmacie_de_garde/pharmacies_list.dart';
import 'package:app_allo_docteur_plus/data/controllers/ProgrammeController.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../data/controllers/PharmaciesController.dart';
import '../../data/credentials/APIsKey.dart';
import '../../data/models/Pharmacies.dart';
import '../../data/services/ApiService.dart';
import '../utils/location_picker.dart';

class PharmacieScreen extends StatefulWidget {
  const PharmacieScreen({Key? key}) : super(key: key);

  @override
  State<PharmacieScreen> createState() => _PharmacieScreenState();
}

class _PharmacieScreenState extends State<PharmacieScreen> {
  Position? userPosition;
  String? actualUserAdress;
  List<Pharmacie> suggestionList = [];
  final searchController = TextEditingController();

  Future<List> getAllPharmacies() async {
    var provider = Provider.of<PharmacieController>(context, listen: false);
    var resp = await ApiService.getAllPharmacies();
    if (resp.isSuccesful) {
      provider.setPharmacieList(resp.data);

      provider.isProces(resp.isSuccesful);
    }
    return resp.data;
  }

  Future<List> getAllProgrammes() async {
    var provider = Provider.of<ProgrammeController>(context, listen: false);
    var resp = await ApiService.getAllProgrammes();
    if (resp.isSuccesful) {
      provider.setProgrammeList(resp.data);

      provider.isProces(resp.isSuccesful);
    }
    return resp.data;
  }

  Future<LatLng> getUserPosition() async {
    userPosition = await CustomLocationPicker().determinePosition();
    return LatLng(userPosition!.latitude, userPosition!.longitude);
  }

  Future<String> getAdressFromCoordinate() async {
    LatLng position = await getUserPosition();
    String baseUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$GOOGLEMAP";
    var response = await Dio().get(baseUrl);
    setState(() {
      actualUserAdress = response.data["results"][0]["formatted_address"];
    });
    print(actualUserAdress);
    return actualUserAdress!;
  }

  void onChanged(String query){

  }

  @override
  void initState() {
    getAdressFromCoordinate();
    getAllPharmacies();
    getAllProgrammes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final String userContry = actualUserAdress!.split(',').last;
    final pharmacieController = Provider.of<PharmacieController>(context);
    final pharmacieList = pharmacieController.listPharmacies;
    // .where((pharmacie) => pharmacie.paysPharmacie!.contains(userContry))
    // .toList();
    // print(userContry);

    final programmeController = Provider.of<ProgrammeController>(context);
  
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Color(0XFFF2F2F2),
        appBar: AppBar(
          title: Text(
            'Près de chez vous',
            style: GoogleFonts.montserrat(
              color: Colors.black,
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: pharmacieController.isProcessing &&
                programmeController.isProcessing &&
                actualUserAdress != null
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 8,
                ),
                child: Scrollbar(
                  radius: Radius.circular(100),
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.map_pin,
                                size: 18,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                actualUserAdress!.split(',').last,
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 5),
                              // Icon(
                              //   CupertinoIcons.chevron_down,
                              //   size: 19,
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.search,
                                color: Colors.grey,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: 'une pharmacie, une ville...',
                                    hintStyle: GoogleFonts.nunito(
                                      fontSize: 12,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(5, 10, 0, 10),
                                  ),
                                  onChanged: (String? val) {
                                    print(val!);
                                    setState(() {
                                      suggestionList = pharmacieList
                                          .where((pharmacie) => pharmacie
                                              .adressePharmacie!
                                              .toLowerCase()
                                              .contains(val.toLowerCase()))
                                          .toList();
                                    });
                                    if (suggestionList.isEmpty) {
                                      setState(() {
                                        suggestionList = pharmacieList
                                            .where(
                                              (pharmacie) => pharmacie
                                                  .nomPharmacie!
                                                  .toLowerCase()
                                                  .contains(val.toLowerCase()),
                                            )
                                            .toList();
                                      });
                                      if (suggestionList.isEmpty) {
                                        setState(() {
                                          suggestionList = pharmacieList
                                              .where((pharmacie) => pharmacie
                                                  .villePharmacie!
                                                  .toLowerCase()
                                                  .contains(val.toLowerCase()))
                                              .toList();
                                        });
                                      }

                                      if (suggestionList.isEmpty) {
                                        setState(() {
                                          suggestionList = pharmacieList
                                              .where((pharmacie) => pharmacie
                                                  .quartierPharmacie!
                                                  .toLowerCase()
                                                  .contains(val.toLowerCase()))
                                              .toList();
                                        });
                                      }
                                    }
                                    print(suggestionList);
                                  },
                                ),
                              ),
                              if (searchController.text != '')
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      searchController.text = '';
                                    });
                                  },
                                  child: Icon(
                                    CupertinoIcons.clear_circled_solid,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // for (var i = 0; i < pharmacieList.length; i++)
                        PharmaciesList(
                          pharmacies: searchController.text.isEmpty
                              ? pharmacieList
                              : suggestionList,
                          userAdress: actualUserAdress!,
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator.adaptive(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Chargement ....'),
                ],
              )),
      ),
    );
  }
}
