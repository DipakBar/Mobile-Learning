import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/constractor/teacherDetails.dart';
import 'package:flutter_application_2/loadingpage.dart';
import 'package:flutter_application_2/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TeacherChangePassword extends StatefulWidget {
  TeacherDetails tdetails;
  TeacherChangePassword(this.tdetails);
  @override
  State<TeacherChangePassword> createState() =>
      _TeacherChangePasswordState(tdetails);
}

class _TeacherChangePasswordState extends State<TeacherChangePassword> {
  TeacherDetails tdetails;
  _TeacherChangePasswordState(this.tdetails);
  TextEditingController currentPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  bool isPass = false;
  bool isnewPass = false;
  final formkey = GlobalKey<FormState>();
  String id = '';
  String errortext = '';
  String errorText = '';
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    id = tdetails.id;
  }

  @override
  void dispose() {
    currentPass.dispose();
    newPass.dispose();
    super.dispose();
  }

  Future<void> updatPassword(String id, String pass, String npass) async {
    Map data = {'id': id, 'pass': pass, 'npass': npass};
    print(data);
    var sharedPref = await SharedPreferences.getInstance();
    try {
      var res = await http
          .post(
              Uri.http(
                  MyUrl.mainurl, MyUrl.suburl + "teacher_password_update.php"),
              body: data)
          .timeout(const Duration(seconds: 10));

      var jsondata = jsonDecode(res.body);
      if (jsondata['status'] == true) {
        Navigator.pop(context);
        tdetails.pass = jsondata["pass"].toString();
        sharedPref.setString("tpass", jsondata["pass"].toString());

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
            color: Colors.lightBlue,
            height: height,
            width: width,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(),
                  height: height * 0.13,
                  // width: width,
                  child: Column(
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
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  fontSize: 20),
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: formkey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: TextField(
                              controller: currentPass,
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    isPass = false;
                                    errortext = "password is required";
                                  });
                                } else if (value.length < 6) {
                                  setState(() {
                                    errortext =
                                        "Password Must be more than 6 characters";
                                    isPass = false;
                                  });
                                } else if (!RegExp(
                                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                    .hasMatch(value)) {
                                  setState(() {
                                    errortext =
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
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              decoration: InputDecoration(
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide:
                                        const BorderSide(color: Colors.red)),
                                errorText: errortext.isEmpty ? null : errortext,
                                errorStyle: const TextStyle(color: Colors.red),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
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
                                labelText: 'current Password',
                                hintText: '12345',
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
                                      width: 1),
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 1)),
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
                                    errorText = "password is required";
                                  });
                                } else if (value.length < 6) {
                                  setState(() {
                                    errorText =
                                        "Password Must be more than 6 characters";
                                    isnewPass = false;
                                  });
                                } else if (!RegExp(
                                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                    .hasMatch(value)) {
                                  setState(() {
                                    errorText =
                                        "Password should contain upper,lower,digit and Special character ";
                                    isnewPass = false;
                                  });
                                } else {
                                  setState(() {
                                    isnewPass = true;
                                    errorText = '';
                                  });
                                }
                              },
                              showCursor: true,
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
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
                                labelText: 'new Password',
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
                                hintText: '12345',
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
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 1)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide:
                                        const BorderSide(color: Colors.red)),
                                errorText: errorText.isEmpty ? null : errorText,
                                errorStyle: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              if (newPass.text.isNotEmpty &&
                                  currentPass.text.isNotEmpty) {
                                if (isnewPass == true) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const LoadingDiologPage();
                                      });

                                  updatPassword(id.toString(), currentPass.text,
                                          newPass.text)
                                      .whenComplete(() {
                                    currentPass.clear();
                                    newPass.clear();
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 10),
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
