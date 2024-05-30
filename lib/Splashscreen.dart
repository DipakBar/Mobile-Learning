import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/constractor/studentdetails.dart';
import 'package:flutter_application_2/constractor/teacherDetails.dart';
import 'package:flutter_application_2/controller/theme_controler.dart';
import 'package:flutter_application_2/overloading_screen.dart';
import 'package:flutter_application_2/student_department_page.dart';
import 'package:flutter_application_2/teacher_home_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ThemeController themeControler = Get.put(ThemeController());

  late SharedPreferences sp;
  String sid = '';
  String sname = '';
  String semail = '';
  String spass = '';
  String simage = '';
  String smobile = '';
  String scourse = '';

  String tid = '';
  String tname = '';
  String temail = '';
  String tpass = '';
  String timage = '';
  String tmobile = '';
  Future getData() async {
    sp = await SharedPreferences.getInstance();
    sid = sp.getString('id') ?? "";
    sname = sp.getString('name') ?? "";
    semail = sp.getString('email') ?? "";
    spass = sp.getString('pass') ?? "";
    simage = sp.getString('image') ?? "";
    smobile = sp.getString('mobile') ?? "";
    scourse = sp.getString('course') ?? "";

    tid = sp.getString('tid') ?? "";
    tname = sp.getString('tname') ?? "";
    temail = sp.getString('temail') ?? "";
    tpass = sp.getString('tpass') ?? "";
    timage = sp.getString('timage') ?? "";
    tmobile = sp.getString('tmobile') ?? "";
  }

  @override
  void initState() {
    super.initState();
    themeControler.themeSet();
    getData();
    Timer(const Duration(seconds: 2), () {
      if (semail.isNotEmpty) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => StudentDepartmentScreen(StudentDetails(
                    sid, sname, semail, spass, simage, smobile, scourse))));
      } else if (temail.isNotEmpty) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => TeacherHomeScreen(TeacherDetails(
                    tid, tname, temail, tpass, timage, tmobile))));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const OnBoardingScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/mobile_learning.png",
                  height: 200,
                  width: 200,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Center(
              child: Text(
                "Developed By Dipak",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
