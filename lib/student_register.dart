// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/constractor/course.dart';

import 'package:flutter_application_2/loadingpage.dart';
import 'package:flutter_application_2/notification_controler.dart';
import 'package:flutter_application_2/student_login.dart';
import 'package:flutter_application_2/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class StudentRegisterScreen extends StatefulWidget {
  const StudentRegisterScreen({super.key});

  @override
  State<StudentRegisterScreen> createState() => _StudentRegisterScreenState();
}

class _StudentRegisterScreenState extends State<StudentRegisterScreen> {
  var obs = true;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController mobile = TextEditingController();
  final formkey = GlobalKey<FormState>();
  String? selectedCourse;
  List<String> courselist = [];

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
        courselist.clear();

        for (int i = 0; i < jsondata["data"].length; i++) {
          course stdentcode = course(
              course_id: jsondata["data"][i]["course_id"].toString(),
              course_name: jsondata["data"][i]["course_name"].toString(),
              course_code: jsondata["data"][i]["course_code"].toString());
          courselist
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

  Future studentRegister(String name, String email, String pass, String mobile,
      String course) async {
    try {
      showDialog(
        context: context,
        builder: (context) => const LoadingDiologPage(),
      );
      var request = http.MultipartRequest(
          "POST",
          // ignore: prefer_interpolation_to_compose_strings
          Uri.http(MyUrl.mainurl, MyUrl.suburl + "Student_register.php"));

      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['pass'] = pass;
      request.fields['mobile'] = mobile;
      request.fields['course'] = course;
      var response = await request.send();
      var responded = await http.Response.fromStream(response);
      var jsondata = jsonDecode(responded.body);
      if (jsondata['status'] == true) {
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 1,
            channelKey: "basic_channel",
            title: 'Dear user',
            body: "signup sucessfull",
          ),
        );
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => StudentLoginScreen()),
            (Route<dynamic> route) => false);
      } else {
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: e.toString(),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
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
            print(courselist);
          },
        );
      },
    );
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: formkey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Icon(
                      Icons.app_registration_outlined,
                      size: 100,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    Text(
                      'REGISTER HERE !!',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 24),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onBackground,
                            border: Border.all(
                              color: const Color.fromARGB(255, 121, 134, 203),
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: name,
                            validator: (value) {
                              if (name.text.isEmpty) {
                                return 'Enter Your name';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                                errorStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.onError,
                                ),
                                hintText: 'Name'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onBackground,
                            border: Border.all(
                              color: const Color.fromARGB(255, 121, 134, 203),
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: email,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Email Id is required";
                              } else if (!RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{3,4}$')
                                  .hasMatch(value)) {
                                return "Please enter valid email";
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                                errorStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.onError,
                                ),
                                border: InputBorder.none,
                                hintText: 'Email'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onBackground,
                            border: Border.all(
                              color: const Color.fromARGB(255, 121, 134, 203),
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: password,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "password is required";
                              } else if (value.length < 6) {
                                return ("Password Must be more than 5 characters");
                              } else if (!RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                  .hasMatch(value)) {
                                return ("Password should contain upper,lower,digit and Special character ");
                              } else {
                                return null;
                              }
                            },
                            obscureText: obs,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    obs
                                        ? setState(() {
                                            obs = false;
                                          })
                                        : setState(() {
                                            obs = true;
                                          });
                                  },
                                  child: obs
                                      ? Icon(
                                          Icons.visibility_off,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                        )
                                      : Icon(
                                          Icons.visibility,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                        )),
                              border: InputBorder.none,
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                              errorStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onError,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onBackground,
                            border: Border.all(
                              color: const Color.fromARGB(255, 121, 134, 203),
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: mobile,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "mobile no. is required";
                              } else if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
                                  .hasMatch(value)) {
                                return "Please enter valid mobile no.";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Mobile',
                              hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                              errorStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onError,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onBackground,
                            border: Border.all(
                              color: const Color.fromARGB(255, 121, 134, 203),
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.only(left: 20.0),
                        child: DropdownButtonFormField<String>(
                          dropdownColor:
                              Theme.of(context).colorScheme.onBackground,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            // fillColor: Colors.black,
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                            ),
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                            ),
                            errorStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onError,
                            ),
                            hintText: 'Chose Your Course....',
                            labelText: 'SELECT COURSE',
                            contentPadding: const EdgeInsets.all(10),
                          ),
                          value: selectedCourse,
                          items: courselist.map(
                            (String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value.toString()),
                              );
                            },
                          ).toList(),
                          onChanged: (value) {
                            selectedCourse = value.toString();
                          },
                          validator: (value) =>
                              value == null ? 'Field required' : null,
                          icon: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.arrow_drop_down_circle_outlined,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        if (formkey.currentState!.validate()) {
                          studentRegister(name.text, email.text, password.text,
                              mobile.text, selectedCourse.toString());
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              "Register",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
