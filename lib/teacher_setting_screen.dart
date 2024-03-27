import 'package:flutter/material.dart';
import 'package:flutter_application_2/constractor/teacherDetails.dart';
import 'package:flutter_application_2/controller/theme_controler.dart';

import 'package:flutter_application_2/teacher_email_change.dart';
import 'package:flutter_application_2/teacher_mobileno_change.dart';
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
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    ThemeController themeController = Get.put(ThemeController());
    return Scaffold(
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
                  SizedBox(
                    height: 70,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 35, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SELECT DEPARTMENT',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
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
                                    color: Colors.white,
                                  ),
                          ),
                        ),
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
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: height * 0.07,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 5),
                                color: Colors.blue.withOpacity(.5),
                                spreadRadius: 2,
                                blurRadius: 8)
                          ]),
                      child: ListTile(
                        title: const Text("Change Password"),
                        leading: Icon(Icons.key_sharp),
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: height * 0.07,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 5),
                                  color: Colors.blue.withOpacity(.5),
                                  spreadRadius: 2,
                                  blurRadius: 8)
                            ]),
                        child: ListTile(
                          title: const Text("Change Email"),
                          leading: Icon(Icons.email),
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
                                  TeacherMobileNumberChanage(tdetails)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: height * 0.07,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 5),
                                  color: Colors.blue.withOpacity(.5),
                                  spreadRadius: 2,
                                  blurRadius: 8)
                            ]),
                        child: ListTile(
                          title: const Text("Change Mobile no."),
                          leading: Icon(Icons.phone_android),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: height * 0.07,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 5),
                                color: Colors.blue.withOpacity(.5),
                                spreadRadius: 2,
                                blurRadius: 8)
                          ]),
                      child: ListTile(
                        title: const Text("Delete Account"),
                        leading: Icon(Icons.account_box),
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
