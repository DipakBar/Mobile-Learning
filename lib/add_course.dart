import 'dart:convert';
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/constractor/course.dart';

import 'package:flutter_application_2/loadingpage.dart';
import 'package:flutter_application_2/utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

class AddCourse extends StatefulWidget {
  // const AddCourse({super.key});

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  TextEditingController courseName = TextEditingController();
  TextEditingController courseCode = TextEditingController();
  TextEditingController editcourseName = TextEditingController();
  TextEditingController editcourseCode = TextEditingController();
  bool iscourseCorrect = false;
  String courseid = '';
  List<course> courselist = [];
  bool show = true;
  Future getcourse() async {
    try {
      var response = await http.get(
        Uri.parse(MyUrl.fullurl + "all_course.php"),
      );
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == true) {
        courselist.clear();
        // courseidlist.clear();
        for (int i = 0; i < jsondata["data"].length; i++) {
          course databasedata = course(
              course_id: jsondata["data"][i]["course_id"].toString(),
              course_name: jsondata["data"][i]["course_name"].toString(),
              course_code: jsondata["data"][i]["course_code"].toString());
          setState(() {
            courselist.add(databasedata);
          });
        }
      } else {
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
        show = false;
        setState(() {});
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  Future AddCourse(
    String courseName,
    String courseCode,
  ) async {
    try {
      print(courseName);
      print(courseCode);
      showDialog(
        context: context,
        builder: (context) => const LoadingDiologPage(),
      );
      var request = http.MultipartRequest(
          "POST", Uri.http(MyUrl.mainurl, MyUrl.suburl + "add_course.php"));

      request.fields['coursename'] = courseName;
      request.fields['coursecode'] = courseCode;

      var response = await request.send();
      var responded = await http.Response.fromStream(response);
      var jsondata = jsonDecode(responded.body);
      if (jsondata['status'] == true) {
        // ignore: use_build_context_synchronously
        AwesomeDialog(
          context: context,
          dialogBackgroundColor: Colors.white,
          animType: AnimType.leftSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.success,
          showCloseIcon: true,
          title: 'Succes',
          desc: 'Course add successfull',
          btnOkOnPress: () {
            Navigator.pop(context);
            // Navigator.pop(context);
          },
          btnOkIcon: Icons.check_circle,
          onDismissCallback: (type) {
            // debugPrint('Dialog Dissmiss from callback $type');
          },
        ).show();
        // Navigator.pop(context);
        setState(() {});
      } else {
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
        Navigator.pop(context);
      }
    } catch (e) {
      // Navigator.of(context).pop();
      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: e.toString(),
      );
    }
  }

  Future DeleteCourse(
    String courseId,
  ) async {
    try {
      showDialog(
        context: context,
        builder: (context) => const LoadingDiologPage(),
      );
      var request = http.MultipartRequest(
          "POST", Uri.http(MyUrl.mainurl, MyUrl.suburl + "delete_course.php"));

      request.fields['courseid'] = courseId;

      var response = await request.send();
      var responded = await http.Response.fromStream(response);
      var jsondata = jsonDecode(responded.body);
      if (jsondata['status'] == true) {
        // ignore: use_build_context_synchronously
        AwesomeDialog(
          context: context,
          dialogBackgroundColor: Colors.white,
          animType: AnimType.leftSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.success,
          showCloseIcon: true,
          title: 'Succes',
          desc: 'Course delete successfull',
          btnOkOnPress: () {
            Navigator.pop(context);
            // Navigator.pop(context);
          },
          btnOkIcon: Icons.check_circle,
          onDismissCallback: (type) {
            // debugPrint('Dialog Dissmiss from callback $type');
          },
        ).show();
      } else {
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
        Navigator.pop(context);
      }
    } catch (e) {
      // Navigator.of(context).pop();
      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: e.toString(),
      );
    }
  }

