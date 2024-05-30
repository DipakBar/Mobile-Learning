import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/StudentForgetPassword/student_forget_password.dart';
import 'package:flutter_application_2/constractor/studentdetails.dart';
import 'package:flutter_application_2/loadingpage.dart';
import 'package:flutter_application_2/student_department_page.dart';

import 'package:flutter_application_2/student_register.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_2/utils.dart';
import 'notification_controler.dart';

class StudentLoginScreen extends StatefulWidget {
  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  var obs = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final formkey = GlobalKey<FormState>();
  late SharedPreferences sp;

  Future studentLogin(
    String email,
    String pass,
  ) async {
    try {
      showDialog(
        context: context,
        builder: (context) => const LoadingDiologPage(),
      );
      var request = http.MultipartRequest(
          "POST", Uri.http(MyUrl.mainurl, MyUrl.suburl + "student_login.php"));

      request.fields['email'] = email;
      request.fields['pass'] = pass;

      var response = await request.send();
      var responded = await http.Response.fromStream(response);
      var jsondata = jsonDecode(responded.body);
      if (jsondata['status'] == true) {
        var datafetch = StudentDetails(
          jsondata['id'].toString(),
          jsondata['name'].toString(),
          jsondata['email'].toString(),
          jsondata['pass'].toString(),
          jsondata['image'].toString(),
          jsondata['mobile'].toString(),
          jsondata['course'].toString(),
        );
        print(datafetch.image);
        print(datafetch.id);
        print(datafetch.name);
        print(datafetch.email);
        print(datafetch.mobile);
        print(datafetch.course);
        sp = await SharedPreferences.getInstance();
        sp.setString("id", jsondata['id'].toString());
        sp.setString("name", jsondata['name'].toString());
        sp.setString("email", jsondata['email'].toString());
        sp.setString("pass", jsondata['pass'].toString());
        sp.setString("image", jsondata['image'].toString());
        sp.setString("mobile", jsondata['mobile'].toString());
        sp.setString("course", jsondata['course'].toString());
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
        AwesomeNotifications().createNotification(
            content: NotificationContent(
          id: 1,
          channelKey: "basic_channel",
          title: 'Dear ${datafetch.name}',
          body: "Login sucessfull",
        ));
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => StudentDepartmentScreen(datafetch)),
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
      Navigator.pop(context);
      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: e.toString(),
      );
    }
  }

  @override
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
                    Text(
                      'LOGIN !!',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 24),
                    ),
                    LottieBuilder.asset(
                      'animations/Animation - 1707122158971.json',
                      height: 250,
                      reverse: true,
                      repeat: true,
                      fit: BoxFit.cover,
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
                        child: TextFormField(
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
                          ),
                          cursorColor: Theme.of(context).colorScheme.background,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                              prefixIcon: Icon(
                                Icons.email_rounded,
                                color: Theme.of(context).colorScheme.background,
                              ),
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                              hintText: 'Email'),
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
                        child: TextFormField(
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: password,
                          validator: (value) {
                            if (password.text.isEmpty) {
                              return 'Enter Your password';
                            }

                            return null;
                          },
                          obscureText: obs,
                          decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.red),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme.of(context).colorScheme.background,
                              ),
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
                              hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                              hintText: 'Password'),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StudentForgetPassword()));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 29),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Forget password',
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    InkWell(
                      onTap: () {
                        if (formkey.currentState!.validate()) {
                          // print(password.text);
                          studentLogin(email.text, password.text);
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
                              "Login",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60.0),
                      child: Row(
                        children: [
                          Text(
                            'Not a member ?',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const StudentRegisterScreen()));
                            },
                            child: Text(
                              'Register now',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ))),
    );
  }
}
