import 'dart:async';
import 'dart:io';
import 'UserWaiting.dart';
import '../../../../data/services/ApiService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

const String kNavigationExamplePage = '''
<!DOCTYPE html><html>
<head><title>Navigation Delegate Example</title></head>
<body>
<p>
The navigation delegate is set to block navigation to the youtube website.
</p>
<ul>
<ul><a href="https://www.youtube.com/">https://www.youtube.com/</a></ul>
<ul><a href="https://www.google.com/">https://www.google.com/</a></ul>
</ul>
</body>
</html>''';

class PayementWebView extends StatefulWidget {
  final String userId;
  final String servicePrice;
  final String typeDemande;
  final String motDescription;
  final String departement;
  final String emailUser;
  final String tarif;
  final String userDoc;
  const PayementWebView(
      this.userId,
      this.servicePrice,
      this.typeDemande,
      this.motDescription,
      this.departement,
      this.emailUser,
      this.tarif,
      this.userDoc,
      {Key? key})
      : super(key: key);

  @override
  _PayementWebViewState createState() => _PayementWebViewState();
}

class _PayementWebViewState extends State<PayementWebView> {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  String? demandeID;
  int progress = 0;

  Future<void> addNotif(String idDemande) async {
    _db.collection("notifications/yBlfDOUJ9hair4CP2aC4/demandes").add(
      {
        "title": "Nouvelle demande",
        "body": "Une nouvelle demande fait face !",
        "notif_date": Timestamp.now(),
        "demande_departement": widget.departement,
        "channel": idDemande,
        "isView": false,
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    final servicePrice = (widget.servicePrice).split(' ').first;
    final idUSer = widget.userId;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        leading: progress != 100
            ? TextButton(
                onPressed: () {},
                child: SizedBox(
                  height: 10,
                  width: 10,
                  child: CircularProgressIndicator.adaptive(),
                ),
              )
            : BackButton(),
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl:
              'https://allodocteurplus.com/api/paiements/paiements.php?id=$idUSer&servicePrice=$servicePrice',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          onProgress: (int progress) {
            print("WebView is loading (progress : $progress%)");
            setState(() {
              this.progress = progress;
            });
          },
          javascriptChannels: <JavascriptChannel>{
            _toasterJavascriptChannel(context),
          },
          navigationDelegate: (NavigationRequest request) async {
            print('${request.url}');
            if (request.url.startsWith('https://www.allodocteurplus.com/')) {
              print('blocking navigation to $request}');

              return NavigationDecision.prevent;
            }
            print('allowing navigation to $request');
            if (request.url.contains(
                'https://allodocteurplus.com/api/paiements/paymentDone.php')) {
              final iDdemande = await ApiService.newDemande(
                widget.typeDemande,
                widget.motDescription,
                widget.departement,
                widget.emailUser,
                widget.tarif,
                widget.userDoc,
              );
              setState(() {
                demandeID = iDdemande;
              });
              print(demandeID);
              if (demandeID != null) {
                await addNotif("$demandeID");
                Future.delayed(Duration(seconds: 4), () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => UserWaiting(idDemande: demandeID!),
                    ),
                  );
                });
              }
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
        );
      }),
      // floatingActionButton: favoriteButton(),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

   
}
 

 
