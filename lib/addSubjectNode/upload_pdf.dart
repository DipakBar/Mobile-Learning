import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_2/addSubjectNode/add_pdf.dart';
import 'package:flutter_application_2/addSubjectNode/updatePDF.dart';
import 'package:flutter_application_2/addSubjectNode/view_subject_nodes.dart';
import 'package:flutter_application_2/constractor/pdf.dart';
import 'package:flutter_application_2/loadingpage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_2/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UploadPDF extends StatefulWidget {
  const UploadPDF({super.key});

  @override
  State<UploadPDF> createState() => _UploadPDFState();
}

class _UploadPDFState extends State<UploadPDF> {
  List<SubjectNodes> learningPDF = [];
  bool show = true;
  bool _isMounted = false;
  Future DeleteSubjectNode(
    String id,
  ) async {
    try {
      showDialog(
        context: context,
        builder: (context) => const LoadingDiologPage(),
      );
      var request = http.MultipartRequest("POST",
          Uri.http(MyUrl.mainurl, MyUrl.suburl + "delete_subject_nodes.php"));

      request.fields['id'] = id;
      var response = await request.send();
      var responded = await http.Response.fromStream(response);
      var jsondata = jsonDecode(responded.body);
      if (jsondata['status'] == true) {
        // ignore: use_build_context_synchronously
        AwesomeDialog(
          context: context,
          dialogBackgroundColor: Theme.of(context).colorScheme.background,
          animType: AnimType.leftSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.success,
          showCloseIcon: true,
          title: 'Succes',
          desc: 'subject delete successfull',
          titleTextStyle:
              TextStyle(color: Theme.of(context).colorScheme.onBackground),
          descTextStyle:
              TextStyle(color: Theme.of(context).colorScheme.onBackground),
          btnOkOnPress: () {
            Navigator.pop(context);
          },
          btnOkIcon: Icons.check_circle,
          onDismissCallback: (type) {},
        ).show();
        setState(() {});
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      // Navigator.of(context).pop();
      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: e.toString(),
      );
    }
  }

  Future getSubjectNodes() async {
    try {
      var response = await http.get(
        Uri.parse(MyUrl.fullurl + "get_subject_nodes.php"),
      );
      var jsondata = jsonDecode(response.body);
      learningPDF.clear();
      if (jsondata["status"] == true) {
        for (int i = 0; i < jsondata["data"].length; i++) {
          SubjectNodes data = SubjectNodes(
            id: jsondata["data"][i]["id"].toString(),
            course_name: jsondata["data"][i]["course_name"].toString(),
            subject_name: jsondata["data"][i]["subject_name"].toString(),
            course_code: jsondata["data"][i]["course_code"].toString(),
            subject_code: jsondata["data"][i]["subject_code"].toString(),
            semester: jsondata["data"][i]["semester"].toString(),
            subject_nodes: jsondata["data"][i]["subject_pdf"].toString(),
            question_paper: jsondata["data"][i]["question_paper"].toString(),
            topic_video: jsondata["data"][i]["video"].toString(),
          );

          setState(() {
            if (data.subject_nodes != 'NA') learningPDF.add(data);
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
      print(e);
      Fluttertoast.showToast(
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
              // Navigator.pop(context);
              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (context) => UploadPDF()));
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
    getSubjectNodes();
    // TODO: implement initState
    super.initState();
  }

  TextEditingController coursename = TextEditingController();
  TextEditingController subjectname = TextEditingController();
  TextEditingController Semester = TextEditingController();
  TextEditingController PDFfile = TextEditingController();
  File? pickedFile;
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

  updatepopupdialog(String id, String course_name, String course_code,
      String subject_name, String subject_code, String semester, String note) {
    coursename.text = course_name;
    subjectname.text = subject_name;
    Semester.text = semester;
    PDFfile.text = note;
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
                  'Update Note',
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
                        enabled: false,
                        controller: coursename,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              )),
                          prefixIcon: Icon(
                            Icons.school_outlined,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          labelText: 'Course Name',
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: TextField(
                        enabled: false,
                        controller: subjectname,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              )),
                          prefixIcon: Icon(
                            Icons.school_outlined,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          labelText: 'Subject Name',
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: TextField(
                        enabled: false,
                        controller: Semester,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              )),
                          prefixIcon: Icon(
                            Icons.school_outlined,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          labelText: 'Semester',
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 70,
                            child: TextFormField(
                              enabled: false,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                              validator: (value) {
                                if (value == '') {
                                  return 'Required';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: PDFfile,
                              decoration: InputDecoration(
                                labelText: 'Note Name',
                                labelStyle: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                                errorStyle: const TextStyle(color: Colors.red),
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              pickFile();
                            },
                            icon: Icon(
                              Icons.upload_file,
                              color: Theme.of(context).colorScheme.onBackground,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        if (pickedFile != null) {
                          UpdateNotes(id, course_code.toString(), subject_code,
                                  semester, pickedFile)
                              .whenComplete(() {
                            getSubjectNodes();
                          });
                        } else {
                          Fluttertoast.showToast(msg: "Provide Note");
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
                  'UPLOAD SUBJECT NOTES',
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
        learningPDF.isNotEmpty
            ? Expanded(
                child: Container(
                  height: size.height,
                  width: size.width,
                  child: Scrollbar(
                    child: ListView.builder(
                      itemCount: learningPDF.length,
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        String coursename =
                            // ignore: prefer_interpolation_to_compose_strings
                            learningPDF[index].course_name +
                                '(' +
                                learningPDF[index].course_code +
                                ')';

                        String subjectName =
                            '${learningPDF[index].subject_name}(${learningPDF[index].subject_code})';

                        String name = learningPDF[index].subject_nodes;
                        String nodename = name.substring(0, name.length - 4);
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
                                    'Subject Name: ${subjectName}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                  ),
                                  Text(
                                    'Semester: ${learningPDF[index].semester}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                  ),
                                  Text(
                                    'Subject Node: ${nodename}',
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
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PDFViewerPage(
                                                          learningPDF[index])),
                                            );
                                          },
                                          child: Text(
                                            "View",
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
                                            String coursename =
                                                '${learningPDF[index].course_name}(${learningPDF[index].course_code})';
                                            updatepopupdialog(
                                              learningPDF[index].id,
                                              coursename,
                                              learningPDF[index].course_code,
                                              learningPDF[index].subject_name,
                                              learningPDF[index].subject_code,
                                              learningPDF[index].semester,
                                              learningPDF[index].subject_nodes,
                                            );
                                            // String coursename =
                                            //     learningPDF[index].course_name +
                                            //         '(' +
                                            //         learningPDF[index]
                                            //             .course_code +
                                            //         ')';
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) => UpdatePDF(
                                            //       id: learningPDF[index].id,
                                            //       semester: learningPDF[index]
                                            //           .semester,
                                            //       course: coursename,
                                            //       subject_code:
                                            //           learningPDF[index]
                                            //               .subject_code,
                                            //       file: learningPDF[index]
                                            //           .subject_nodes,
                                            //     ),
                                            //   ),
                                            // );
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
                                                DeleteSubjectNode(
                                                  learningPDF[index].id,
                                                ).whenComplete(() {
                                                  getSubjectNodes();
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
              )
      ]),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPDF(),
            ),
          ).then((value) => setState(() {}));
        },
        label: Text(
          'Add Nodes',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
