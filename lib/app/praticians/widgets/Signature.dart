import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({Key? key}) : super(key: key);

  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.red,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print('Value changed'));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Votre signature',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          // Container(
          //   margin: EdgeInsets.all(10),
          //   width: double.infinity,
          //   height: size.height / 3,
          //   decoration: BoxDecoration(
          //     color: Colors.grey,
          //     borderRadius: BorderRadius.circular(30),
          //   ),
          // ),
          Signature(
            controller: _controller,
            height: 300,
            backgroundColor: Colors.lightBlueAccent,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() => _controller.clear());
                },
                icon: CircleAvatar(
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.red,
                ),
              ),
              SizedBox(width: 20),
              IconButton(
                onPressed: () async {
                  if (_controller.isNotEmpty) {
                    final signature = await exporteSignature();
                    // final Uint8List? data = await _controller.toPngBytes();
                    // if (data != null) {
                    //   final dir = await FilePicker.platform.getDirectoryPath();
                    //   print(dir);

                      await Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) {
                            return Scaffold(
                              appBar: AppBar(
                                actions: [
                                  IconButton(onPressed: (){}, icon: Icon(Icons.check))
                                ],
                              ),
                              body: Center(
                                child: Container(
                                  color: Colors.white,
                                  child: Image.memory(
                                    signature,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    // }
                  }
                },
                icon: CircleAvatar(
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height / 8,
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Changer de signature'),
            style: ElevatedButton.styleFrom(
              elevation: 0.0,
              primary: Color(0XFF5B67C7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<Uint8List> exporteSignature()async{
    final exportController = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
      points:  _controller.points
    );
    final signature = await exportController.toPngBytes();

    exportController.clear();
    return signature!;
  }
}
