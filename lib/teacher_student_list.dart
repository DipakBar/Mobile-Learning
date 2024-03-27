import 'dart:convert';
import 'package:flutter_application_2/constractor/allStudentDetails.dart';
import 'package:flutter_application_2/teacher_show_student.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_2/utils.dart';
import 'package:lottie/lottie.dart';

class TeacherStudentList extends StatefulWidget {
  const TeacherStudentList({super.key});

  @override
  State<TeacherStudentList> createState() => _TeacherStudentListState();
}

class _TeacherStudentListState extends State<TeacherStudentList> {
  bool isopen = false;
  bool notopen = true;
  TextEditingController Searchbar = TextEditingController();
  List<allStudentDetais> studentlist = [];
  List<allStudentDetais> searchcontact = [];
  // List<allStudentDetais> priority = [];

  void FilterItem(String query) {
    query = query.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        searchcontact.clear();
        searchcontact = studentlist;
      });
    } else {
      setState(() {
        searchcontact = studentlist
            .where((val) => val.name.toLowerCase().contains(query))
            .toList();
      });
    }
  }

  showImage(String image) {
    print(image);
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          decoration: BoxDecoration(
              image: image != 'no image'
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          MyUrl.fullurl + MyUrl.Studentimageurl + image))
                  : DecorationImage(
                      image: AssetImage(
                      "assets/images/default.png",
                    )),
              borderRadius: BorderRadius.circular(2)),
          height: 250,
        ),
      ),
    );
  }

  Future getUserdata() async {
    try {
      var response = await http.get(
        // ignore: prefer_interpolation_to_compose_strings
        Uri.http(MyUrl.mainurl, MyUrl.suburl + "students_all_details.php"),
      );
      var jsondata = jsonDecode(response.body.toString());

      if (jsondata["status"] == "true") {
        studentlist.clear();
        for (int i = 0; i < jsondata['data'].length; i++) {
          allStudentDetais databasedata = allStudentDetais(
            id: jsondata['data'][i]['id'].toString(),
            name: jsondata['data'][i]['name'].toString(),
            email: jsondata['data'][i]['email'].toString(),
            pass: jsondata['data'][i]['pass'].toString(),
            image: jsondata['data'][i]['image'].toString(),
            mobile: jsondata['data'][i]['mobile'].toString(),
            course: jsondata['data'][i]['course'].toString(),
          );
          setState(() {
            studentlist.add(databasedata);
          });
        }
      }
      // ignore: use_build_context_synchronously
      else {
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }

      return studentlist;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  @override
  void initState() {
    getUserdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: Searchbar,
                    onChanged: (value) {
                      setState(() {
                        isopen = true;
                        notopen = false;
                      });
                      return FilterItem(value);
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      suffixIcon: InkWell(
                          onTap: () {
                            setState(
                              () {
                                Searchbar.clear();
                                notopen = true;
                                isopen = false;
                              },
                            );
                          },
                          child: Icon(Icons.clear, color: Colors.white)),
                      border: InputBorder.none,
                      hintText: 'Serach',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (isopen == true)
              Expanded(
                child: searchcontact.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.only(top: 2),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(45),
                            topRight: Radius.circular(45),
                          ),
                          color: Colors.black,
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 15, top: 20, right: 15),
                          child: ListView.builder(
                            itemCount: searchcontact.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TeacherShowStudent(
                                          searchcontact[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        searchcontact[index].name,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      subtitle: Text(
                                        searchcontact[index].course,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      leading: InkWell(
                                        onTap: () {
                                          showImage(searchcontact[index].image);
                                        },
                                        child: searchcontact[index].image !=
                                                'no image'
                                            ? CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                  MyUrl.fullurl +
                                                      MyUrl.Studentimageurl +
                                                      searchcontact[index]
                                                          .image,
                                                ),
                                              )
                                            : const CircleAvatar(
                                                backgroundColor: Colors.black,
                                                backgroundImage: AssetImage(
                                                  "assets/images/default.png",
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.only(top: 2),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(45),
                              topRight: Radius.circular(45)),
                          color: Colors.black,
                        ),
                        child: Center(
                          child: LottieBuilder.asset(
                            'animations/Animation - 1709301940836.json',
                            height: 200,
                            reverse: true,
                            repeat: true,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
              ),
            if (notopen == true)
              Expanded(
                child: studentlist.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.only(top: 2),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(45),
                              topRight: Radius.circular(45)),
                          color: Colors.black,
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 15, top: 20, right: 15),
                          child: ListView.builder(
                            itemCount: studentlist.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TeacherShowStudent(
                                          studentlist[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: ListTile(
                                      title: Text(
                                        studentlist[index].name,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      subtitle: Text(
                                        studentlist[index].course,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      leading: InkWell(
                                        onTap: () {
                                          showImage(studentlist[index].image);
                                        },
                                        child: studentlist[index].image !=
                                                'no image'
                                            ? CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                  MyUrl.fullurl +
                                                      MyUrl.Studentimageurl +
                                                      studentlist[index].image,
                                                ),
                                              )
                                            : const CircleAvatar(
                                                backgroundColor: Colors.black,
                                                backgroundImage: AssetImage(
                                                  "assets/images/default.png",
                                                ),
                                              ),
                                      ),
                                      trailing: IconButton(
                                        onPressed: () async {
                                          String number =
                                              studentlist[index].mobile;
                                          await FlutterPhoneDirectCaller
                                              .callNumber(
                                            number.toString(),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.call,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.only(top: 2),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(45),
                              topRight: Radius.circular(45)),
                          color: Colors.black,
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SpinKitFadingCircle(
                                color: Colors.white,
                                size: 90,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Loading....",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
