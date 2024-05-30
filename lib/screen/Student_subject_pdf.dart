import 'dart:convert';

import 'package:flutter_application_2/StudentSubjectNodeDownload/Student_view_subject_nodes.dart';
import 'package:flutter_application_2/studentMobel/StudentGetNodes.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_2/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentSubjectPDF extends StatefulWidget {
  final String semester;
  final String subject_code;
  StudentSubjectPDF({required this.semester, required this.subject_code});

  @override
  State<StudentSubjectPDF> createState() => _StudentSubjectPDFState();
}

class _StudentSubjectPDFState extends State<StudentSubjectPDF> {
  TextEditingController Searchbar = TextEditingController();
  bool crossIcon = true;
  late SharedPreferences sp;
  bool isopen = false;
  bool notopen = true;
  bool elseState = false;
  String fullcourse = '';
  List<StudentGetNodes> nodes = [];
  List<StudentGetNodes> searchcontact = [];
  late String semester;
  late String subject_code;
  // String name = '';
  // String nodename = '';
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

  Future getSubjectNodes(
    String subject_code,
    String semester,
  ) async {
    Map data = {'subject_code': subject_code, 'semester': semester};
    print(data);
    try {
      var res = await http.post(
          // ignore: prefer_interpolation_to_compose_strings
          Uri.http(
              MyUrl.mainurl, MyUrl.suburl + "student_get_subjectnodes.php"),
          body: data);
      if (!mounted) return;
      var jsondata = jsonDecode(res.body);
      if (jsondata['status'] == true) {
        nodes.clear();

        for (int i = 0; i < jsondata["data"].length; i++) {
          StudentGetNodes node = StudentGetNodes(
            sub_nodes: jsondata["data"][i]["subject_pdf"].toString(),
          );
          setState(() {
            if (node.sub_nodes != 'NA') {
              nodes.add(node);
            } else {
              elseState = true;
            }
          });

          // setState(() {
          //   nodes.add(node);
          // });
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

  void FilterItem(String query) {
    query = query.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        searchcontact.clear();
        searchcontact = nodes;
      });
    } else {
      setState(() {
        searchcontact = nodes
            .where((val) => val.sub_nodes.toLowerCase().contains(query))
            .toList();
      });
    }
  }

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
                                            StudentViewSubjectNodes(
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
                                        title: Text(
                                          searchcontact[index].sub_nodes,
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
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              height: height * 0.08,
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Not Found",
                                      style: TextStyle(color: Colors.black),
                                    ),
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
                      child: nodes.isNotEmpty
                          ? ListView.builder(
                              itemCount: nodes.length,
                              itemBuilder: (context, index) {
                                String name = nodes[index].sub_nodes;
                                String nodename =
                                    name.substring(0, name.length - 4);
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                StudentViewSubjectNodes(
                                                    nodes[index])));
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
                                          Icons.file_copy_rounded,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                        title: Text(
                                          nodename,
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
