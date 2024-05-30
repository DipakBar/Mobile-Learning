import 'dart:convert';
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_application_2/constractor/course.dart';
import 'package:flutter_application_2/constractor/subject.dart';
import 'package:flutter_application_2/loadingpage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_2/utils.dart';

class AddSubject extends StatefulWidget {
  const AddSubject({super.key});

  @override
  State<AddSubject> createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  List<subject> subjectList = [];
  bool show = true;
  String? selectedCourse;
  String? selectedCourseCode;
  String? selectSemester;
  String? Semester;

  List<String> concateList = [];
  TextEditingController subject_code = TextEditingController();
  TextEditingController subject_name = TextEditingController();
  TextEditingController updateSubjectCode = TextEditingController();
  TextEditingController updateSubjectName = TextEditingController();

  final form = GlobalKey<FormState>();
  List<String> SemesterList = ['1', '2', '3', '4', '5', '6', '7', '8'];
  Future getsubject() async {
    try {
      var response = await http.get(
        // ignore: prefer_interpolation_to_compose_strings
        Uri.parse(MyUrl.fullurl + "all_subject.php"),
      );
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == true) {
        subjectList.clear();
        for (int i = 0; i < jsondata["data"].length; i++) {
          subject databasedata = subject(
            subject_code: jsondata["data"][i]["subject_code"].toString(),
            subject_name: jsondata["data"][i]["subject_name"].toString(),
            course_code: jsondata["data"][i]["course_code"].toString(),
            course_name: jsondata["data"][i]["course_name"].toString(),
            semester: jsondata["data"][i]["semester"].toString(),
          );
          setState(() {
            subjectList.add(databasedata);
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

  Future getcourse() async {
    showDialog(
        context: context,
        builder: (context) => const LoadingDiologPage(),
        barrierDismissible: false);
    try {
      var response = await http.get(
        Uri.parse(MyUrl.fullurl + "all_course.php"),
      );
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == true) {
        concateList.clear();

        for (int i = 0; i < jsondata["data"].length; i++) {
          course stdentcode = course(
              course_id: jsondata["data"][i]["course_id"].toString(),
              course_name: jsondata["data"][i]["course_name"].toString(),
              course_code: jsondata["data"][i]["course_code"].toString());

          concateList
              .add(stdentcode.course_name + "(" + stdentcode.course_code + ")");
        }
      } else {
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future addSubject(
    String subject_code,
    String subject_name,
    String course_code,
    String semester,
  ) async {
    try {
      showDialog(
        context: context,
        builder: (context) => const LoadingDiologPage(),
      );
      var request = http.MultipartRequest(
          "POST",
          // ignore: prefer_interpolation_to_compose_strings
          Uri.http(MyUrl.mainurl, MyUrl.suburl + "add_subject.php"));

      request.fields['subject_code'] = subject_code;
      request.fields['subject_name'] = subject_name;
      request.fields['course_code'] = course_code;
      request.fields['semester'] = semester;

      var response = await request.send();
      var responded = await http.Response.fromStream(response);
      var jsondata = jsonDecode(responded.body);
      if (jsondata['status'] == true) {
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        AwesomeDialog(
          context: context,
          dialogBackgroundColor: Theme.of(context).colorScheme.background,
          dialogType: DialogType.success,
          headerAnimationLoop: false,
          animType: AnimType.bottomSlide,
          title: 'Success',
          titleTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          desc: 'Add Subject Successful',
          descTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          buttonsTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          showCloseIcon: false,
          btnOkOnPress: () {},
        ).show();
        // Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      // ignore: avoid_print

      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: e.toString(),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  Future DeleteSubject(
    String subject_code,
  ) async {
    try {
      showDialog(
        context: context,
        builder: (context) => const LoadingDiologPage(),
      );
      var request = http.MultipartRequest(
          "POST", Uri.http(MyUrl.mainurl, MyUrl.suburl + "delete_subject.php"));

      request.fields['subject_code'] = subject_code;

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
          desc: 'subject delete successfull',
          btnOkOnPress: () {
            Navigator.pop(context);
            // Navigator.pop(context);
          },
          btnOkIcon: Icons.check_circle,
          onDismissCallback: (type) {},
        ).show();
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

  Future<void> subjectUpdate(String old_subjectCode, String subject_code,
      String subject_name, String course_code, String semester) async {
    Map data = {
      'old_subjectCode': old_subjectCode,
      'subject_code': subject_code,
      'subject_name': subject_name,
      'course_code': course_code,
      'semester': semester
    };
    print(data);
    showDialog(
      context: context,
      builder: (context) => const LoadingDiologPage(),
    );

    try {
      var res = await http.post(
          Uri.http(MyUrl.mainurl, MyUrl.suburl + "subject_update.php"),
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
  void initState() {
    getsubject().whenComplete(() {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) async {
          getcourse().whenComplete(
            () {
              Navigator.pop(context);
              setState(() {});
              print(concateList);
            },
          );
        },
      );
    });

    super.initState();
  }

  updatepopupdialog(String subject_code, String course_name,
      String subject_name, String course_code, String semester) {
    updateSubjectCode.text = subject_code;
    updateSubjectName.text = subject_name;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateForDialog) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.background,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                scrollable: true,
                title: Text(
                  'Update subject',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  textAlign: TextAlign.center,
                ),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                      child: TextField(
                        controller: updateSubjectCode,
                        showCursor: true,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.code_sharp,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          labelText: 'subject code',
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onBackground,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                width: 1),
                          ),
                        ),
                        onChanged: (value) {
                          updateSubjectCode.text = value.toString();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: updateSubjectName,
                        showCursor: true,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.batch_prediction,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          labelText: 'subject name',
                          // hintText: subject_name,
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onBackground,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onBackground,
                              width: 1,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          updateSubjectName.text = value.toString();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        errorStyle: const TextStyle(color: Colors.red),
                        hintText: 'Select course',
                        labelText: course_name,
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        prefixIcon: Icon(
                          Icons.school_outlined,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        contentPadding:
                            const EdgeInsets.only(left: 10, right: 10),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      value: concateList.contains(selectedCourseCode)
                          ? selectedCourseCode
                          : null,
                      items: concateList.map(
                        (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        setState(() {
                          String s = value.toString();
                          selectedCourseCode =
                              s.substring(s.indexOf("(") + 1, s.indexOf(")"));
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Field required' : null,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        errorStyle: const TextStyle(color: Colors.red),
                        hintText: 'select semester',
                        labelText: semester,
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        prefixIcon: Icon(
                          Icons.school_outlined,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        contentPadding:
                            const EdgeInsets.only(left: 10, right: 10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      value: SemesterList.contains(Semester) ? Semester : null,
                      items: SemesterList.map(
                        (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        setState(() {
                          Semester = value.toString();
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Field required' : null,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        if (updateSubjectCode.text == subject_code &&
                            updateSubjectName.text == subject_name) {
                          Fluttertoast.showToast(msg: 'Not update');
                          Navigator.pop(context);
                        } else {
                          subjectUpdate(
                                  subject_code,
                                  updateSubjectCode.text,
                                  updateSubjectName.text,
                                  selectedCourseCode.toString(),
                                  semester.toString())
                              .whenComplete(() {
                            getsubject();
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(children: [
        Container(
          color: Colors.lightBlue,
          height: 80,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      size: 25,
                      Icons.arrow_back,
                      color: Theme.of(context).colorScheme.background,
                    )),
                Text(
                  'ADD SUBJECT',
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
                SizedBox(
                  width: 50,
                )
              ],
            ),
          ),
        ),
        subjectList.isNotEmpty
            ? Expanded(
                child: Container(
                  height: size.height,
                  width: size.width,
                  child: Scrollbar(
                    child: ListView.builder(
                      itemCount: subjectList.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        String coursename =
                            '${subjectList[index].course_name}(${subjectList[index].course_code})';

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
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
                                    'Course Name: ${coursename}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                  ),
                                  Text(
                                    'Subject name: ${subjectList[index].subject_name}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                  ),
                                  Text(
                                    'Subject code: ${subjectList[index].subject_code}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                  ),
                                  Text(
                                    'Semester: ${subjectList[index].semester}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .surface),
                                          onPressed: () {
                                            updatepopupdialog(
                                              subjectList[index].subject_code,
                                              subjectList[index].course_name,
                                              subjectList[index].subject_name,
                                              subjectList[index].course_code,
                                              subjectList[index].semester,
                                            );
                                          },
                                          child: Text(
                                            "Update",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .surface),
                                          onPressed: () {
                                            AwesomeDialog(
                                              context: context,
                                              dialogBackgroundColor:
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .background,
                                              dialogType: DialogType.warning,
                                              headerAnimationLoop: false,
                                              animType: AnimType.bottomSlide,
                                              title: 'Delete',
                                              desc: 'Do you to delete?',
                                              titleTextStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                              ),
                                              descTextStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                              ),
                                              buttonsTextStyle: const TextStyle(
                                                  color: Colors.black),
                                              showCloseIcon: true,
                                              btnCancelOnPress: () {},
                                              btnOkOnPress: () {
                                                DeleteSubject(subjectList[index]
                                                        .subject_code)
                                                    .whenComplete(() {
                                                  getsubject();
                                                });
                                              },
                                            ).show();
                                          },
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
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
                        );
                      },
                    ),
                  ),
                ),
              )
            : Visibility(
                visible: show,
                child: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitFadingCircle(
                        color: Theme.of(context).colorScheme.onBackground,
                        size: 90,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Loading....",
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.surface,
        icon: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: AlertDialog(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  title: Center(
                    child: Text(
                      'Add Subject',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                  content: Form(
                    key: form,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                errorStyle: const TextStyle(color: Colors.red),
                                hintText: 'Select Course',
                                labelText: 'Select Course',
                                hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                labelStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                prefixIcon: Icon(
                                  Icons.school_outlined,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                contentPadding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              value: concateList.contains(selectedCourse)
                                  ? selectedCourse
                                  : null,
                              items: concateList.map(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                              onChanged: (value) {
                                setState(() {
                                  String s = value.toString();
                                  selectedCourse = s.substring(
                                      s.indexOf("(") + 1, s.indexOf(")"));
                                  print(selectedCourse);
                                });
                              },
                              validator: (value) =>
                                  value == null ? 'Field required' : null,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.red),
                                prefixIcon: Icon(
                                  Icons.subject_sharp,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    width: 3,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      width: 3),
                                ),
                                hintText: 'Enter Subject Name',
                                hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ),
                              controller: subject_name,
                              validator: (value) {
                                if (value == '') {
                                  return 'Name Required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                errorStyle: const TextStyle(color: Colors.red),
                                prefixIcon: Icon(
                                  Icons.subject_sharp,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      width: 3),
                                ),
                                hintText: 'Enter Subject Code',
                                hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ),
                              controller: subject_code,
                              validator: (value) {
                                if (value == '') {
                                  return 'code Required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                errorStyle: const TextStyle(color: Colors.red),
                                hintText: 'Select semester',
                                labelText: 'Select semester',
                                hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                labelStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                prefixIcon: Icon(
                                  Icons.school_outlined,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                contentPadding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              value: SemesterList.contains(selectSemester)
                                  ? selectSemester
                                  : null,
                              items: SemesterList.map(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectSemester = value.toString();
                                });
                              },
                              validator: (value) =>
                                  value == null ? 'Field required' : null,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        subject_name.clear();
                        subject_code.clear();
                        selectedCourse = "";
                        selectSemester = '';
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (form.currentState!.validate()) {
                          if (subject_name.text.isNotEmpty &&
                              subject_code.text.isNotEmpty &&
                              selectedCourse.toString().isNotEmpty &&
                              selectSemester.toString().isNotEmpty) {
                            Navigator.pop(context);
                            addSubject(
                              subject_code.text,
                              subject_name.text,
                              selectedCourse.toString(),
                              selectSemester.toString(),
                            ).whenComplete(() {
                              getsubject();
                            });
                          }
                        }
                        subject_name.clear();
                        subject_code.clear();
                        selectSemester = '';
                        selectedCourse = '';
                      },
                      child: Text(
                        'Add',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        label: Text(
          'Add  Subject',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
