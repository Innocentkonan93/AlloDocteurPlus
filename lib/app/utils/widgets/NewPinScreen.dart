import '../../users/screens/informations/UserMedicalInfo.dart';
import '../../../data/controllers/UsersController.dart';
import '../../../data/models/User.dart';
import '../../../data/services/ApiService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewPinScreen extends StatefulWidget {
  final User currentUser;
  const NewPinScreen({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<NewPinScreen> createState() => _NewPinScreenState();
}

class _NewPinScreenState extends State<NewPinScreen> {
  int _currentindex = 0;
  int _confirmCurrentindex = 0;
  List<int> code = [];
  List<int> confirmCode = [];
  int codeLength = 4;

  late PageController pageController;
  int _selectedPage = 0;
  bool isError = false;
  bool isProcessing = false;



  Future<String> getUserID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userID = prefs.getString('userID').toString();
    return userID;
  }

  Future<void> getCurrentUserData() async {
    var userID = await getUserID();
    var resp = await ApiService.getCurrentUser(userID);
    var provider = Provider.of<UsersController>(context, listen: false);

    if (resp.isSuccesful) {
      provider.setUserList(resp.data);

      provider.isProces(resp.isSuccesful);
    }

    return resp.data;
  }

 

  @override
  void initState() {
    pageController = PageController(
      initialPage: _selectedPage,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; 
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.lock_fill, color: Colors.blue[900],),
            SizedBox(width: 10),
            Text(
              "Sécurité",
              style: GoogleFonts.montserrat(
                color: Colors.blue[900],
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            _selectedPage == 0
                                ? 'Nouveau code pin'
                                : 'Confirmation',
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 23,
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Pour la garantie d\'une bonne confidentialité, la protection de votre dossier médical s\'impose à vous.\n Configurez votre code pin',
                              style: GoogleFonts.nunito(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: PageView(
                      controller: pageController,
                      onPageChanged: (index) {
                        print(index);
                        setState(() {
                          _selectedPage = index;
                        });
                      },
                      children: [
                        Container(
                          // color: Colors.cyan,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(codeLength, (i) {
                                  return GestureDetector(
                                    onTap: () {
                                      // setState(() {
                                      //   _currentindex = index;
                                      // });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      width: size.width * 0.15,
                                      height: size.height * 0.15,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: _currentindex == i
                                            ? [
                                                BoxShadow(
                                                    color:
                                                        Colors.indigo.shade900,
                                                    offset: Offset(0, 0),
                                                    spreadRadius: 1.5,
                                                    blurRadius: 2)
                                              ]
                                            : null,
                                      ),
                                      child: Center(
                                        child: _currentindex >= i + 1
                                            ? Icon(
                                                Icons.circle,
                                                size: 18,
                                              )
                                            : Container(),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              Text(
                                'Un code à 4 chiffres',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          // color: Colors.cyan,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(codeLength, (i) {
                                  return GestureDetector(
                                    onTap: () {
                                      // setState(() {
                                      //   _currentindex = index;
                                      // });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      width: size.width * 0.15,
                                      height: size.height * 0.15,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: isError
                                            ? [
                                                BoxShadow(
                                                    color: Colors.red.shade900,
                                                    offset: Offset(0, 0),
                                                    spreadRadius: 1.5,
                                                    blurRadius: 2)
                                              ]
                                            : _confirmCurrentindex == i
                                                ? [
                                                    BoxShadow(
                                                        color: Colors
                                                            .indigo.shade900,
                                                        offset: Offset(0, 0),
                                                        spreadRadius: 1.5,
                                                        blurRadius: 2)
                                                  ]
                                                : null,
                                      ),
                                      child: Center(
                                        child: _confirmCurrentindex >= i + 1
                                            ? Icon(
                                                Icons.circle,
                                                size: 18,
                                              )
                                            : Container(),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              Text(
                                'Un code à 4 chiffres',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        // color: Colors.white,
                        child: isProcessing
                            ? Center(
                                child: CircularProgressIndicator.adaptive(),
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 1.4,
                                  crossAxisCount: 3,
                                ),
                                padding: EdgeInsets.all(10),
                                itemCount: 12,
                                itemBuilder: (context, index) {
                                  return index == 9
                                      ? Center(
                                          child: TextButton(
                                            onPressed: () {
                                              backSpace();
                                            },
                                            child: Icon(
                                              Icons.backspace_outlined,
                                              color: Colors.black,
                                            ),
                                            style: TextButton.styleFrom(
                                                elevation: 0.0,
                                                primary: Colors.white,
                                                shape: StadiumBorder()),
                                          ),
                                        )
                                      : index == 10
                                          ? Center(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  addDigit(0);
                                                },
                                                child: Text(
                                                  '0',
                                                  style: GoogleFonts.montserrat(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    elevation: 0.0,
                                                    primary: Colors.white,
                                                    shape: StadiumBorder()),
                                              ),
                                            )
                                          : index == 11
                                              ? Center(
                                                  child: _selectedPage == 0 ||
                                                          confirmCode.length < 1
                                                      ? TextButton(
                                                          onPressed: () {
                                                            // pageController.jumpTo(0);

                                                            if (_selectedPage ==
                                                                1) {
                                                              pageController.previousPage(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          300),
                                                                  curve: Curves
                                                                      .linear);
                                                            } else {
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          },
                                                          child: Text(
                                                            'Retour',
                                                            style: TextStyle(
                                                                // color: Colors.black,
                                                                ),
                                                          ),
                                                          style: TextButton
                                                              .styleFrom(
                                                                  elevation:
                                                                      0.0,
                                                                  primary: Colors
                                                                      .red[600],
                                                                  shape:
                                                                      StadiumBorder()),
                                                        )
                                                      : ElevatedButton(
                                                          onPressed: confirmCode
                                                                      .length !=
                                                                  codeLength
                                                              ? null
                                                              : () {
                                                                  final lastCode =
                                                                      code.join();
                                                                  if (lastCode ==
                                                                      confirmCode
                                                                          .join()) {
                                                                    validCode(
                                                                      "${widget.currentUser.emailUtilisateur}",
                                                                    );
                                                                  } else {
                                                                    print(
                                                                        "pin error");
                                                                    setState(
                                                                        () {
                                                                      isError =
                                                                          true;
                                                                    });
                                                                  }
                                                                },
                                                          child: Icon(
                                                            Icons.check,
                                                          ),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            elevation: 0.0,
                                                            primary: Colors
                                                                .green[600],
                                                            shape:
                                                                StadiumBorder(),
                                                          ),
                                                        ),
                                                )
                                              : Center(
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      addDigit(index + 1);
                                                    },
                                                    child: Text(
                                                      '${index + 1}',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 22,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      elevation: 0.0,
                                                      primary: Colors.white,
                                                      shape: StadiumBorder(),
                                                    ),
                                                  ),
                                                );
                                },
                              ),
                      ),
                    ),
                    flex: 5,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void addDigit(int digit) {
    // print(codeLength);
    // print(_currentindex + 1);
    if (_selectedPage == 0) {
      if (codeLength >= _currentindex + 1) {
        setState(() {
          _currentindex++;
        });
        code.add(digit);
      }
      print(code.join().toString());
      if (codeLength == code.length) {
        pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.linear,
        );
      }
    } else {
      if (codeLength >= _confirmCurrentindex + 1) {
        setState(() {
          _confirmCurrentindex++;
        });
        confirmCode.add(digit);
      }
      print(confirmCode.join().toString());
      getCurrentUserData();
      if (codeLength == code.length) {
        // pageController.nextPage(
        //   duration: Duration(milliseconds: 300),
        //   curve: Curves.linear,
        // );
      }
    }
  }

  void backSpace() {
    if (_selectedPage == 0) {
      if (code.length == 0) {
        return;
      }
      setState(() {
        code.removeLast();
        _currentindex = code.length;
      });
    } else {
      if (confirmCode.length == 0) {
        return;
      }
      setState(() {
        confirmCode.removeLast();
        _confirmCurrentindex = confirmCode.length;
      });
    }
  }

  void validCode(String emailUtilisateur) async {
    setState(() {
      isError = false;
    });
    if (_selectedPage == 0) {
      if (code.length < codeLength) {
        return;
      }
      print(code.join().toString());
    } else {
      setState(() {
        isProcessing = true;
      });
      if (confirmCode.length < codeLength) {
        return;
      }
      print(confirmCode.join().toString());

      final result = await ApiService.setPatientPinCode(
              emailUtilisateur, confirmCode.join())
          .then((value) async {
        if (value.contains("updated")) {
          await getCurrentUserData();
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, animation, __) {
                return FadeTransition(
                  opacity: animation,
                  child: UserMedicalInfo(),
                );
              },
            ),
          );
          setState(() {});
        }
      });
      print('result: ' + result.toString());
    }
  }
}
