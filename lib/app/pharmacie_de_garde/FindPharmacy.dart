import 'dart:async';

import 'package:app_allo_docteur_plus/app/pharmacie_de_garde/pharmacy_option.dart';
import 'package:app_allo_docteur_plus/app/utils/location_picker.dart';
import 'package:app_allo_docteur_plus/data/controllers/PharmaciesController.dart';
import 'package:app_allo_docteur_plus/data/models/Pharmacies.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../data/credentials/APIsKey.dart';
import '../../data/services/ApiService.dart';
import '../utils/widgets/GlassMorphism.dart';

class FindPharmacy extends StatefulWidget {
  const FindPharmacy({Key? key}) : super(key: key);

  @override
  State<FindPharmacy> createState() => _FindPharmacyState();
}

class _FindPharmacyState extends State<FindPharmacy> {
  Completer<GoogleMapController> _controller = Completer();
  DraggableScrollableController controller = DraggableScrollableController();
  BitmapDescriptor? mapMarker;
  double heigth = 0.0;
  List<Pharmacie> pharmas = [];
  Position? userPosition;
  String? actualUserAdress;

  double minSheetSize = 0.1;
  double maxSheetSize = 0.85;
  double initSheetSize = 0.3;

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller.complete(_cntlr);

    Future.delayed(const Duration(seconds: 3), () {
      _cntlr.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(userPosition!.latitude, userPosition!.longitude),
            // bearing: 2,
            zoom: 10,
          ),
        ),
      );
    });
  }

  Future<BitmapDescriptor> setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), "assets/images/BitMap.png");
    return mapMarker!;
  }

  Future<void> _goToTheCurrentPharmacie(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 13,
        ),
      ),
    );
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
    actualUserAdress = response.data["results"][0]["formatted_address"];
    print(actualUserAdress);
    return actualUserAdress!;
  }

  Future<List> getAllPharmacies() async {
    var provider = Provider.of<PharmacieController>(context, listen: false);
    var resp = await ApiService.getAllPharmacies();
    if (resp.isSuccesful) {
      provider.setPharmacieList(resp.data);

      provider.isProces(resp.isSuccesful);
    }
    return resp.data;
  }

  @override
  void initState() {
    getAdressFromCoordinate();
    setCustomMarker();
    getAllPharmacies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pharmacieController = Provider.of<PharmacieController>(context);
    final pharmcieList = pharmacieController.listPharmacies;
    print(pharmcieList.length);
    print(Theme.of(context).platform);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: pharmacieController.isProcessing
          ? Scaffold(
              // appBar: AppBar(
              //   elevation: 0.0,
              //   backgroundColor: Colors.transparent,
              //   title: Text('Pharmacies'),
              //   actions: [
              //     Switch(
              //         value: false,
              //         onChanged: (val) {
              //           setState(() {});
              //         })
              //   ],
              // ),
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  if (mapMarker != null && userPosition != null)
                    GoogleMap(
                      myLocationEnabled: true,
                      mapToolbarEnabled: false,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapType: MapType.terrain,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                            userPosition!.latitude, userPosition!.longitude),
                        zoom: 5,
                      ),
                      onMapCreated: _onMapCreated,
                      onTap: (latlng) {
                        print(latlng);
                      },
                      onLongPress: (latlng) {
                        print(latlng);
                      },
                      markers: mapMarker == null
                          ? {}
                          : List<Marker>.generate(
                              pharmcieList.length,
                              (index) {
                                final pharmacie = pharmcieList[index];
                                return Marker(
                                  markerId:
                                      MarkerId("${pharmacie.idPharmacie}"),
                                  position: LatLng(
                                    double.parse(pharmacie
                                        .localisationPharmacie!
                                        .split(',')
                                        .first),
                                    double.parse(pharmacie
                                        .localisationPharmacie!
                                        .split(',')
                                        .last),
                                  ),
                                  // icon: pinLocationIcon,
                                  icon: mapMarker!,
                                  infoWindow: InfoWindow(
                                      title:
                                          "Pharmacie ${pharmacie.nomPharmacie}",
                                      snippet: "${pharmacie.adressePharmacie}"),
                                  // consumeTapEvents: true,
                                  onTap: () async {},
                                );
                              },
                            ).toSet(),
                    ),
                  DraggableScrollableSheet(
                    snap: true,
                    snapSizes: [
                      minSheetSize,
                      initSheetSize,
                    ],
                    controller: controller,
                    builder: (context, scrollController) {
                      return GlassMorphism(
                        blur: 15,
                        opacity: 0.6,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  fillColor: Colors.black12,
                                  filled: true,
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.fromLTRB(12, 8, 12, 8),
                                  hintText: 'Rechercher une pharmacie',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                    gapPadding: 0.0,
                                  ),
                                ),
                                onTap: () {
                                  controller.animateTo(
                                    maxSheetSize,
                                    duration: Duration(milliseconds: 100),
                                    curve: Curves.bounceOut,
                                  );
                                },
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              for (var i = 0; i < pharmcieList.length; i++)
                                GestureDetector(
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();
                                    await controller.animateTo(
                                      initSheetSize,
                                      duration: Duration(milliseconds: 100),
                                      curve: Curves.bounceOut,
                                    );
                                    await _goToTheCurrentPharmacie(
                                      LatLng(
                                        double.parse(pharmcieList[i]
                                            .localisationPharmacie!
                                            .split(',')
                                            .first),
                                        double.parse(pharmcieList[i]
                                            .localisationPharmacie!
                                            .split(',')
                                            .last),
                                      ),
                                    );
                                    Future.delayed(
                                        const Duration(milliseconds: 600), () {
                                      showModalBottomSheet(
                                        barrierColor: Colors.transparent,
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        enableDrag: false,
                                        isDismissible: false,
                                        builder: (context) {
                                          return PharmacieOption(
                                              pharmacie: pharmcieList[i]);
                                        },
                                      );
                                    });
                                  },
                                  child: ListTile(
                                    trailing: SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: pharmcieList[i].statutPharmacie ==
                                              'de garde'
                                          ? Image.asset(
                                              "assets/images/24-hours.png")
                                          : null,
                                    ),
                                    title: Text(
                                      "Pharmacie ${pharmcieList[i].nomPharmacie!.trim()}",
                                      style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        // Color.fromARGB(255, 27, 180, 129),
                                      ),
                                    ),
                                    dense: true,
                                    subtitle: Text(
                                      "${pharmcieList[i].adressePharmacie!.trim()} - ${pharmcieList[i].paysPharmacie!.trim()}",
                                      style: GoogleFonts.nunito(),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                    minChildSize: minSheetSize,
                    maxChildSize: maxSheetSize,
                    initialChildSize: initSheetSize,
                  ),
                  Positioned(
                    top: 50,
                    left: 0,
                    right: 0,
                    child: Container(
                      child: Row(
                        children: [
                          BackButton(),
                          Spacer(),
                          Text(
                            'Garde',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Switch(
                            value: false,
                            onChanged: (val) {
                              setState(() {});
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // floatingActionButton: FloatingActionButton.extended(
              //   onPressed: _goToTheLake,
              //   label: Text('To the lake!'),
              //   icon: Icon(Icons.directions_boat),
              // ),
            )
          : Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
