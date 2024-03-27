import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_application_2/constractor/studentdetails.dart';
import 'package:flutter_application_2/loadingpage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:flutter_application_2/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class StudentMobileNOChange extends StatefulWidget {
  StudentDetails details;
  StudentMobileNOChange(this.details);

  @override
  State<StudentMobileNOChange> createState() =>
      _StudentMobileNOChangeState(details);
}

class _StudentMobileNOChangeState extends State<StudentMobileNOChange> {
  StudentDetails details;
  _StudentMobileNOChangeState(this.details);
  TextEditingController currentMobile = TextEditingController();
  TextEditingController newMobile = TextEditingController();
  final formkey = GlobalKey<FormState>();

  Future<void> updatPhoneNumber(String mobile, String nmobile) async {
    Map data = {'mobile': mobile, 'nmobile': nmobile};
    print(data);
    var sharedPref = await SharedPreferences.getInstance();

    try {
      var res = await http.post(
          Uri.http(
              MyUrl.mainurl, MyUrl.suburl + "student_phonenumber_update.php"),
          body: data);
      print(data);
      var jsondata = jsonDecode(res.body);
      if (jsondata['status'] == true) {
        Navigator.pop(context);
        details.mobile = jsondata["mobile"].toString();
        sharedPref.setString("mobile", jsondata["mobile"].toString());

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
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.indigo,
          height: height,
          width: width,
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(),
                height: height * 0.25,
                width: width,
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 35, left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'CHANGE MOBILE NO.',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 20),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                height: height * 0.75,
                width: width,
                child: Form(
                  key: formkey,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        child: TextFormField(
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
                          ),
                          controller: currentMobile,
                          keyboardType: TextInputType.phone,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Mobile no. is required";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.phone,
                              color: Theme.of(context).colorScheme.background,
                            ),
                            border: InputBorder.none,
                            hintText: "enter current phone no.",
                            labelText: 'Phone no.',
                            errorStyle: TextStyle(color: Colors.red),
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                            ),
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        child: TextFormField(
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
                          ),
                          controller: newMobile,
                          keyboardType: TextInputType.phone,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email Id is required";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.phone,
                                color: Theme.of(context).colorScheme.background,
                              ),
                              border: InputBorder.none,
                              hintText: "enter new phone no.",
                              labelText: 'Phone no.',
                              hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                              labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                              errorStyle: TextStyle(color: Colors.red)),
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          if (formkey.currentState!.validate()) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return LoadingDiologPage();
                                });
                            updatPhoneNumber(currentMobile.text, newMobile.text)
                                .whenComplete(() {
                              currentMobile.clear();
                              newMobile.clear();
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 20, left: 30, right: 30),
                          child: Container(
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                borderRadius: BorderRadius.circular(20)),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
