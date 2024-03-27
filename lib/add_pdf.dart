import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_2/constractor/course.dart';
import 'package:flutter_application_2/constractor/getSubjectCode.dart';
import 'package:flutter_application_2/loadingpage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_application_2/utils.dart';

class AddPDF extends StatefulWidget {
  const AddPDF({super.key});

  @override
  State<AddPDF> createState() => _AddPDFState();
}

class _AddPDFState extends State<AddPDF> {
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
      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: e.toString(),
      );
    }
  }

  Future AddSubjectNodes(
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
          "POST", Uri.parse("${MyUrl.fullurl}add_subject_nodes.php"));

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
        // ignore: use_build_context_synchronously
        AwesomeDialog(
          context: context,
          dialogBackgroundColor: Colors.white,
          animType: AnimType.leftSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.success,
          showCloseIcon: true,
          title: 'Succes',
          desc: 'nodes add successfull',
          btnOkOnPress: () {
            Navigator.pop(context);
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
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Upload Nodes',
            style: TextStyle(color: Colors.black),
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
                      hintStyle: const TextStyle(color: Colors.black),
                      labelStyle: const TextStyle(color: Colors.black),
                      prefixIcon: const Icon(Icons.school_outlined,
                          color: Colors.black),
                      contentPadding:
                          const EdgeInsets.only(left: 10, right: 10),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green),
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
                            style: const TextStyle(color: Colors.black),
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
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
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
                      hintStyle: const TextStyle(color: Colors.black),
                      labelStyle: const TextStyle(color: Colors.black),
                      prefixIcon: const Icon(Icons.school_outlined,
                          color: Colors.black),
                      contentPadding:
                          const EdgeInsets.only(left: 10, right: 10),
                      border: OutlineInputBorder(
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
                            style: const TextStyle(color: Colors.black),
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
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(color: Colors.red),
                      hintText: 'Select Subject Code',
                      labelText: 'Select Subject Code',
                      hintStyle: const TextStyle(color: Colors.black),
                      labelStyle: const TextStyle(color: Colors.black),
                      prefixIcon: const Icon(Icons.school_outlined,
                          color: Colors.black),
                      contentPadding:
                          const EdgeInsets.only(left: 10, right: 10),
                      border: OutlineInputBorder(
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
                            style: const TextStyle(color: Colors.black),
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
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.black),
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
                            icon: const Icon(
                              Icons.file_upload,
                              color: Colors.black,
                            )),
                        hintText: 'PDF File',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                              color: Colors.black,
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
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              AddSubjectNodes(
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
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