  Future<void> courseUpdate(
      String courseid, String coursename, String coursecode) async {
    Map data = {
      'coursename': coursename,
      'coursecode': coursecode,
      'courseid': courseid
    };

    showDialog(
      context: context,
      builder: (context) => const LoadingDiologPage(),
    );

    try {
      var res = await http.post(
          Uri.http(MyUrl.mainurl, MyUrl.suburl + "course_update.php"),
          body: data);

      var jsondata = jsonDecode(res.body);
      if (jsondata['status'] == true) {
        Navigator.pop(context);
        Navigator.pop(context);
        setState(() {});
        // ignore: use_build_context_synchronously
        AwesomeDialog(
          context: context,
          dialogBackgroundColor: Colors.white,
          dialogType: DialogType.success,
          headerAnimationLoop: false,
          animType: AnimType.bottomSlide,
          title: 'Success',
          titleTextStyle: const TextStyle(color: Colors.black),
          desc: 'Update Successful',
          descTextStyle: const TextStyle(color: Colors.black),
          buttonsTextStyle: const TextStyle(color: Colors.black),
          showCloseIcon: false,
          btnOkOnPress: () {},
        ).show();
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  void dispose() {
    courseName.dispose();
    super.dispose();
  }

  Future<void> courseNameUpdate(
    String courseid,
    String coursename,
  ) async {
    Map data = {'coursename': coursename, 'courseid': courseid};

    showDialog(
      context: context,
      builder: (context) => const LoadingDiologPage(),
    );
    try {
      var res = await http.post(
          Uri.http(MyUrl.mainurl, MyUrl.suburl + "course_name_update.php"),
          body: data);

      var jsondata = jsonDecode(res.body);
      if (jsondata['status'] == true) {
        Navigator.pop(context);
        Navigator.pop(context);
        // details.email = jsondata["email"].toString();

        setState(() {});

        // ignore: use_build_context_synchronously
        AwesomeDialog(
          context: context,
          dialogBackgroundColor: Colors.white,
          dialogType: DialogType.success,
          headerAnimationLoop: false,
          animType: AnimType.bottomSlide,
          title: 'Success',
          titleTextStyle: const TextStyle(color: Colors.black),
          desc: 'Update Successful',
          descTextStyle: const TextStyle(color: Colors.black),
          buttonsTextStyle: const TextStyle(color: Colors.black),
          showCloseIcon: false,
          btnOkOnPress: () {},
        ).show();
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> courseCodeUpdate(String courseid, String coursecode) async {
    Map data = {'coursecode': coursecode, 'courseid': courseid};

    showDialog(
      context: context,
      builder: (context) => const LoadingDiologPage(),
    );
    try {
      var res = await http.post(
          // ignore: prefer_interpolation_to_compose_strings
          Uri.http(MyUrl.mainurl, MyUrl.suburl + "course_code_update.php"),
          body: data);

      var jsondata = jsonDecode(res.body);
      if (jsondata['status'] == true) {
        Navigator.pop(context);
        Navigator.pop(context);
        setState(() {});

        // ignore: use_build_context_synchronously
        AwesomeDialog(
          context: context,
          dialogBackgroundColor: Colors.white,
          dialogType: DialogType.success,
          headerAnimationLoop: false,
          animType: AnimType.bottomSlide,
          title: 'Success',
          titleTextStyle: const TextStyle(color: Colors.black),
          desc: 'Update Successful',
          descTextStyle: const TextStyle(color: Colors.black),
          buttonsTextStyle: const TextStyle(color: Colors.black),
          showCloseIcon: false,
          btnOkOnPress: () {},
        ).show();
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  updatepopupdialog(String c_id, String c_name, String c_code) {
    editcourseName.text = c_name;
    editcourseCode.text = c_code;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateForDialog) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                scrollable: true,
                title: const Text(
                  'Update course',
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: editcourseName,
                        showCursor: true,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.batch_prediction,
                              color: Colors.black,
                            ),
                            labelText: 'course name',
                            labelStyle: const TextStyle(color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1))),
                        onChanged: (value) {
                          editcourseName.text = value.toString();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: TextField(
                        controller: editcourseCode,
                        showCursor: true,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.code_sharp,
                            color: Colors.black,
                          ),
                          labelText: 'course code',
                          // hintText: c_code,
                          labelStyle: const TextStyle(color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                const BorderSide(color: Colors.black, width: 1),
                          ),
                        ),
                        onChanged: (value) {
                          editcourseCode.text = value.toString();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        if (editcourseName.text != c_name &&
                            editcourseCode.text == c_code) {
                          print('name');
                          courseNameUpdate(c_id, editcourseName.text)
                              .whenComplete(() {
                            getcourse();
                          });
                        } else if (editcourseName.text == c_name &&
                            editcourseCode.text != c_code) {
                          print('code');
                          courseCodeUpdate(c_id, editcourseCode.text)
                              .whenComplete(() {
                            getcourse();
                          });
                        } else if (editcourseCode.text == c_code &&
                            editcourseName.text == c_name) {
                          Fluttertoast.showToast(msg: 'no update');
                          Navigator.pop(context);
                        } else {
                          print('else');
                          courseUpdate(c_id, editcourseName.text,
                                  editcourseCode.text)
                              .whenComplete(() {
                            getcourse();
                          });
                        }
                        editcourseCode.clear();
                        editcourseName.clear();
                        // }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  popupdialog() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setStateForDialog) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                scrollable: true,
                title: const Text(
                  'Add course',
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: courseName,
                        showCursor: true,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.batch_prediction,
                              color: Colors.black,
                            ),
                            labelText: 'course name',
                            labelStyle: const TextStyle(color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1))),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: TextField(
                        controller: courseCode,
                        showCursor: true,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.code_sharp,
                              color: Colors.black,
                            ),
                            labelText: 'course code',
                            labelStyle: const TextStyle(color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 1))),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        if (courseName.text.isEmpty) {
                          AwesomeDialog(
                            context: context,
                            dialogBackgroundColor: Colors.white,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            headerAnimationLoop: false,
                            title: 'ERROR',
                            desc: 'Provide Course Name',
                            btnOkOnPress: () {},
                            btnOkIcon: Icons.cancel,
                            btnOkColor: Colors.red,
                          ).show();
                        } else if (courseCode.text.isEmpty) {
                          AwesomeDialog(
                            context: context,
                            dialogBackgroundColor: Colors.white,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            headerAnimationLoop: false,
                            title: 'ERROR',
                            desc: 'Provide Course Code',
                            btnOkOnPress: () {},
                            btnOkIcon: Icons.cancel,
                            btnOkColor: Colors.red,
                          ).show();
                        } else {
                          AddCourse(courseName.text, courseCode.text)
                              .whenComplete(() {
                            getcourse();
                          });

                          courseCode.clear();
                          courseName.clear();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  @override
  void initState() {
    getcourse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('ADD COURSE')),
        body: courselist.isNotEmpty
            ? Container(
                height: size.height,
                width: size.width,
                child: Scrollbar(
                  child: ListView.builder(
                    itemCount: courselist.length,
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 5),
                                color: Colors.blue.withOpacity(.5),
                                spreadRadius: 2,
                                blurRadius: 8,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'course id: ${courselist[index].course_id}',
                                  style: const TextStyle(color: Colors.black),
                                ),
                                Text(
                                  'course name: ${courselist[index].course_name}',
                                  style: const TextStyle(color: Colors.black),
                                ),
                                Text(
                                  'course code: ${courselist[index].course_code}',
                                  style: const TextStyle(color: Colors.black),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          updatepopupdialog(
                                              courselist[index].course_id,
                                              courselist[index].course_name,
                                              courselist[index].course_code);
                                        },
                                        child: const Text(
                                          "update",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          AwesomeDialog(
                                            context: context,
                                            dialogBackgroundColor: Colors.white,
                                            dialogType: DialogType.warning,
                                            headerAnimationLoop: false,
                                            animType: AnimType.bottomSlide,
                                            title: 'Delete',
                                            desc: 'Do you to delete?',
                                            buttonsTextStyle: const TextStyle(
                                                color: Colors.black),
                                            showCloseIcon: true,
                                            btnCancelOnPress: () {},
                                            btnOkOnPress: () {
                                              DeleteCourse(courselist[index]
                                                      .course_id)
                                                  .whenComplete(() {
                                                getcourse();
                                              });
                                            },
                                          ).show();
                                        },
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            : Visibility(
                visible: show,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFadingCircle(
                      color: Colors.black,
                      size: 90,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Loading....",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    )
                  ],
                ),
              ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text(
            'Add Course',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.purple,
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () async {
            popupdialog();
          },
        ),
      ),
    );
  }
}
