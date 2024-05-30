import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/intro_screens/intro_page_1.dart';
import 'package:flutter_application_2/intro_screens/intro_page_2.dart';
import 'package:flutter_application_2/intro_screens/intro_page_3.dart';
import 'package:flutter_application_2/select_manu.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController controller = PageController();
  bool onLastPage = false;
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    getConnectivity();
    _checkInternetConnection();
    // TODO: implement initState
    super.initState();
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        showDiaLogBox();
        setState(() {
          isAlertSet = true;
        });
      });
    } else {
      setState(() {});
    }
  }

  getConnectivity() => subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;

        if (!isDeviceConnected && isAlertSet == false) {
          showDiaLogBox();
          setState(() {
            isAlertSet = true;
          });
        }
      });

  @override
  void dispose() {
    subscription.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Container(
              alignment: Alignment(0, 0.90),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: () {
                        controller.jumpToPage(2);
                      },
                      child: const Text(
                        'skip',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.white),
                      )),
                  SmoothPageIndicator(
                      effect: const ColorTransitionEffect(
                          paintStyle: PaintingStyle.stroke,
                          dotColor: Colors.black,
                          activeDotColor: Colors.white),
                      controller: controller,
                      count: 3),
                  onLastPage
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectManu()));
                          },
                          child: const Text('done',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white)))
                      : GestureDetector(
                          onTap: () {
                            controller.nextPage(
                                duration: Duration(microseconds: 500),
                                curve: Curves.easeIn);
                          },
                          child: const Text('next',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white))),
                ],
              ))
        ],
      ),
    );
  }

  showDiaLogBox() => showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
            title: const Text('No Connection'),
            content: const Text('Please check your internet connection'),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context, 'Cancel');
                    setState(() {
                      isAlertSet = false;
                    });
                    isDeviceConnected =
                        await InternetConnectionChecker().hasConnection;
                    if (!isDeviceConnected) {
                      showDiaLogBox();
                      setState(() {
                        isAlertSet = true;
                      });
                    }
                  },
                  child: Text('ok')),
            ],
          ));
}
