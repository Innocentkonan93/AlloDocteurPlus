import 'OnboardModel.dart';
import '../utils/login/log/LogScreenWidget.dart';
import '../utils/terms_and_conditions/TermsAndCondition.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  int currentIndex = 0;
  late PageController _pageController;

  Future<void> _storeOnBoardInfo() async {
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("onBoard", isViewed);
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          TextButton(
            onPressed: () async{
            await  _storeOnBoardInfo();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LogScreenWidget(),
                ),
              );
            },
            child: Text(
              "Passer",
              style: TextStyle(color: Colors.red),
            ),
            style: ElevatedButton.styleFrom(
                // primary: Colors.red[800],
                ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final screen = screens[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 150,
                        backgroundImage: AssetImage(
                          screen.image,
                        ),
                        backgroundColor: Color(0XFF00B3FD).withOpacity(0.05),
                      ),
                      Text(
                        screen.title.toUpperCase(),
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          screen.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                itemCount: screens.length,
              ),
            ),
            Container(
              height: 20,
              child: ListView.builder(
                itemCount: screens.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        height: 8,
                        width: index == currentIndex ? 25 : 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: index == currentIndex
                              ? Color(0XFF00B3FD)
                              : Colors.black26,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                if (currentIndex == screens.length - 1) {
                  await _storeOnBoardInfo();
                  Get.to(() => TermsAndConditions(isStarting: true,));
                  
                }
                _pageController.nextPage(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.linear);
              },
              child: currentIndex == screens.length - 1
                  ? Text('Commencer')
                  : Text('Suivant'),
              style: ElevatedButton.styleFrom(
                elevation: 0.0,
                // maximumSize: Size(200, 40),
                fixedSize: Size(300, 40),
                primary: Color(0XFF00B3FD),
                // primary: Color(0XF5B67C7),
              ),
            )
          ],
        ),
      ),
    );
  }
}
