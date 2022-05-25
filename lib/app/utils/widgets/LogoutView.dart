import 'dart:math';

import 'package:flutter/material.dart';

class LogoutView extends StatefulWidget {
  @override
  _LogoutViewState createState() => _LogoutViewState();
}

class _LogoutViewState extends State<LogoutView> {
bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // ratink text
          Container(
              height: max(200, MediaQuery.of(context).size.height * 0.3),
              width: double.infinity,
              child: isLoading ? SizedBox(
                width: 80,
                height: 80,
                child: Center(child: CircularProgressIndicator.adaptive()),
              ) :
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Deconnexion',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Voulez-vous vous deconnecter ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              ),
          // done button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.red,
              child: MaterialButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                },
                child: Text(
                  "Oui",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          //Skip button
          Positioned(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.close, size: 16),
            ),
            right: 0,
          ),
        ],
      ),
    );
  }
}
