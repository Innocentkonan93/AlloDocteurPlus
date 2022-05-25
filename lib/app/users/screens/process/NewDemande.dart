import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'PayementScreen.dart';
import 'UserWaiting.dart';
import '../../../../data/controllers/DepartementController.dart';
import '../../../../data/controllers/ServicesController.dart';
import '../../../../data/controllers/UsersController.dart';
import '../../../../data/services/ApiService.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewDemandes extends StatefulWidget {
  final String? serviceType;
  final String? departementService;
  final String? userEmail;
  const NewDemandes(
      {this.serviceType, this.departementService, this.userEmail, Key? key})
      : super(key: key);

  @override
  _NewDemandesState createState() => _NewDemandesState();
}

class _NewDemandesState extends State<NewDemandes> {
  // String? description;
  TextEditingController descriptionController = TextEditingController();
  PageController _pageController = PageController();
  ApiService apiService = ApiService();
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String? selectedDepartment;
  String description = "";
  String? servicePrice;
  String? userID;
  String? userEmail;
  String? demandeID;
  String? fileExtension;
  String? userDossier;
  File? file;
  bool isSelected = false;

  List<String> casNonTraites = [
    "Prescription de substances ou médicaments poscrits",
    "Consultation physique des patients",
    "Hospitalisation des patients",
    "Examens médicaux",
    "Opérations",
  ];

  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.blue : Colors.green,
        ),
      );
    },
  );

  Future<void> getUserPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userPrefID = prefs.getString('userID').toString();
    final userPrefEmail = prefs.getString('userEmail').toString();
    userDossier = prefs.getString('userDossier').toString();
    setState(() {
      userID = userPrefID;
      userEmail = userPrefEmail;
    });
  }

  Future<void> addNotif(String departement, String idDemande) async {
    _db.collection("notifications/yBlfDOUJ9hair4CP2aC4/demandes").add(
      {
        "title": "Nouvelle demande",
        "body": "Une nouvelle demande fait face !",
        "notif_date": Timestamp.now(),
        "demande_departement": departement,
        "channel": idDemande,
        "isView": false,
      },
    );
  }

  Future<void> selectDepartment(dynamic departement) async {
    setState(() {
      selectedDepartment = departement;
    });
    print(selectedDepartment);
  }

  Future<void> selectFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
    );

    if (result != null) {
      final filesPaths = result.files.single.path;
      setState(() {
        file = File(filesPaths!);
        fileExtension = (file!.path.split('.').last);
      });
      print(file!.path.split('/').last);
      print(fileExtension);
    }
  }

  void saveDepartementSelected() async {
    await _pageController.nextPage(
      duration: Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
  }

  void saveDescription(String val) async {
    setState(() {
      description = val;
    });
  }

  showFile(BuildContext context, String filePath) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            iconTheme: IconThemeData(color: Colors.black),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close),
            ),
          ),
          body: fileExtension == "pdf"
              ? PDFView(
                  filePath: filePath,
                )
              : Container(
                  width: double.infinity,
                  child: Center(
                    child: Image.file(file!),
                  ),
                ),
        ),
      ),
    );
  }

  String getCost(BuildContext context) {
    final departementSev = selectedDepartment != null
        ? selectedDepartment
        : this.widget.departementService;
    final serviceController =
        Provider.of<ServicesController>(context, listen: false);
    final servicesList = serviceController.listServicess;
    final finalServiceSelected = servicesList
        .where((element) => element.departementService == departementSev)
        .where((element) => element.nomService == widget.serviceType)
        .toList();
    final demande = finalServiceSelected.first;

    final demandeCost = demande.prixService.toString();

    print(demandeCost);

    return demandeCost;
  }

  @override
  void initState() {
    getUserPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final serviceType = this.widget.serviceType;
    final departService = widget.departementService;
    final departController = Provider.of<DepartementController>(context);
    final listDepartement = departController.listDepartements;

    final userController = Provider.of<UsersController>(context);
    // ignore: unused_local_variable
    final currentUserList = userController.listUsers
        .where((element) => element.idUtilisateur == userID)
        .toList();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Nouvelle demande',
            style: GoogleFonts.nunito(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                size: 17,
              )),
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            if (widget.departementService == null)

              // departement
              Scaffold(
                backgroundColor: Colors.white,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Le département ?',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black38,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listDepartement.length,
                      itemBuilder: (context, index) {
                        final departement = listDepartement[index];
                        return customButton(
                          size,
                          "${departement.departementService}",
                          () async {
                            await selectDepartment(
                              departement.departementService,
                            );

                            saveDepartementSelected();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

            // description
            if (serviceType != "Interpretation d'examen" ||
                widget.serviceType != "Interpretation d'examen")
              Scaffold(
                backgroundColor: Colors.white,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.serviceType != "Informations"
                              ? 'Motif de la demande !'
                              : 'Quelle est votre préoccupation ?',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black38,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Container(
                      padding: EdgeInsets.all(30),
                      child: Form(
                        key: _formKey,
                        child: TextField(
                          // onChanged: (val) {
                          //   setState(() {
                          //     description = val;
                          //   });
                          // },
                          onChanged: (value) {
                            saveDescription(value);
                          },
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 19,
                          ),

                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            fillColor: Colors.blue.withOpacity(0.12),
                            // fillColor: Color(0XFF52A0C1).withOpacity(0.12),
                            filled: true,
                            hintText: "Écrire ici...",
                            hintStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          maxLines: 5,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                        child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          // primary: Colors.green,
                          shape: StadiumBorder()),
                      onPressed: description.isNotEmpty
                          ? () {
                              if (description.isNotEmpty) {
                                FocusScope.of(context).unfocus();
                                _pageController.nextPage(
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.linear);
                              }
                            }
                          : null,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Continuer',
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 19,
                          )
                        ],
                      ),
                    ))
                  ],
                ),
              ),

            // upload fichier
            if (serviceType == "Interpretation d'examen" &&
                widget.serviceType == "Interpretation d'examen")
              Scaffold(
                backgroundColor: Colors.white,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Votre document à interpréter',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black38,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    if (file == null)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                        ),
                        onPressed: () {
                          selectFiles();
                          // final pdfFile = PDFApi.pickeFile();
                        },
                        child: Text(
                          'Télécharger le document',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Stack(
                        children: [
                          file != null
                              ? GestureDetector(
                                  onTap: () {
                                    showFile(context, file!.path);
                                  },
                                  child: Container(
                                    child: Column(
                                      children: [
                                        // FaIcon(
                                        //   fileExtension == "pdf"
                                        //       ? FontAwesomeIcons.solidFilePdf
                                        //       : FontAwesomeIcons.image,
                                        //   color: fileExtension == "pdf"
                                        //       ? Colors.red
                                        //       : Colors.blueGrey,
                                        //   size: 50,
                                        // ),
                                        // SizedBox(height: 10),
                                        SizedBox(
                                          height: size.height * 0.35,
                                          width: size.height * 0.25,
                                          child: fileExtension != "pdf"
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Image.file(
                                                    file!,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 0.6,
                                                    color: Colors.black26,
                                                  ),
                                                ),
                                                child: PDFView(
                                                    filePath: file!.path,
                                                  ),
                                              ),
                                        ),
                                        Text(
                                          basename(file!.path).toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    Spacer(),
                    SafeArea(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            // primary: Colors.green,
                            shape: StadiumBorder()),
                        onPressed: file != null
                            ? () {
                                if (file != null) {
                                  FocusScope.of(context).unfocus();
                                  _pageController.nextPage(
                                      duration: Duration(milliseconds: 400),
                                      curve: Curves.linear);
                                }
                              }
                            : null,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Continuer',
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 19,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),

            // selections
            Scaffold(
              // backgroundColor: Colors.grey.withAlpha(42),
              backgroundColor: Colors.white,
              body: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          selectedDepartment != null
                              ? selectedDepartment.toString()
                              : departService.toString(),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 19,
                        )
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Service demandé",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.withOpacity(0.6),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            serviceType!,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.green),
                          ),
                        ],
                      ),
                    ),

                    if (file == null)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.12),
                          // borderRadius: BorderRadius.circular(5),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.all(12),
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Motif",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.withOpacity(0.6),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              description,
                              style: TextStyle(
                                  fontSize: 17, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    if (file != null)
                      Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.35,
                              width: size.height * 0.25,
                              child: fileExtension != "pdf"
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        file!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 0.6,
                                          color: Colors.black26,
                                        ),
                                      ),
                                      child: PDFView(
                                        filePath: file!.path,
                                      ),
                                    ),
                            ),
                            Text(
                              basename(file!.path).toString(),
                            ),
                          ],
                        ),
                      ),
                    ElevatedButton(
                      onPressed: () {
                        final cost = getCost(context);
                        setState(() {
                          servicePrice = cost;
                        });

                        if (servicePrice != null) {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.fastOutSlowIn,
                          );
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Continuer',
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 19,
                          )
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        shape: StadiumBorder(),
                        // primary: Colors.green,
                      ),
                    )
                    // Text(demande.prixService.toString()),
                  ],
                ),
              ),
            ),

            // non pris en charge
            Scaffold(
              backgroundColor: Color(0XFF101A69),
              body: Container(
                height: size.height,
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Veuillez noter que certaines situations ne peuvent être traitées',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Scrollbar(
                          child: ListView.builder(
                            itemBuilder: (context, i) {
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  '- ${casNonTraites[i]}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                            // shrinkWrap: true,
                            itemCount: casNonTraites.length,
                          ),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              _pageController.previousPage(
                                duration: Duration(milliseconds: 400),
                                curve: Curves.fastOutSlowIn,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              elevation: 0.0,
                              side: BorderSide(
                                color: Colors.white,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              padding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 20,
                              ),
                            ),
                            child: Text(
                              'Je quitte',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 400),
                                curve: Curves.fastOutSlowIn,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              // primary: Colors.green,
                              padding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 20,
                              ),
                            ),
                            child: Text('J\'accepte'),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (servicePrice != null)
              // recapit
              Scaffold(
                backgroundColor: Colors.black.withAlpha(5),
                body: Container(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Service",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(serviceType),
                                ],
                              ),
                              if (selectedDepartment == null)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Departement",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(departService.toString()),
                                  ],
                                ),
                              if (departService == null)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Departement",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(selectedDepartment.toString()),
                                  ],
                                ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Prix',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(servicePrice!),
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    servicePrice!,
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SafeArea(
                          child: ElevatedButton(
                            onPressed: () async {
                              final typeDemande = widget.serviceType;
                              final departement = widget.departementService ??
                                  selectedDepartment;
                              final motDescription = description;

                              final emailUser = userEmail;

                              final tarif = servicePrice;

                              final userDoc =
                                  file == null ? "null" : basename(file!.path);

                              if (servicePrice == "Gratuit") {
                                if (file != null) {
                                  await ApiService.uploadUserDoc(context, file!,
                                      "$userEmail", "$userDossier");
                                }
                                print(userDossier);
                                final iDdemande = await ApiService.newDemande(
                                    typeDemande,
                                    motDescription,
                                    departement,
                                    emailUser,
                                    tarif,
                                    userDoc);

                                setState(() {
                                  demandeID = iDdemande;
                                });
                                print(demandeID);
                                if (demandeID != null) {
                                  addNotif("$departement", "$demandeID");
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => UserWaiting(
                                        idDemande: demandeID!,
                                      ),
                                    ),
                                  );
                                  _pageController.nextPage(
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.fastOutSlowIn,
                                  );
                                }
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PayementScreen(
                                        userID,
                                        servicePrice,
                                        "$typeDemande",
                                        motDescription,
                                        "$departement",
                                        "$emailUser",
                                        "$tarif",
                                        userDoc),
                                  ),
                                );
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Continuer',
                                ),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 19,
                                )
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              shape: StadiumBorder(),
                              // primary: Colors.green,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget customButton(Size size, String department, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(size.width / 1.2, 45),
          elevation: 0.0,
          primary:
              department == "Urgence" ? Color(0XFFE05050) : Colors.blue,
              // department == "Urgence" ? Color(0XFFE05050) : Color(0XFF52A0C1),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Text(department.toUpperCase()),
          ],
        ),
      ),
    );
  }
}
