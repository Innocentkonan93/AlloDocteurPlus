import '../../users/screens/informations/UserMedicalInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:google_fonts/google_fonts.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({
    required this.pinUtilisateur,
    Key? key,
  }) : super(key: key);

  final String pinUtilisateur;

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  int _currentindex = 0;
  List<int> code = [];
  int codeLength = 4;
  bool isError = false;
  int errorLenth = 0;



  // Future<void> getUserData() async {
  //   var resp = await ApiService.getAllUtilisateurs();
  //   var provider = Provider.of<UsersController>(context, listen: false);
  //   if (resp.isSuccesful) {
  //     provider.setUserList(resp.data);
  //     provider.isProces(resp.isSuccesful);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: Colors.black.withBlue(40),
      // appBar: AppBar(),
      body: Column(
        children: [
          Container(
            height: size.height * 0.12,
            width: size.width,
            child: Center(
              child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.folder_badge_person_crop,
              color: Colors.blue[900],
            ),
            SizedBox(width: 10),
            Text(
              "Dossier médical",
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.blue[900]),
            ),
          ],
        ),
            ),
          ),
          Container(
            height: size.height * 0.88,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Veuillez entrer votre code pin',
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 23,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'pour accéder a votre dossier médical ',
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
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
                                      : _currentindex == i
                                          ? [
                                              BoxShadow(
                                                  color: Colors.indigo.shade900,
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
                            errorLenth == 0 ? '' :
                            errorLenth < 3
                                ? "Code pin incorrect"
                                : 'Mot de passe oublié ?',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: errorLenth == 0 ? Colors.black:
                                  errorLenth < 3 ? Colors.red[800] : Colors.blue,
                            ),
                          ),
                          Text('Code à 4 chiffres')
                      ],
                    ),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      // color: Colors.white,
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1.4,
                          crossAxisCount: 3,
                        ),
                        padding: EdgeInsets.all(10),
                        physics: NeverScrollableScrollPhysics(),
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
                                          elevation: 1,
                                          primary: Colors.white,
                                          shape: StadiumBorder()
                                        ),

                                      ),
                                    )
                                  : index == 11
                                      ? code.length != codeLength
                                          ? Center(
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Retour'),
                                                style: TextButton.styleFrom(
                                                  elevation: 0.0,
                                                  primary: Colors.red[800],
                                                  shape: StadiumBorder(),
                                                ),
                                              ),
                                            )
                                          : Center(
                                              child: ElevatedButton(
                                                onPressed:
                                                    code.length < codeLength
                                                        ? null
                                                        : validCode,
                                                child: Icon(
                                                  Icons.check,
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0.0,
                                                  primary: Colors.green[900],
                                                  shape: StadiumBorder(),
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
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 22,
                                                color: Colors.black,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
elevation: 1,
                                                primary: Colors.white,
                                                shape: StadiumBorder()),
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
          )
        ],
      ),
    );
  }

  void addDigit(int digit) {
    // print(codeLength);
    // print(_currentindex + 1);

    if (codeLength >= _currentindex + 1) {
      setState(() {
        _currentindex++;
      });
      code.add(digit);
    }
    print(code.join().toString());
  }

  void backSpace() {
    if (code.length == 0) {
      return;
    }
    setState(() {
      code.removeLast();
      _currentindex = code.length;
    });
  }

  void validCode() async{
    if (code.length < codeLength) {
      return;
    }

    if (code.join().toString() == widget.pinUtilisateur.toString()) {
      setState(() {
        isError = false;
        errorLenth = 0;
      });
      print('yearrrrrr');
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
        // MaterialPageRoute(
        //   builder: (context) => UserMedicalInfo(),
        // ),
      );
    } else {
      bool canVibrate = await Vibrate.canVibrate;
      if(canVibrate){
        Vibrate.vibrate();
      }
      setState(() {
        errorLenth++;
        isError = true;
      });
    }
  }
}
