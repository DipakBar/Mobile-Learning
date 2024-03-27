import 'dart:async';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/add_course.dart';
import 'package:flutter_application_2/constractor/teacherDetails.dart';
import 'package:flutter_application_2/overloading_screen.dart';
import 'package:flutter_application_2/teacher_deshbord.dart';
import 'package:flutter_application_2/teacher_setting_screen.dart';
import 'package:flutter_application_2/teacher_student_list.dart';
import 'package:flutter_application_2/upload_pdf.dart';
import 'package:flutter_application_2/upload_video.dart';
import 'package:flutter_application_2/upload_yearly_question_paper.dart';
import 'package:flutter_application_2/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_subject.dart';

// ignore: must_be_immutable
class TeacherHomeScreen extends StatefulWidget {
  // const TeacherDepartmentScreen({super.key});
  TeacherDetails tdetails;
  TeacherHomeScreen(this.tdetails);

  @override
  State<TeacherHomeScreen> createState() =>
      _TeacherDepartmentScreenState(tdetails);
}

class _TeacherDepartmentScreenState extends State<TeacherHomeScreen> {
  TeacherDetails tdetails;
  _TeacherDepartmentScreenState(this.tdetails);
  double value = 0;
  // bool ontap = true;
  late SharedPreferences sp;
  late StreamSubscription<ConnectivityResult> subscription;
  String connectionStatus = 'Unknown';
  var isDeviceConnected = false;
  bool isAlertSet = false;

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
          // connectionStatus = 'No Internet Connection';
          // Fluttertoast.showToast(msg: connectionStatus);
        } else if (result == ConnectivityResult.wifi) {
          connectionStatus = 'Connected to Wi-Fi';
          Fluttertoast.showToast(msg: connectionStatus);
        } else if (result == ConnectivityResult.mobile) {
          connectionStatus = 'Connected to Mobile Data';
          Fluttertoast.showToast(msg: connectionStatus);
        }
      });
    });
    return connectionStatus;
  }

  void stopMonitoringConnectivity() {
    subscription.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      startMonitoringConnectivity();
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.blue),
          ),
          SafeArea(
              child: Container(
            width: 200,
            child: Column(
              children: [
                DrawerHeader(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    tdetails.image == 'no image'
                        ? CircleAvatar(
                            radius: 50.0,
                            backgroundColor: Colors.black,
                            child: Image.asset(
                              "assets/images/default.png",
                              height: 100,
                              width: 100,
                            ),
                          )
                        : CircleAvatar(
                            radius: 50.0,
                            backgroundImage: NetworkImage(
                              MyUrl.fullurl +
                                  MyUrl.Teacherimageurl +
                                  tdetails.image,
                            ),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      tdetails.name,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )),
                Expanded(
                    child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TeacherDeshbord(tdetails)));
                          },
                          leading: const Icon(
                            Icons.account_circle,
                            color: Colors.black,
                          ),
                          title: const Text('Profile'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          leading: const Icon(Icons.share),
                          title: const Text('Share'),
                          onTap: () async {},
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          leading: const Icon(Icons.settings),
                          title: const Text('Setting'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TeacherSettingScreen(tdetails)));
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text('Logout'),
                          onTap: () {
                            AwesomeDialog(
                              context: context,
                              dialogBackgroundColor: Colors.white,
                              dialogType: DialogType.warning,
                              headerAnimationLoop: false,
                              animType: AnimType.bottomSlide,
                              title: 'Log Out',
                              titleTextStyle:
                                  const TextStyle(color: Colors.black),
                              desc: 'Do you want to logout?',
                              descTextStyle:
                                  const TextStyle(color: Colors.black),
                              buttonsTextStyle:
                                  const TextStyle(color: Colors.black),
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
                        ),
                      ),
                    ),
                  ],
                ))
              ],
            ),
          )),
          TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: value),
              duration: const Duration(microseconds: 500),
              curve: Curves.easeIn,
              builder: (_, double val, __) {
                return (Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..setEntry(0, 3, 200 * val)
                    ..rotateY((pi / 6) * val),
                  child: Scaffold(
                    body: Container(
                      color: Colors.indigo,
                      height: height,
                      width: width,
                      child: Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(),
                            height: height * 0.25,
                            width: width,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 70,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 35, left: 15, right: 15),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Hello, ${tdetails.name}",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30))),
                            height: height * 0.75,
                            width: width,
                            child: GridView(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 20,
                                      childAspectRatio: 1.1),
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddCourse()));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.white,
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.black26,
                                              spreadRadius: 1,
                                              blurRadius: 6)
                                        ]),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 30.0,
                                          // backgroundColor: Colors.black,
                                          child: Image.asset(
                                            "assets/images/add_course.png",
                                            // height: 100,
                                            // width: 100,
                                          ),
                                        ),
                                        const Text(
                                          'Add Course',
                                          style: TextStyle(
                                              // fontSize: 30,
                                              fontStyle: FontStyle.italic),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AddSubject()));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.white,
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.black26,
                                              spreadRadius: 1,
                                              blurRadius: 6)
                                        ]),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 30.0,
                                          child: Image.asset(
                                            "assets/images/add_subject.png",
                                          ),
                                        ),
                                        const Text(
                                          'Add Subject',
                                          style: TextStyle(
                                              // fontSize: 30,
                                              fontStyle: FontStyle.italic),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TeacherStudentList()));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.white,
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.black26,
                                              spreadRadius: 1,
                                              blurRadius: 6)
                                        ]),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 30.0,
                                          // backgroundColor: Colors.black,
                                          child: Image.asset(
                                            "assets/images/student_list.png",
                                            // height: 100,
                                            // width: 100,
                                          ),
                                        ),
                                        Text(
                                          'Students',
                                          style: TextStyle(
                                              // fontSize: 30,
                                              fontStyle: FontStyle.italic),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UploadPDF()));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.white,
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.black26,
                                              spreadRadius: 1,
                                              blurRadius: 6)
                                        ]),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 30.0,
                                          // backgroundColor: Colors.black,
                                          child: Image.asset(
                                            "assets/images/upload_pdf.png",
                                          ),
                                        ),
                                        const Text(
                                          'Upload PDF',
                                          style: TextStyle(
                                              // fontSize: 30,
                                              fontStyle: FontStyle.italic),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UploadYearlyQuestionPager()));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.white,
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.black26,
                                              spreadRadius: 1,
                                              blurRadius: 6)
                                        ]),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 30.0,
                                          // backgroundColor: Colors.black,
                                          child: Image.asset(
                                            "assets/images/question_paper.png",
                                          ),
                                        ),
                                        Center(
                                          child: const Text(
                                            'Yearly Question',
                                            style: TextStyle(
                                                // fontSize: 30,
                                                fontStyle: FontStyle.italic),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UploadVideo()));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.white,
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.black26,
                                              spreadRadius: 1,
                                              blurRadius: 6)
                                        ]),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 30.0,
                                          // backgroundColor: Colors.black,
                                          child: Image.asset(
                                            "assets/images/upload_video.png",
                                          ),
                                        ),
                                        const Text(
                                          'Upload Video',
                                          style: TextStyle(
                                              // fontSize: 30,
                                              fontStyle: FontStyle.italic),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ));
              }),
          GestureDetector(
            onHorizontalDragUpdate: (e) {
              if (e.delta.dx > 0) {
                setState(() {
                  value = 1;
                });
              } else {
                setState(() {
                  value = 0;
                });
              }
            },
          )
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
