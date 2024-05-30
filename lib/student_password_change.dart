import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/constractor/studentdetails.dart';

import 'dart:convert';
import 'package:flutter_application_2/loadingpage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_2/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class StudentPasswordchange extends StatefulWidget {
  StudentDetails details;
  StudentPasswordchange(this.details);

  @override
  State<StudentPasswordchange> createState() =>
      _StudentPasswordchangeState(details);
}

class _StudentPasswordchangeState extends State<StudentPasswordchange> {
  StudentDetails details;
  _StudentPasswordchangeState(this.details);
  var obs = true;
  var obss = true;
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool isPass = false;
  bool isnewPass = false;
  String id = '';
  String errorText = '';
  String errortext = '';
  Future<void> updatPassword(
      String id, String password, String npassword) async {
    Map data = {'id': id, 'password': password, 'npassword': npassword};
    print(data);
    var sharedPref = await SharedPreferences.getInstance();

    try {
      var res = await http.post(
          Uri.http(MyUrl.mainurl, MyUrl.suburl + "student_password_update.php"),
          body: data);
      print(data);
      var jsondata = jsonDecode(res.body);
      if (jsondata['status'] == true) {
        Navigator.pop(context);
        details.pass = jsondata["pass"].toString();
        sharedPref.setString("pass", jsondata["pass"].toString());

        setState(() {});

        // ignore: use_build_context_synchronously
        AwesomeDialog(
          context: context,
          dialogBackgroundColor: Theme.of(context).colorScheme.background,
          dialogType: DialogType.success,
          headerAnimationLoop: false,
          animType: AnimType.bottomSlide,
          title: 'Success',
          titleTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          desc: 'Update Successful',
          descTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          buttonsTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          showCloseIcon: false,
          btnOkOnPress: () {},
        ).show();
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = details.id;
    // print(details.pass);
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
            color: Colors.lightBlue,
            height: height,
            width: width,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(),
                  height: height * 0.15,
                  width: width,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 35, left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'CHANGE PASSWORD',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    height: height * 0.75,
                    width: width,
                    child: Form(
                      key: formkey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: TextField(
                              obscureText: obs,
                              controller: currentPassword,
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    isPass = false;
                                    errorText = 'Password Requried';
                                  });
                                } else if (value.length < 6) {
                                  setState(() {
                                    errorText =
                                        'Password must be with in 6 charecter';
                                    isPass = false;
                                  });
                                } else if (!RegExp(
                                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                    .hasMatch(value)) {
                                  setState(() {
                                    errorText = 'Enter Valid Password';
                                    isPass = false;
                                  });
                                } else {
                                  setState(() {
                                    errorText = '';
                                    isPass = true;
                                  });
                                }
                              },
                              showCursor: true,
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              decoration: InputDecoration(
                                errorStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onError),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide:
                                        const BorderSide(color: Colors.red)),
                                errorText: errorText.isEmpty ? null : errorText,
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide:
                                        const BorderSide(color: Colors.red)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide:
                                        const BorderSide(color: Colors.red)),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
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
                                                .onBackground,
                                          )
                                        : Icon(
                                            Icons.visibility,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          )),
                                labelText: 'Current Password',
                                hintText: 'Somthing@123',
                                hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                labelStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
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
                              obscureText: obss,
                              controller: newPassword,
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    isnewPass = false;
                                    errortext = 'Password required';
                                  });
                                } else if (value.length < 6) {
                                  setState(() {
                                    errortext =
                                        'Password must be with in 6 charecter';
                                    isnewPass = false;
                                  });
                                } else if (!RegExp(
                                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                    .hasMatch(value)) {
                                  setState(() {
                                    errortext = 'Enter Valid Password';
                                    isnewPass = false;
                                  });
                                } else {
                                  setState(() {
                                    errortext = '';
                                    isnewPass = true;
                                  });
                                }
                              },
                              showCursor: true,
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              decoration: InputDecoration(
                                errorStyle: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onError),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide:
                                        const BorderSide(color: Colors.red)),
                                errorText: errortext.isEmpty ? null : errortext,
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide:
                                        const BorderSide(color: Colors.red)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide:
                                        const BorderSide(color: Colors.red)),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      obss
                                          ? setState(() {
                                              obss = false;
                                            })
                                          : setState(() {
                                              obss = true;
                                            });
                                    },
                                    child: obss
                                        ? Icon(
                                            Icons.visibility_off,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          )
                                        : Icon(
                                            Icons.visibility,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          )),
                                labelText: 'New Password',
                                hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                labelStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                hintText: 'Somthing@123',
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
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              if (currentPassword.text.isNotEmpty &&
                                  newPassword.text.isNotEmpty) {
                                if (isPass == true) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const LoadingDiologPage();
                                      });
                                  updatPassword(
                                          id.toString(),
                                          currentPassword.text,
                                          newPassword.text)
                                      .whenComplete(() {
                                    currentPassword.clear();
                                    newPassword.clear();
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Provide Valid Password');
                                }
                              } else {
                                Fluttertoast.showToast(msg: 'Provide Password');
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 20,
                                left: 30,
                                right: 30,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
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
