import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/constractor/teacherDetails.dart';

import 'dart:convert';
import 'package:flutter_application_2/loadingpage.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:flutter_application_2/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';

// ignore: must_be_immutable
class TeacherMobileNumberChanage extends StatefulWidget {
  TeacherDetails tdetails;
  TeacherMobileNumberChanage(this.tdetails);

  @override
  State<TeacherMobileNumberChanage> createState() =>
      _TeacherMobileNumberChanageState(tdetails);
}

class _TeacherMobileNumberChanageState
    extends State<TeacherMobileNumberChanage> {
  TeacherDetails tdetails;
  _TeacherMobileNumberChanageState(this.tdetails);
  TextEditingController currentMobile = TextEditingController();
  TextEditingController newMobile = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool ispassCorrect = false;
  bool isnpassCorrect = false;
  String errortext = '';
  String errorText = '';
  String id = '';
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    id = tdetails.id;
  }

  Future<void> updatPhoneNumber(
      String id, String mobile, String nmobile) async {
    Map data = {'id': id, 'mobile': mobile, 'nmobile': nmobile};
    print(data);
    var sharedPref = await SharedPreferences.getInstance();

    try {
      var res = await http.post(
          Uri.http(
              MyUrl.mainurl, MyUrl.suburl + "teacher_phonenumber_update.php"),
          body: data);
      print(data);
      var jsondata = jsonDecode(res.body);
      if (jsondata['status'] == true) {
        Navigator.pop(context);
        tdetails.mobile = jsondata["mobile"].toString();
        sharedPref.setString("tmobile", jsondata["mobile"].toString());

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
      Fluttertoast.showToast(msg: e.toString());
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
                  width: width,
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
                              'CHANGE MOBILE NO.',
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
                            topRight: Radius.circular(30))),
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
                              controller: currentMobile,
                              keyboardType: TextInputType.phone,
                              onChanged: (value) {
                                if ((!RegExp(r'^[0-9]{10}$').hasMatch(value))) {
                                  setState(() {
                                    ispassCorrect = false;
                                    errortext = 'Enter Valid Phone no.';
                                  });
                                } else {
                                  setState(() {
                                    ispassCorrect = true;
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
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide:
                                        const BorderSide(color: Colors.red)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide:
                                        const BorderSide(color: Colors.red)),
                                errorText: errortext.isEmpty ? null : errortext,
                                errorStyle: const TextStyle(color: Colors.red),
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                suffixIcon: ispassCorrect == false
                                    ? IconButton(
                                        onPressed: () {
                                          currentMobile.clear();
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
                                labelText: 'current mobile no.',
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
                                hintText: '(###) ###-####',
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color: ispassCorrect == false
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
                              controller: newMobile,
                              keyboardType: TextInputType.phone,
                              onChanged: (value) {
                                if ((!RegExp(r'^[0-9]{10}$').hasMatch(value))) {
                                  setState(() {
                                    errorText = 'enter valid phone no.';
                                    isnpassCorrect = false;
                                  });
                                } else {
                                  setState(() {
                                    isnpassCorrect = true;
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
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide:
                                        const BorderSide(color: Colors.red)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide:
                                        const BorderSide(color: Colors.red)),
                                errorText: errorText.isEmpty ? null : errorText,
                                errorStyle: const TextStyle(color: Colors.red),
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                suffixIcon: isnpassCorrect == false
                                    ? IconButton(
                                        onPressed: () {
                                          currentMobile.clear();
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
                                labelText: 'new mobile no.',
                                hintText: '(###) ###-####',
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
                                        color: isnpassCorrect == false
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
                              if (currentMobile.text.isNotEmpty &&
                                  newMobile.text.isNotEmpty) {
                                if (isnpassCorrect == true &&
                                    ispassCorrect == true) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const LoadingDiologPage();
                                      });
                                  updatPhoneNumber(id.toString(),
                                          currentMobile.text, newMobile.text)
                                      .whenComplete(() {
                                    currentMobile.clear();
                                    newMobile.clear();
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Enter Valid Phone no.');
                                }
                              } else {
                                Fluttertoast.showToast(msg: 'Enter phone no.');
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
