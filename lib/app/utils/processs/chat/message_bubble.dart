import '../../widgets/ImagesView.dart';
import '../../../../data/services/PDFApi.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class MessageBubble extends StatelessWidget {
  final String? message;
  final String? desciprionOrMotif;
  final bool isPratician;
  const MessageBubble(this.message, this.isPratician,
      {Key? key, this.desciprionOrMotif})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return desciprionOrMotif == "descriptionOrMotif"
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.17),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Raison de la consultation',
                      style: TextStyle(
                        color: Colors.black38,
                        // color: isPratician ? Color(0XFF101A69) : Color(0XFF101A69),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  "$message",
                  style: TextStyle(
                      color: Color(0XFF101A69),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -1),
                ),
                SizedBox(height: 5),
              ],
            ),
          )
        : Row(
            mainAxisAlignment:
                isPratician ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                // width: size.width * 0.7,
                constraints: BoxConstraints(maxWidth: size.width * 0.8),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: !isPratician
                          ? Radius.circular(0)
                          : Radius.circular(15),
                      bottomLeft: isPratician
                          ? Radius.circular(0)
                          : Radius.circular(15),
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    color: isPratician ? Colors.black12 : Colors.blue[50],
                    // color: Colors.grey.withOpacity(0.32),
                    boxShadow: []),
                child: message!.contains('https:')
                    ? message!.contains('pdf')
                        ? GestureDetector(
                            onTap: () {
                              PDFApi.loadNetwork("$message");
                            },
                            child: Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.solidFilePdf,
                                    color: Colors.red[800],
                                    size: 38,
                                  ),
                                  SizedBox(height: 6),
                                  Text('Ouvrir')
                                ],
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              Get.to(
                                () => ImagesView("$message"),
                                fullscreenDialog: true,
                              );
                            },
                            child: CachedNetworkImage(
                              imageUrl: "$message",
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) {
                                print(downloadProgress.progress);
                                return SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator.adaptive(
                                    strokeWidth: 2,
                                    value: downloadProgress.progress,
                                  ),
                                );
                              },
                              errorWidget: (context, url, error) => Icon(
                                Icons.error,
                              ),
                            ),
                          )
                    : Text(
                        "$message".capitalizeFirst.toString(),
                        softWrap: true,
                        style: TextStyle(
                          color: isPratician ? Colors.black : Colors.black,
                          // color: isPratician ? Color(0XFF101A69) : Color(0XFF101A69),
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
              ),
            ],
          );
  }
}
