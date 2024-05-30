import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/constractor/email.dart';
import 'package:flutter_application_2/loadingpage.dart';
import 'package:flutter_application_2/teacher_login.dart';
import 'package:flutter_application_2/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TeacherForgetPasswordChange extends StatefulWidget {
  // const StudentForgetPasswordChange({super.key});

  @override
  State<TeacherForgetPasswordChange> createState() =>
      _TeacherForgetPasswordChangeState();
}

class _TeacherForgetPasswordChangeState
    extends State<TeacherForgetPasswordChange> {
  TextEditingController currentPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  bool isPass = false;
  bool isnewPass = false;
  final formkey = GlobalKey<FormState>();
  String email = '';
  String errorText = '';
  String errortext = '';
  @override
  void initState() {
    email = TeacherEmail.email;
    super.initState();
    // TODO: implement initState
  }

  @override
  void dispose() {
    currentPass.dispose();
    newPass.dispose();
    super.dispose();
  }

  Future<void> updatPassword(String email, String npass) async {
    Map data = {'email': email, 'npass': npass};
    print(data);

    try {
      var res = await http
          .post(
              Uri.http(MyUrl.mainurl,
                  MyUrl.suburl + "teacher_forget_password_change.php"),
              body: data)
          .timeout(Duration(seconds: 10));

      var jsondata = jsonDecode(res.body);
      if (jsondata['status'] == true) {
        Navigator.pop(context);

        setState(() {});

        // ignore: use_build_context_synchronously
        AwesomeDialog(
          context: context,
          dialogBackgroundColor: Colors.white,
          dialogType: DialogType.success,
          headerAnimationLoop: false,
          animType: AnimType.bottomSlide,
          title: 'Success',
          titleTextStyle: const TextStyle(color: Colors.black),
          desc: 'Update Successful',
          descTextStyle: const TextStyle(color: Colors.black),
          buttonsTextStyle: const TextStyle(color: Colors.black),
          showCloseIcon: false,
          btnOkOnPress: () {},
        ).show();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const TeacherLoginScreen()),
            (Route<dynamic> route) => false);
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => TeacherLoginScreen()));
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "Network request timed out or failed: ${e.toString()}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: Colors.indigo,
            height: height,
            width: width,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(),
                  height: height * 0.13,
                  // width: width,
                  child: const Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 35, left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'CHANGE PASSWORD',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    height: height * 0.75,
                    width: width,
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: formkey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: TextField(
                              controller: currentPass,
                              // onChanged: (value) {
                              //   if (value.isEmpty) {
                              //     setState(() {
                              //       isPass = false;
                              //     });
                              //   } else if (value.length < 6) {
                              //     setState(() {
                              //       isPass = false;
                              //     });
                              //   } else {
                              //     setState(() {
                              //       isPass = true;
                              //     });
                              //   }
                              // },
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    isPass = false;
                                    errortext = 'Password Required';
                                  });
                                } else if (value.length < 6) {
                                  setState(() {
                                    errortext = 'Password must be 6 charecter';
                                    isPass = false;
                                  });
                                } else if (!RegExp(
                                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                    .hasMatch(value)) {
                                  setState(() {
                                    errorText =
                                        "Password should contain upper,lower,digit and Special character ";
                                    isPass = false;
                                  });
                                } else {
                                  setState(() {
                                    isPass = true;
                                    errortext = '';
                                  });
                                }
                              },
                              showCursor: true,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                              decoration: InputDecoration(
                                errorStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onError),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.red)),
                                errorText: errortext.isEmpty ? null : errortext,
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.red)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.red)),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                                suffixIcon: isPass == false
                                    ? IconButton(
                                        onPressed: () {
                                          currentPass.clear();
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.done,
                                        color: Colors.green,
                                      ),
                                labelText: 'Enter Password',
                                hintText: 'Somthing@#12',
                                hintStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                                labelStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color: isPass == false
                                            ? Colors.red
                                            : Colors.green,
                                        width: 1)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.greenAccent, width: 1),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: TextField(
                              controller: newPass,
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    isnewPass = false;
                                    errorText = 'Password Required';
                                  });
                                } else if (value != currentPass.text) {
                                  setState(() {
                                    isnewPass = false;
                                    errorText = 'Password Not Matched';
                                  });
                                } else {
                                  setState(() {
                                    isnewPass = true;
                                  });
                                }
                              },
                              showCursor: true,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                              decoration: InputDecoration(
                                errorStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onError),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.red)),
                                errorText: errorText.isEmpty ? null : errorText,
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.red)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(color: Colors.red)),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                                suffixIcon: isnewPass == false
                                    ? IconButton(
                                        onPressed: () {
                                          newPass.clear();
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.done,
                                        color: Colors.green,
                                      ),
                                labelText: 'Retype Password',
                                hintStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                                labelStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                                hintText: 'Somthing@#12',
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color: isnewPass == false
                                            ? Colors.red
                                            : Colors.green,
                                        width: 1)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.greenAccent, width: 1),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              if (newPass.text.isNotEmpty &&
                                  currentPass.text.isNotEmpty) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return LoadingDiologPage();
                                    });

                                updatPassword(email.toString(), newPass.text)
                                    .whenComplete(() {
                                  currentPass.clear();
                                  newPass.clear();
                                });
                              } else {
                                Fluttertoast.showToast(msg: 'Provide Password');
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 5),
                              child: Container(
                                padding: const EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
