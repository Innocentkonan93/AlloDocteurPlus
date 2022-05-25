import 'dart:math';

import 'package:flutter/material.dart';

class AppRatingView extends StatefulWidget {
  const AppRatingView({Key? key}) : super(key: key);

  @override
  _AppRatingViewState createState() => _AppRatingViewState();
}

class _AppRatingViewState extends State<AppRatingView> {
  var _ratingPageController = PageController();
  var _starPosition = 200.0;
  var _start = 0.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // ratink text
          Container(
            height: max(300, MediaQuery.of(context).size.height * 0.3),
            child: PageView(
              controller: _ratingPageController,
              physics: NeverScrollableScrollPhysics(),
              children: [_buildTankNote(), _causeOfRating()],
            ),
          ),
          // done button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.deepOrangeAccent,
              child: MaterialButton(
                onPressed: () {
                  print(_start);
                  Navigator.pop(context, _start);
                },
                child: Text(
                  "Terminer",
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
          AnimatedPositioned(
            top: _starPosition,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _starPosition = 50.0;
                      this._start = index + 1;
                      print(this._start);
                    });
                    _ratingPageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  },
                  icon: _start > index
                      ? Icon(Icons.star, size: 32)
                      : Icon(Icons.star_border, size: 32),
                  color: Colors.deepOrangeAccent,
                );
              }),
            ),
            duration: Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  _buildTankNote() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 100,
        ),
        Text(
          "Notez votre application",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 21, fontWeight: FontWeight.w500, color: Colors.deepOrangeAccent),
        ),
        Text('Nous heureux de recevoir votre avis')
      ],
    );
  }

  _causeOfRating() {
    return Container(
      child: Center(
        child: Text(
          'Merci pour votre note',
          style: TextStyle(
            fontSize: 24,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
