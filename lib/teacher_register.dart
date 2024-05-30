import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/loadingpage.dart';
import 'package:flutter_application_2/notification_controler.dart';
import 'package:flutter_application_2/teacher_login.dart';
import 'package:flutter_application_2/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class TeacherRegisterScreen extends StatefulWidget {
  const TeacherRegisterScreen({super.key});

  @override
  State<TeacherRegisterScreen> createState() => _TeacherRegisterScreenState();
}

class _TeacherRegisterScreenState extends State<TeacherRegisterScreen> {
  var obs = true;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController mobile = TextEditingController();
  final formkey = GlobalKey<FormState>();

  Future teacherRegister(
    String name,
    String email,
    String pass,
    String mobile,
  ) async {
    try {
      showDialog(
        context: context,
        builder: (context) => const LoadingDiologPage(),
      );
      var request = http.MultipartRequest("POST",
          Uri.http(MyUrl.mainurl, MyUrl.suburl + "teacher_register.php"));

      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['pass'] = pass;
      request.fields['mobile'] = mobile;
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
        ));
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const TeacherLoginScreen()),
            (Route<dynamic> route) => false);
      } else {
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
      // Navigator.of(context).pop();
      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: e.toString(),
      );
    }
  }

  void initState() {
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
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
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
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                            ),
                            cursorColor:
                                Theme.of(context).colorScheme.background,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: name,
                            validator: (value) {
                              if (name.text.isEmpty) {
                                return 'Enter Your name';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.red),
                                focusColor:
                                    Theme.of(context).colorScheme.background,
                                hintStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                                border: InputBorder.none,
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
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                            ),
                            cursorColor:
                                Theme.of(context).colorScheme.background,
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
                                errorStyle: TextStyle(color: Colors.red),
                                hintStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background,
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
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                            ),
                            cursorColor:
                                Theme.of(context).colorScheme.background,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: password,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "password is required";
                              } else if (value.length < 6) {
                                return ("Password Must be more than 6 characters");
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
                                errorStyle: TextStyle(color: Colors.red),
                                hintStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                                hintText: 'Password'),
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
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                            ),
                            cursorColor:
                                Theme.of(context).colorScheme.background,
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
                                errorStyle: TextStyle(color: Colors.red),
                                hintStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                                border: InputBorder.none,
                                hintText: 'Mobile no.'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    InkWell(
                      onTap: () {
                        if (formkey.currentState!.validate()) {
                          teacherRegister(name.text, email.text, password.text,
                              mobile.text);
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
          ))),
    );
  }
}
