import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_application_2/TeacherSetting/teacher_change_password.dart';
import 'package:flutter_application_2/TeacherSetting/teacher_email_change.dart';
import 'package:flutter_application_2/TeacherSetting/teacher_mobileno_change.dart';
import 'package:flutter_application_2/constractor/teacherDetails.dart';
import 'package:flutter_application_2/controller/theme_controler.dart';
import 'package:flutter_application_2/teacher_home_page.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class TeacherSettingScreen extends StatefulWidget {
  // const TeacherSettingScreen({super.key});
  TeacherDetails tdetails;
  TeacherSettingScreen(this.tdetails);

  @override
  State<TeacherSettingScreen> createState() =>
      _TeacherSettingScreenState(tdetails);
}

class _TeacherSettingScreenState extends State<TeacherSettingScreen> {
  TeacherDetails tdetails;
  _TeacherSettingScreenState(this.tdetails);
  getData() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => TeacherHomeScreen(tdetails)));
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    ThemeController themeController = Get.put(ThemeController());
    return WillPopScope(
      onWillPop: () => getData(),
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
                            onTap: () {
                              getData();
                            },
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                          title: Text(
                            'Settings',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                          actions: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (themeController.isDark.value) {
                                    themeController.changeTheme('dark');
                                    themeController.isDark.value = false;
                                  } else {
                                    themeController.changeTheme('light');
                                    themeController.isDark.value = true;
                                  }
                                });
                              },
                              icon: Obx(
                                () => themeController.isDark.value
                                    ? const Icon(
                                        Icons.light_mode,
                                        color: Colors.white,
                                      )
                                    : const Icon(
                                        Icons.dark_mode,
                                        color: Colors.black,
                                      ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: GridView.count(
                mainAxisSpacing: 20,
                crossAxisCount: 2,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeacherChangePassword(tdetails),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
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
                                Icons.lock,
                                size: 50,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Change Password',
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
                              builder: ((context) =>
                                  TeacherEmailChange(tdetails))));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
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
                                Icons.email,
                                size: 50,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Change Email',
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
                                  TeacherMobileNumberChanage(tdetails)));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
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
                                Icons.phone,
                                size: 50,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Change Phone no.',
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
    );
  }
}
