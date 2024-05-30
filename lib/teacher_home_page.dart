import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/addCourse/add_course.dart';
import 'package:flutter_application_2/addQuestionPaper/upload_yearly_question_paper.dart';
import 'package:flutter_application_2/addSubject/add_subject.dart';
import 'package:flutter_application_2/addSubjectNode/upload_pdf.dart';
import 'package:flutter_application_2/addTopicVideo/upload_video.dart';
import 'package:flutter_application_2/constractor/teacherDetails.dart';
import 'package:flutter_application_2/overloading_screen.dart';
import 'package:flutter_application_2/teacher_deshbord.dart';
import 'package:flutter_application_2/teacher_setting_screen.dart';
import 'package:flutter_application_2/teacher_student_list.dart';
import 'package:flutter_application_2/utils.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherHomeScreen extends StatefulWidget {
  TeacherDetails tdetails;
  TeacherHomeScreen(this.tdetails);
  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState(tdetails);
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen>
    with TickerProviderStateMixin {
  TeacherDetails tdetails;
  _TeacherHomeScreenState(this.tdetails);
  late AnimationController animationController;
  TickerFuture _toggle() => animationController.isCompleted
      ? animationController.reverse()
      : animationController.forward();
  late SharedPreferences sp;
  late StreamSubscription<ConnectivityResult> subscription;
  String connectionStatus = 'Unknown';
  var isDeviceConnected = false;
  bool isAlertSet = false;

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
          // connectionStatus = 'Connected to Wi-Fi';
          // Fluttertoast.showToast(msg: connectionStatus);
        } else if (result == ConnectivityResult.mobile) {
          // connectionStatus = 'Connected to Mobile Data';
          // Fluttertoast.showToast(msg: connectionStatus);
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
    _checkInternetConnection();
    setState(() {
      startMonitoringConnectivity();
    });
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
    subscription.cancel();
  }

  showDiaLogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Column(
            children: [
              Icon(Icons.wifi_off_outlined),
              Text('No Connection'),
            ],
          ),
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
        ),
      );
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget? _) {
          var scale = 1 - (animationController.value * 0.3);
          var maxSide = MediaQuery.of(context).size.width;
          var side = (maxSide * (animationController.value * 0.6));
          return GestureDetector(
            child: Stack(
              children: [
                Material(
                  color: Theme.of(context).colorScheme.background,
                  child: SafeArea(
                      child: Theme(
                    data: ThemeData(brightness: Brightness.dark),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              children: [
                                tdetails.image == 'no image'
                                    ? CircleAvatar(
                                        radius: 20.0,
                                        backgroundColor: Colors.black,
                                        child: Image.asset(
                                          "assets/images/default.png",
                                          height: 100,
                                          width: 100,
                                        ),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: MyUrl.fullurl +
                                            MyUrl.Teacherimageurl +
                                            tdetails.image,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(90),
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
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    tdetails.name,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TeacherDeshbord(tdetails),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.person,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                    title: Text(
                                      'Profile',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TeacherStudentList(),
                                      ),
                                    ).whenComplete(() {
                                      _toggle();
                                    });
                                  },
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.people,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                    title: Text(
                                      'Students',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TeacherSettingScreen(tdetails),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.settings,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                    title: Text(
                                      'Setting',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
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
                                            const OnBoardingScreen(),
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
                                  },
                                ).show();
                              },
                              child: ListTile(
                                leading: Icon(
                                  Icons.logout,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                title: Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
                ),
                Transform(
                  transform: Matrix4.identity()
                    ..translate(side)
                    ..scale(scale),
                  alignment: Alignment.centerLeft,
                  child: Scaffold(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    body: Stack(
                      children: [
                        Positioned(
                          child: Column(
                            children: [
                              Container(
                                height: 250,
                                decoration: const BoxDecoration(
                                  color: Colors.lightBlue,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(150),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    AppBar(
                                      backgroundColor: Colors.transparent,
                                      leading: InkWell(
                                        onTap: _toggle,
                                        child: Icon(
                                          Icons.menu,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                        ),
                                      ),
                                      title: Text(
                                        'Hi,${tdetails.name}',
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
                          child: GridView.count(
                            mainAxisSpacing: 20,
                            crossAxisCount: 2,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddCourse(),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 20,
                                          spreadRadius: 0.5),
                                      BoxShadow(
                                          color: Colors.white,
                                          blurRadius: 0,
                                          spreadRadius: 3.0)
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 70,
                                        width: 70,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 20,
                                                spreadRadius: 0.5),
                                            BoxShadow(
                                                color: Colors.white,
                                                blurRadius: 0,
                                                spreadRadius: 3.0)
                                          ],
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Icon(
                                            Icons.school,
                                            size: 50,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Text(
                                        'Add Course',
                                        style: TextStyle(color: Colors.black),
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
                                      builder: (context) => const AddSubject(),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 20,
                                          spreadRadius: 0.5),
                                      BoxShadow(
                                          color: Colors.white,
                                          blurRadius: 0,
                                          spreadRadius: 3.0)
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 70,
                                        width: 70,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 20,
                                                spreadRadius: 0.5),
                                            BoxShadow(
                                                color: Colors.white,
                                                blurRadius: 0,
                                                spreadRadius: 3.0)
                                          ],
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Icon(
                                            Icons.subject,
                                            size: 50,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Text(
                                        'Add Subject',
                                        style: TextStyle(color: Colors.black),
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
                                      builder: (context) => UploadPDF(),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 20,
                                          spreadRadius: 0.5),
                                      BoxShadow(
                                          color: Colors.white,
                                          blurRadius: 0,
                                          spreadRadius: 3.0)
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 70,
                                        width: 70,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 20,
                                                spreadRadius: 0.5),
                                            BoxShadow(
                                                color: Colors.white,
                                                blurRadius: 0,
                                                spreadRadius: 3.0)
                                          ],
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Icon(
                                            Icons.menu_book,
                                            size: 50,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Text(
                                        'Add Notes',
                                        style: TextStyle(color: Colors.black),
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
                                          UploadYearlyQuestionPager(),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 20,
                                          spreadRadius: 0.5),
                                      BoxShadow(
                                          color: Colors.white,
                                          blurRadius: 0,
                                          spreadRadius: 3.0)
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 70,
                                        width: 70,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 20,
                                                spreadRadius: 0.5),
                                            BoxShadow(
                                                color: Colors.white,
                                                blurRadius: 0,
                                                spreadRadius: 3.0)
                                          ],
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Icon(
                                            Icons.question_answer,
                                            size: 50,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Text(
                                        'Add Question Paper',
                                        style: TextStyle(color: Colors.black),
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
                                      builder: (context) => UploadVideo(),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 20,
                                          spreadRadius: 0.5),
                                      BoxShadow(
                                          color: Colors.white,
                                          blurRadius: 0,
                                          spreadRadius: 3.0)
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 70,
                                        width: 70,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 20,
                                                spreadRadius: 0.5),
                                            BoxShadow(
                                                color: Colors.white,
                                                blurRadius: 0,
                                                spreadRadius: 3.0)
                                          ],
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Icon(
                                            Icons.video_collection,
                                            size: 50,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Text(
                                        'Add Topic Video',
                                        style: TextStyle(color: Colors.black),
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
                )
              ],
            ),
          );
        });
  }
}
