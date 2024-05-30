import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_2/addSubjectNode/upload_pdf.dart';
import 'package:flutter_application_2/constractor/course.dart';
import 'package:flutter_application_2/constractor/getSubjectCode.dart';
import 'package:flutter_application_2/loadingpage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_2/utils.dart';

class UpdatePDF extends StatefulWidget {
  final String id;
  final String course;
  final String semester;
  final String subject_code;
  final String file;
  UpdatePDF(
      {required this.id,
      required this.semester,
      required this.subject_code,
      required this.course,
      required this.file});

  @override
  State<UpdatePDF> createState() => _UpdatePDFState();
}

class _UpdatePDFState extends State<UpdatePDF> {
  File? pickedFile;
  String? selectedCourse;
  String? selectSemester;
  String? selectedSubjectCode;
  TextEditingController PDFfile = TextEditingController();

  List<String> subjectcode = [];
  List<String> concateList = [];
  List<String> SemesterList = ['1', '2', '3', '4', '5', '6', '7', '8'];
  bool _isMounted = false;

  @override
  void dispose() {
    _isMounted = false; // Set _isMounted to false when the widget is disposed
    super.dispose();
  }

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
      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: e.toString(),
      );
    }
  }

  Future UpdateNotes(
    String id,
    String courseCode,
    String subjectCode,
    String semester,
    File? SubjectNode,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDiologPage();
      },
    );
    try {
      var request = http.MultipartRequest(
          "POST", Uri.parse("${MyUrl.fullurl}update_subject_notes.php"));
      request.fields["id"] = id;
      request.fields["course_code"] = courseCode;
      request.fields["subject_code"] = subjectCode;
      request.fields["semester"] = semester;

      request.files.add(await http.MultipartFile.fromBytes(
          "subject_pdf", SubjectNode!.readAsBytesSync(),
          filename: SubjectNode.path.split("/").last));
      var response = await request.send();
      var responded = await http.Response.fromStream(response);
      var jsondata = jsonDecode(responded.body);

      if (jsondata['status'] == true) {
        AwesomeDialog(
          context: context,
          dialogBackgroundColor: Theme.of(context).colorScheme.background,
          titleTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          descTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          animType: AnimType.leftSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.success,
          showCloseIcon: true,
          title: 'Succes',
          desc: 'nodes update successfull',
          btnOkOnPress: () {
            if (_isMounted) {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => UploadPDF()));
            }
          },
          btnOkIcon: Icons.check_circle,
          onDismissCallback: (type) {},
        ).show();

        if (_isMounted) {
          setState(() {});
        }
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: e.toString(),
      );
      print(e.toString());
    }
  }

  @override
  void initState() {
    _isMounted = true;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        getcourse().whenComplete(
          () {
            Navigator.pop(context);
            setState(() {
              print(widget.course);
              print(widget.semester);
              print(widget.subject_code);
              print(widget.file);
            });
          },
        );
      },
    );

    super.initState();
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
        title: Center(
          child: Text(
            'Upload Notes',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            ),
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
                    value: concateList.contains(widget.course)
                        ? widget.course
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
                        print(selectedCourse);
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
                    value: SemesterList.contains(widget.semester)
                        ? widget.semester
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
                        //
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
                    value: subjectcode.contains(widget.subject_code)
                        ? widget.subject_code
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
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground),
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
                        hintText: widget.file,
                        hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground),
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
              Navigator.of(context).pop();
              selectedCourse = '';
              selectSemester = '';
              selectedSubjectCode = '';
              SemesterList.clear();
              concateList.clear();
              subjectcode.clear();
              PDFfile.clear();
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
              String CourseCode = widget.course.substring(
                  widget.course.indexOf("(") + 1, widget.course.indexOf(")"));

              if (PDFfile.text.isNotEmpty) {
                if (selectedCourse != CourseCode &&
                    selectSemester != widget.semester &&
                    selectedSubjectCode != widget.subject_code &&
                    PDFfile.text.isNotEmpty) {
                  print(widget.id);
                  print(CourseCode);
                  print(widget.semester);
                  print(widget.subject_code);
                  Fluttertoast.showToast(msg: 'You can only change notes');
                  // UpdateNotes(widget.id, CourseCode.toString(),
                  //     widget.subject_code, widget.semester, pickedFile);
                }
                //  else if (selectedCourse != CourseCode &&
                //     selectSemester != widget.semester &&
                //     selectedSubjectCode != widget.subject_code &&
                //     PDFfile.text.isNotEmpty) {
                //   Fluttertoast.showToast(msg: 'You can only change notes');
                // }
                else {
                  print(CourseCode);
                  print(widget.semester);
                  print(widget.subject_code);
                  print(widget.id);
                  // UpdateNotes(widget.id, CourseCode.toString(),
                  //     widget.subject_code, widget.semester, pickedFile);
                }
              } else {
                Fluttertoast.showToast(msg: 'Provide Notes');
              }
            },
            child: Text(
              'Ok',
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
