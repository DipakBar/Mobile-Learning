import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/constractor/studentdetails.dart';
import 'package:flutter_application_2/loadingpage.dart';
import 'package:flutter_application_2/student_department_page.dart';
import 'package:flutter_application_2/student_forget_password.dart';
import 'package:flutter_application_2/student_register.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        // print('object');
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
      // Navigator.of(context).pop();
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
          backgroundColor: Colors.grey[300],
          body: SafeArea(
              child: Center(
            child: SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: formkey,
                child: Column(
                  children: [
                    const Text(
                      'LOGIN !!',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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
                            color: Colors.grey[200],
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: email,
                          validator: (value) {
                            if (email.text.isEmpty) {
                              return 'enter your email ';
                            }

                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              errorStyle: TextStyle(color: Colors.red),
                              prefixIcon: Icon(Icons.email_rounded),
                              border: InputBorder.none,
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
                            color: Colors.grey[200],
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        child: TextFormField(
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
                              prefixIcon: Icon(Icons.lock),
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
                                      ? const Icon(Icons.visibility_off)
                                      : const Icon(Icons.visibility)),
                              border: InputBorder.none,
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
                      child: const Padding(
                        padding: EdgeInsets.only(right: 29),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text('Forget password')
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
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
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
                          const Text('Not a member ?'),
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
                            child: const Text(
                              'Register now',
                              style: TextStyle(fontWeight: FontWeight.bold),
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
