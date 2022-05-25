import 'package:flutter/material.dart';

class EditUserEmail extends StatefulWidget {
  final String userEmail;
  const EditUserEmail(this.userEmail, { Key? key }) : super(key: key);

  @override
  _EditUserEmailState createState() => _EditUserEmailState();
}

class _EditUserEmailState extends State<EditUserEmail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }
}