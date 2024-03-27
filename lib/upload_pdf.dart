import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_application_2/constractor/pdf.dart';
import 'package:flutter_application_2/view_subject_nodes.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_2/add_pdf.dart';
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
            course_code: jsondata["data"][i]["course_code"].toString(),
            subject_code: jsondata["data"][i]["subject_code"].toString(),
            semester: jsondata["data"][i]["semester"].toString(),
            pdf: jsondata["data"][i]["subject_pdf"].toString(),
          );

          setState(() {
            learningPDF.add(data);
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

  @override
  void initState() {
    getSubjectNodes();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Upload Subject Nodes',
        style: TextStyle(fontSize: 20),
      )),
      body: learningPDF.isNotEmpty
          ? Container(
              height: size.height,
              width: size.width,
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: learningPDF.length,
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
                                'id: ${learningPDF[index].id}',
                                style: const TextStyle(color: Colors.black),
                              ),
                              Text(
                                'course code: ${learningPDF[index].course_code}',
                                style: const TextStyle(color: Colors.black),
                              ),
                              Text(
                                'subject code: ${learningPDF[index].subject_code}',
                                style: const TextStyle(color: Colors.black),
                              ),
                              Text(
                                'semester: ${learningPDF[index].semester}',
                                style: const TextStyle(color: Colors.black),
                              ),
                              Text(
                                'pdf: ${learningPDF[index].pdf}',
                                style: const TextStyle(color: Colors.black),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PDFViewerPage(
                                                      learningPDF[index])),
                                        );
                                      },
                                      child: const Text(
                                        "view",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
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
                                            // DeleteCourse(courselist[index]
                                            //         .course_id)
                                            //     .whenComplete(() {
                                            //   getcourse();
                                            // });
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
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.purple,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPDF(),
            ),
          );
        },
        label: const Text(
          'Add PDF',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
