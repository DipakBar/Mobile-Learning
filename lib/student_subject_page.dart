// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/loadingpage.dart';
import 'package:flutter_application_2/studentMobel/studentGetSubject.dart';
import 'package:flutter_application_2/student_bottom_navigation_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_2/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentSubjectPage extends StatefulWidget {
  final String semester;

  StudentSubjectPage({required this.semester});

  @override
  State<StudentSubjectPage> createState() => _StudentSubjectPageState();
}

class _StudentSubjectPageState extends State<StudentSubjectPage> {
  late SharedPreferences sp;
  String course = '';
  String fullcourse = '';
  List<StudentGetSubject> subject = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData().whenComplete(() {
      getSubject(course, widget.semester);
    });
  }

  Future getData() async {
    sp = await SharedPreferences.getInstance();
    fullcourse = sp.getString('course') ?? "";
    // print(fullcourse);
    course = fullcourse.substring(
        fullcourse.indexOf("(") + 1, fullcourse.indexOf(")"));
  }

  Future getSubject(
    String course_code,
    String semester,
  ) async {
    showDialog(
      context: context,
      builder: (context) => const LoadingDiologPage(),
    );
    Map data = {'course_code': course, 'semester': semester};
    print(data);
    try {
      var res = await http.post(
          // ignore: prefer_interpolation_to_compose_strings
          Uri.http(MyUrl.mainurl, MyUrl.suburl + "student_get_subject.php"),
          body: data);
      var jsondata = jsonDecode(res.body);
      if (jsondata['status'] == true) {
        Navigator.pop(context);
        subject.clear();

        for (int i = 0; i < jsondata["data"].length; i++) {
          StudentGetSubject sub = StudentGetSubject(
            subject_code: jsondata["data"][i]["subject_code"].toString(),
            subject_name: jsondata["data"][i]["subject_name"].toString(),
            course_code: jsondata["data"][i]["course_code"].toString(),
            semester: jsondata["data"][i]["semester"].toString(),
          );

          setState(() {
            subject.add(sub);
          });
        }
      } else {
        Navigator.pop(context);
        AwesomeDialog(
          context: context,
          dialogBackgroundColor: Theme.of(context).colorScheme.background,
          dialogType: DialogType.warning,
          headerAnimationLoop: false,
          animType: AnimType.topSlide,
          showCloseIcon: true,
          closeIcon: const Icon(Icons.close_fullscreen_outlined),
          title: 'Warning',
          desc: 'Subject Not Found',
          descTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          titleTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          buttonsTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          btnCancelOnPress: () {
            Navigator.pop(context);
          },
          onDismissCallback: (type) {
            debugPrint('Dialog Dismiss from callback $type');
          },
          btnOkOnPress: () {
            Navigator.pop(context);
          },
        ).show();
      }
    } catch (e) {
      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          Positioned(
            child: Column(
              children: [
                Container(
                  height: 120,
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
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                        title: Text(
                          'Select subject',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).colorScheme.background,
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
            padding: const EdgeInsets.only(
              top: 100,
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                  itemCount: subject.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentBottomNavigationBar(
                              semester: subject[index].semester,
                              subject_code: subject[index].subject_code,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: height * 0.08,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onBackground,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.menu_book,
                              color: Theme.of(context).colorScheme.background,
                            ),
                            title: Text(
                              subject[index].subject_name,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
