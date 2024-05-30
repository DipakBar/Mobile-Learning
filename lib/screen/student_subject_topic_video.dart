// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/StudentVideoDownload/Student_view_subject_topic_video.dart';
import 'package:flutter_application_2/studentMobel/studentGetTopicVideo.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_application_2/utils.dart';

class StudentSubjectTopicVideo extends StatefulWidget {
  final String semester;
  final String subject_code;
  StudentSubjectTopicVideo(
      {required this.semester, required this.subject_code});

  @override
  State<StudentSubjectTopicVideo> createState() =>
      _StudentSubjectTopicVideoState();
}

class _StudentSubjectTopicVideoState extends State<StudentSubjectTopicVideo> {
  TextEditingController Searchbar = TextEditingController();
  bool crossIcon = true;
  bool elseState = false;
  String fullcourse = '';
  List<StudentGetSubjectTopicVideo> topic_vodeo = [];
  List<StudentGetSubjectTopicVideo> searchcontact = [];
  late String semester;
  late String subject_code;
  bool isopen = false;
  bool notopen = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    semester = widget.semester;
    subject_code = widget.subject_code;
    if (mounted) {
      getSubjectNodes(subject_code, semester);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> getSubjectNodes(String subject_code, String semester) async {
    Map<String, String> data = {
      'subject_code': subject_code,
      'semester': semester
    };
    print(data);
    try {
      var res = await http.post(
        Uri.http(MyUrl.mainurl, MyUrl.suburl + "student_get_subjectnodes.php"),
        body: data,
      );

      if (!mounted) return; // Check if the widget is still mounted

      var jsondata = jsonDecode(res.body);
      if (jsondata['status'] == true) {
        topic_vodeo.clear();

        for (int i = 0; i < jsondata["data"].length; i++) {
          StudentGetSubjectTopicVideo node = StudentGetSubjectTopicVideo(
            topic_video: jsondata["data"][i]["video"].toString(),
          );

          // setState(() {
          //   topic_vodeo.add(node);
          // });
          setState(() {
            if (node.topic_video != 'NA') {
              topic_vodeo.add(node);
            } else {
              elseState = true;
            }
          });
        }
      } else {
        setState(() {
          elseState = true;
        });
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

  // Future getSubjectNodes(
  //   String subject_code,
  //   String semester,
  // ) async {
  //   Map data = {'subject_code': subject_code, 'semester': semester};
  //   print(data);
  //   try {
  //     var res = await http.post(
  //         // ignore: prefer_interpolation_to_compose_strings
  //         Uri.http(
  //             MyUrl.mainurl, MyUrl.suburl + "student_get_subjectnodes.php"),
  //         body: data);
  //     var jsondata = jsonDecode(res.body);
  //     if (jsondata['status'] == true) {
  //       topic_vodeo.clear();

  //       for (int i = 0; i < jsondata["data"].length; i++) {
  //         StudentGetSubjectTopicVideo node = StudentGetSubjectTopicVideo(
  //           topic_video: jsondata["data"][i]["video"].toString(),
  //         );

  //         setState(() {
  //           topic_vodeo.add(node);
  //         });
  //       }
  //     } else {
  //       setState(() {
  //         elseState = true;
  //       });
  //       Fluttertoast.showToast(
  //         gravity: ToastGravity.CENTER,
  //         msg: jsondata['msg'],
  //       );
  //     }
  //   } catch (e) {
  //     print(e);
  //     Fluttertoast.showToast(
  //       gravity: ToastGravity.CENTER,
  //       msg: e.toString(),
  //     );
  //   }
  // }

  void FilterItem(String query) {
    query = query.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        searchcontact.clear();
        searchcontact = topic_vodeo;
      });
    } else {
      setState(() {
        searchcontact = topic_vodeo
            .where((val) => val.topic_video.toLowerCase().contains(query))
            .toList();
      });
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onBackground,
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(40)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: TextFormField(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                      ),
                      controller: Searchbar,
                      onChanged: (value) {
                        setState(() {
                          crossIcon = false;
                          isopen = true;
                          notopen = false;
                        });
                        return FilterItem(value);
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).colorScheme.background,
                        ),
                        suffixIcon: InkWell(
                            onTap: () {
                              setState(
                                () {
                                  Searchbar.clear();
                                  crossIcon = true;
                                  notopen = true;
                                  isopen = false;
                                },
                              );
                            },
                            child: crossIcon == false
                                ? Icon(
                                    Icons.clear,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                  )
                                : const SizedBox()),
                        border: InputBorder.none,
                        hintText: 'Serach',
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (isopen == true)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: height * 0.7,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: searchcontact.isNotEmpty
                          ? ListView.builder(
                              itemCount: searchcontact.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            StudentViewSubjectTopic(
                                          searchcontact[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: height * 0.08,
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: SingleChildScrollView(
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.video_file,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                        title: Text(
                                          searchcontact[index].topic_video,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              height: height * 0.08,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Not Found",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              if (notopen == true)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: height * 0.7,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: topic_vodeo.isNotEmpty
                          ? ListView.builder(
                              itemCount: topic_vodeo.length,
                              itemBuilder: (context, index) {
                                String name = topic_vodeo[index].topic_video;
                                String videoname =
                                    name.substring(0, name.length - 4);
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            StudentViewSubjectTopic(
                                          topic_vodeo[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: height * 0.08,
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: SingleChildScrollView(
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.video_file,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                        title: Text(
                                          videoname,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : elseState == true
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  height: height * 0.08,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Not Available",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  height: height * 0.08,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SpinKitFadingCircle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                          size: 90,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Loading....",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
