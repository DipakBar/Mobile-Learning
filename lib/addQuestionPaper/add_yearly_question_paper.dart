// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, non_constant_identifier_names
import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_application_2/utils.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_application_2/loadingpage.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:flutter_application_2/constractor/course.dart';
import 'package:flutter_application_2/constractor/getSubjectCode.dart';
import 'package:flutter_application_2/addQuestionPaper/upload_yearly_question_paper.dart';

class AddQuestionPaper extends StatefulWidget {
  const AddQuestionPaper({super.key});

  @override
  State<AddQuestionPaper> createState() => _AddQuestionPaperState();
}

class _AddQuestionPaperState extends State<AddQuestionPaper> {
  File? pickedFile;
  String? selectedCourse;
  String? selectSemester;
  String? selectedSubjectCode;
  TextEditingController PDFfile = TextEditingController();

  List<String> subjectcode = [];
  List<String> concateList = [];
  List<String> SemesterList = ['1', '2', '3', '4', '5', '6', '7', '8'];

  Future getcourse() async {
    showDialog(
      context: context,
      builder: (context) => const LoadingDiologPage(),
    );
    try {
      var response = await http.get(
        Uri.parse(MyUrl.fullurl + "all_course.php"),
      );
      var jsondata = jsonDecode(response.body);
      concateList.clear();
      if (jsondata["status"] == true) {
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

  Future getsubjectcode(
    String course_code,
    String sem,
  ) async {
    try {
      showDialog(
        context: context,
        builder: (context) => const LoadingDiologPage(),
      );
      var request = http.MultipartRequest("POST",
          Uri.http(MyUrl.mainurl, MyUrl.suburl + "get_subject_code.php"));

      request.fields['course_code'] = course_code;
      request.fields['semester'] = sem;
      var response = await request.send();
      var responded = await http.Response.fromStream(response);
      var jsondata = jsonDecode(responded.body);
      if (jsondata['status'] == true) {
        Navigator.pop(context);
        for (int i = 0; i < jsondata["data"].length; i++) {
          getSubjectCode subcode = getSubjectCode(
            subjectCode: jsondata["data"][i]["subject_code"].toString(),
          );
          subjectcode.add(subcode.subjectCode);
          setState(() {});
          print(subjectcode);
        }
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: e.toString(),
      );
    }
  }

  Future AddQuestionPaper(
    String courseCode,
    String subjectCode,
    String semester,
    File? question_paper,
  ) async {
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (context) {
    //     return const LoadingDiologPage();
    //   },
    // );
    // try {
    //   var request = http.MultipartRequest(
    //       "POST", Uri.parse("${MyUrl.fullurl}add_question_paper.php"));

    //   request.fields["course_code"] = courseCode;
    //   request.fields["subject_code"] = subjectCode;
    //   request.fields["semester"] = semester;

    //   request.files.add(await http.MultipartFile.fromBytes(
    //       "question_paper", question_paper!.readAsBytesSync(),
    //       filename: question_paper.path.split("/").last));

    //   var response = await request.send();
    //   var responded = await http.Response.fromStream(response);
    //   var jsondata = jsonDecode(responded.body);

    //   if (jsondata['status'] == true) {
    //     // ignore: use_build_context_synchronously
    //     AwesomeDialog(
    //       context: context,
    //       dialogBackgroundColor: Theme.of(context).colorScheme.background,
    //       animType: AnimType.leftSlide,
    //       headerAnimationLoop: false,
    //       dialogType: DialogType.success,
    //       showCloseIcon: true,
    //       title: 'Succes',
    //       desc: 'question paper add successfull',
    //       titleTextStyle: TextStyle(
    //         color: Theme.of(context).colorScheme.onBackground,
    //       ),
    //       descTextStyle: TextStyle(
    //         color: Theme.of(context).colorScheme.onBackground,
    //       ),
    //       btnOkOnPress: () {
    //         Navigator.pop(context);
    //         // Navigator.pop(context);
    //         Navigator.pushReplacement(
    //             context,
    //             MaterialPageRoute(
    //                 builder: (context) => UploadYearlyQuestionPager()));
    //       },
    //       btnOkIcon: Icons.check_circle,
    //       onDismissCallback: (type) {},
    //     ).show();

    //     setState(() {});
    //   } else {
    //     Fluttertoast.showToast(
    //       gravity: ToastGravity.CENTER,
    //       msg: jsondata['msg'],
    //     );
    //     Navigator.pop(context);
    //   }
    // } catch (e) {
    //   Fluttertoast.showToast(
    //     gravity: ToastGravity.CENTER,
    //     msg: e.toString(),
    //   );
    // }
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
      max: 100,
      msg: 'Uploading...',
      progressType: ProgressType.valuable,
      backgroundColor: const Color(0xff212121),
      progressValueColor: const Color(0xff3550B4),
      progressBgColor: Colors.white70,
      msgColor: Colors.white,
      valueColor: Colors.white,
    );

    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        "course_code": courseCode,
        "subject_code": subjectCode,
        "semester": semester,
        "question_paper": await MultipartFile.fromFile(
          question_paper!.path,
          filename: question_paper.path.split('/').last,
        ),
      });

      var response = await dio.post(
        "${MyUrl.fullurl}add_question_paper.php",
        data: formData,
        onSendProgress: (int sent, int total) {
          double percentage = (sent / total * 100);
          pd.update(value: percentage.toInt());
          print("Progress: $sent / $total ($percentage%)");
        },
      );
      var jsondata = jsonDecode(response.toString());
      if (jsondata['status'] == true) {
        pd.close();
        AwesomeDialog(
          context: context,
          dialogBackgroundColor: Theme.of(context).colorScheme.background,
          animType: AnimType.leftSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.success,
          showCloseIcon: true,
          title: 'Success',
          titleTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          desc: 'Notes add successful',
          descTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          buttonsTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          btnOkOnPress: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => UploadYearlyQuestionPager()));
          },
          btnOkIcon: Icons.check_circle,
          onDismissCallback: (type) {},
        ).show();
      } else {
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      pd.close(); // Close the progress dialog on error
      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: e.toString(),
      );
      if (kDebugMode) {
        print(
          e.toString(),
        );
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        getcourse().whenComplete(
          () {
            Navigator.pop(context);
            setState(() {});
          },
        );
      },
    );

    super.initState();
  }

  void Dispose() {
    PDFfile.clear();
    super.dispose();
  }

  pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result == null) return;
      File tempFile = File(result.files.single.path!);
      setState(() {
        pickedFile = tempFile;
        var pickName = result.files.single.name;
        PDFfile.text = pickName.toString();
      });
      // Get.back();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'Upload question paper',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        content: Form(
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
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      setState(() {
                        String s = value.toString();
                        selectedCourse =
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
                      hintText: 'Select semester',
                      labelText: 'Select semester',
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
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectSemester = value.toString();
                        if (selectSemester.toString().isNotEmpty &&
                            selectedCourse.toString().isNotEmpty) {
                          getsubjectcode(selectedCourse.toString(),
                              selectSemester.toString());
                        } else {
                          Fluttertoast.showToast(msg: 'provide the details');
                        }
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
                      hintText: 'Select Subject Code',
                      labelText: 'Select Subject Code',
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
                    ),
                    value: subjectcode.contains(selectedSubjectCode.toString())
                        ? selectedSubjectCode
                        : null,
                    items: subjectcode.map(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSubjectCode = value.toString();
                        print(selectedSubjectCode);
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
                  TextFormField(
                    validator: (value) {
                      if (value == '') {
                        return 'Required';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: PDFfile,
                    decoration: InputDecoration(
                        errorStyle: const TextStyle(color: Colors.red),
                        suffixIcon: IconButton(
                            onPressed: () async {
                              pickFile();
                            },
                            icon: Icon(
                              Icons.file_upload,
                              color: Theme.of(context).colorScheme.onBackground,
                            )),
                        hintText: 'PDF File',
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onBackground,
                            ))),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              selectedCourse = '';
              selectSemester = '';
              selectedSubjectCode = '';
              SemesterList.clear();
              concateList.clear();
              subjectcode.clear();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UploadYearlyQuestionPager()));
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
              AddQuestionPaper(
                      selectedCourse.toString(),
                      selectedSubjectCode.toString(),
                      selectSemester.toString(),
                      pickedFile)
                  .whenComplete(() {
                selectedCourse = '';
                selectSemester = '';
                selectedSubjectCode = '';
                SemesterList.clear();
                concateList.clear();
                subjectcode.clear();
                PDFfile.clear();
              });
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
  }
}
