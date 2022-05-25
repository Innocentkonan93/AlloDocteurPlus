import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagesView extends StatefulWidget {
  final String imageUrl;
  const ImagesView(this.imageUrl, {Key? key}) : super(key: key);

  @override
  _ImagesViewState createState() => _ImagesViewState();
}

class _ImagesViewState extends State<ImagesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
      ),
      body: GestureDetector(
        onVerticalDragUpdate: (dragUpdateDetails) {
          print(dragUpdateDetails.primaryDelta);
          final primaryDelta = dragUpdateDetails.primaryDelta;
          if (primaryDelta! >= 5) {
            Navigator.pop(context);
          }
        },
        child: PhotoView(
          loadingBuilder: (context, event) => Center(
            child: Container(
              color: Colors.transparent,
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
              ),
            ),
          ),
          imageProvider: NetworkImage(widget.imageUrl),
        ),
      ),
    );
  }
}
