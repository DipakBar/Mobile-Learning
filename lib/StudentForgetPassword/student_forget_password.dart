import 'dart:convert';
import 'package:flutter_application_2/StudentForgetPassword/student_otp_validation.dart';
import 'package:flutter_application_2/constractor/email.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/loadingpage.dart';

import 'package:flutter_application_2/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:validators/validators.dart';

class StudentForgetPassword extends StatefulWidget {
  const StudentForgetPassword({super.key});

  @override
  State<StudentForgetPassword> createState() => _StudentForgetPasswordState();
}

class _StudentForgetPasswordState extends State<StudentForgetPassword> {
  TextEditingController email = TextEditingController();
  bool isEmailCorrect = false;
  EmailOTP myauth = EmailOTP();
  String errorText = '';
  Future studentEmailCheck(
    String email,
  ) async {
    try {
      showDialog(
        context: context,
        builder: (context) => const LoadingDiologPage(),
      );
      var request = http.MultipartRequest(
          "POST",
          Uri.http(
              MyUrl.mainurl, MyUrl.suburl + "student_forget_email_check.php"));

      request.fields['email'] = email;

      var response = await request.send();
      var responded = await http.Response.fromStream(response);
      var jsondata = jsonDecode(responded.body);
      if (jsondata['status'] == true) {
        StudentEmail.email = email;
        myauth.setConfig(
            appEmail: "me@rohitchouhan.com",
            appName: "Mobile Learning",
            userEmail: email,
            otpLength: 6,
            otpType: OTPType.digitsOnly);
        if (await myauth.sendOTP() == true) {
          Get.snackbar(
            backgroundColor: Theme.of(context).colorScheme.onBackground,
            colorText: Theme.of(context).colorScheme.background,
            borderRadius: 25.0,
            'Mobile Learning',
            'OTP has been sent',
          );
          Navigator.pop(context);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StudentOTPValidatoin(myauth)));
        } else {
          Get.snackbar(
            backgroundColor: Theme.of(context).colorScheme.onBackground,
            colorText: Theme.of(context).colorScheme.background,
            'Mobile Learning',
            'Oops, OTP send failed',
          );
        }
      } else {
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
        Navigator.pop(context);
      }
    } catch (e) {
      // print(e);

      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: e.toString(),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    email.dispose();
    super.dispose();
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
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              height: height,
              width: width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Enter Email',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    LottieBuilder.asset(
                      'animations/Animation - 1709014901437.json',
                      height: 250,
                      reverse: true,
                      repeat: true,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: TextField(
                        controller: email,
                        onChanged: (value) {
                          setState(() {
                            if (isEmailCorrect = isEmail(value)) {
                              errorText = '';
                            } else {
                              errorText = 'Enter valid Email id';
                            }
                          });
                        },
                        showCursor: true,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        decoration: InputDecoration(
                          errorText: errorText.isEmpty ? null : errorText,
                          errorStyle: TextStyle(color: Colors.red),
                          border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.red)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.red)),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          suffixIcon: isEmailCorrect == false
                              ? IconButton(
                                  onPressed: () {
                                    email.clear();
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
                          labelText: 'Email',
                          hintText: 'Somthing@gmail.com',
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: isEmailCorrect == false
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
                      onTap: () async {
                        if (email.text.isNotEmpty) {
                          if (isEmail(email.text)) {
                            studentEmailCheck(email.text);
                          } else {
                            Fluttertoast.showToast(msg: 'Provide valid email');
                          }
                        } else {
                          Fluttertoast.showToast(msg: 'Provide email');
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 15),
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              "Send OTP",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ));
  }
}
