import 'package:flutter/material.dart';
import 'package:flutter_application_2/constractor/studentdetails.dart';
import 'package:flutter_application_2/controller/theme_controler.dart';

import 'package:flutter_application_2/student_email_change.dart';
import 'package:flutter_application_2/student_mobileno_change.dart';
import 'package:flutter_application_2/student_password_change.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class StudentSettingScrren extends StatefulWidget {
  // const StudentSettingScrren({super.key});
  StudentDetails details;
  StudentSettingScrren(this.details);

  @override
  State<StudentSettingScrren> createState() =>
      _StudentSettingScrrenState(details);
}

class _StudentSettingScrrenState extends State<StudentSettingScrren> {
  StudentDetails details;
  _StudentSettingScrrenState(this.details);
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
                  const SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 35, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SELECT DEPARTMENT',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 20),
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
                            icon: Obx(() => themeController.isDark.value
                                ? const Icon(
                                    Icons.light_mode,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.dark_mode,
                                    color: Colors.white,
                                  ))),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
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
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) =>
                                  StudentPasswordchange(details))));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: height * 0.08,
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
                          title: Text(
                            "Change Password",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          leading: Icon(
                            Icons.key_sharp,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
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
                                  StudentEmailChange(details)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: height * 0.08,
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
                          title: Text(
                            "Change Email",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          leading: Icon(
                            Icons.email,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
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
                                  StudentMobileNOChange(details)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: height * 0.08,
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
                          title: Text(
                            "Change Mobile no.",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                          leading: Icon(
                            Icons.phone_android,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: height * 0.08,
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
                        title: Text(
                          "Delete Account",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        leading: Icon(
                          Icons.account_box,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
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
