import 'dart:async';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/Student_setting_screen.dart';
import 'package:flutter_application_2/constractor/studentdetails.dart';
import 'package:flutter_application_2/overloading_screen.dart';
import 'package:flutter_application_2/student_subject_page.dart';
import 'package:flutter_application_2/student_deshboard.dart';
import 'package:flutter_application_2/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class StudentDepartmentScreen extends StatefulWidget {
  StudentDetails details;
  // ignore: use_key_in_widget_constructors
  StudentDepartmentScreen(this.details);
  @override
  State<StudentDepartmentScreen> createState() =>
      // ignore: no_logic_in_create_state
      _StudentDepartmentScreenState(details);
}

class _StudentDepartmentScreenState extends State<StudentDepartmentScreen> {
  StudentDetails details;
  _StudentDepartmentScreenState(this.details);

  late SharedPreferences sp;
  late StreamSubscription<ConnectivityResult> subscription;
  String connectionStatus = 'Unknown';
  var isDeviceConnected = false;
  bool isAlertSet = false;
  double xOffset = 0;
  double yOffset = 0;
  bool isDrawerOpen = false;
  List<String> Semester = ['1', '2', '3', '4', '5', '6', '7', '8'];

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

  startMonitoringConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;

      setState(() {
        if (result == ConnectivityResult.none) {
          showDiaLogBox();
          setState(() {
            isAlertSet = true;
          });
        } else if (result == ConnectivityResult.wifi) {
        } else if (result == ConnectivityResult.mobile) {}
      });
    });
    return connectionStatus;
  }

  void stopMonitoringConnectivity() {
    subscription.cancel();
  }

  @override
  void initState() {
    // getcoursecode();
    _checkInternetConnection();

    startMonitoringConnectivity();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.background),
            child: Padding(
              padding: const EdgeInsets.only(top: 50, left: 20, bottom: 70),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      details.image == 'no image'
                          ? CircleAvatar(
                              // radius: 50.0,
                              backgroundColor:
                                  Theme.of(context).colorScheme.onBackground,
                              child: Image.asset(
                                "assets/images/default.png",
                                height: 50,
                                width: 50,
                              ),
                            )
                          : CachedNetworkImage(
                              color: Theme.of(context).colorScheme.onBackground,
                              imageUrl: MyUrl.fullurl +
                                  MyUrl.Studentimageurl +
                                  details.image,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        details.name,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 20,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        StudentDeshboard(details)));
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.account_circle,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Profile',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        StudentSettingScrren(details)));
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.settings,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Setting',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            AwesomeDialog(
                              context: context,
                              dialogBackgroundColor:
                                  Theme.of(context).colorScheme.background,
                              dialogType: DialogType.warning,
                              headerAnimationLoop: false,
                              animType: AnimType.bottomSlide,
                              title: 'Log Out',
                              titleTextStyle: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              desc: 'Do you want to logout?',
                              descTextStyle: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              buttonsTextStyle: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              showCloseIcon: false,
                              btnCancelOnPress: () {},
                              btnOkOnPress: () async {
                                sp = await SharedPreferences.getInstance();
                                sp.clear();

                                // ignore: use_build_context_synchronously
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const OnBoardingScreen()),
                                    (Route<dynamic> route) => false);
                              },
                            ).show();
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.cancel,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox()
                ],
              ),
            ),
          ),
          AnimatedContainer(
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(isDrawerOpen ? 0.85 : 1.00)
              ..rotateZ(isDrawerOpen ? -50 : 0),
            duration: const Duration(milliseconds: 200),
            child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: Stack(
                children: [
                  Positioned(
                    child: Column(
                      children: [
                        Container(
                          height: 150,
                          decoration: const BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(130),
                            ),
                          ),
                          child: Column(
                            children: [
                              AppBar(
                                backgroundColor: Colors.transparent,
                                leading: isDrawerOpen
                                    ? InkWell(
                                        onTap: () {
                                          setState(() {
                                            xOffset = 0;
                                            yOffset = 0;
                                            isDrawerOpen = false;
                                          });
                                        },
                                        child: Icon(
                                          Icons.arrow_back_ios,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          setState(() {
                                            xOffset = 290;
                                            yOffset = 80;
                                            isDrawerOpen = true;
                                          });
                                        },
                                        child: Icon(
                                          Icons.menu,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                        ),
                                      ),
                                title: Text(
                                  'Select semester',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 150),
                      child: GridView.builder(
                          itemCount: 8,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12.0,
                            mainAxisSpacing: 15.0,
                          ),
                          itemBuilder: (context, index) {
                            return SemesterTile(
                              semester: 'Semester ${index + 1}',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StudentSubjectPage(
                                        semester: (index + 1).toString()),
                                  ),
                                );
                              },
                            );
                          }))
                ],
              ),
            ),
          ),
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
                  child: const Text('ok')),
            ],
          ));
}

class SemesterTile extends StatelessWidget {
  final String semester;
  final VoidCallback onTap;

  const SemesterTile({required this.semester, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.grey, blurRadius: 20, spreadRadius: 0.5),
            BoxShadow(color: Colors.white, blurRadius: 0, spreadRadius: 3.0)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, blurRadius: 20, spreadRadius: 0.5),
                  BoxShadow(
                      color: Colors.white, blurRadius: 0, spreadRadius: 3.0)
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.school,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              semester,
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
