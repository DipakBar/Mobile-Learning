import 'dart:async';

import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class StudentOTPValidatoin extends StatefulWidget {
  EmailOTP myauth;
  StudentOTPValidatoin(this.myauth);
  @override
  State<StudentOTPValidatoin> createState() =>
      _StudentOTPValidatoinState(myauth);
}

class _StudentOTPValidatoinState extends State<StudentOTPValidatoin> {
  EmailOTP myauth;
  _StudentOTPValidatoinState(this.myauth);
  int resendTime = 30;

  late Timer countdownTimer;
  TextEditingController otp1 = TextEditingController();
  TextEditingController otp2 = TextEditingController();
  TextEditingController otp3 = TextEditingController();
  TextEditingController otp4 = TextEditingController();
  TextEditingController otp5 = TextEditingController();
  TextEditingController otp6 = TextEditingController();
  final formkey = GlobalKey<FormState>();
  @override
  void initState() {
    startTimer();
    super.initState();
  }

  startTimer() {
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        resendTime = resendTime - 1;
      });
      if (resendTime < 1) {
        countdownTimer.cancel();
      }
    });
  }

  stopTmer() {
    if (countdownTimer.isActive) {
      countdownTimer.cancel();
    }
  }

  String strFormatting(n) => n.toString().padLeft(2, '0');
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              height: size.height,
              width: size.width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      'ENTER OTP',
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
                    const SizedBox(
                      height: 30,
                    ),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('we have send verification code to'),
                            Text('diakbar867@gmail.com'),
                          ],
                        )
                      ],
                    ),
                    Form(
                      key: formkey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 85,
                            child: AspectRatio(
                              aspectRatio: 0.6,
                              child: TextField(
                                controller: otp1,
                                autofocus: true,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                  if (value.length == 0) {
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                                showCursor: false,
                                readOnly: false,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                decoration: InputDecoration(
                                    counter: const Offstage(),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          width: 2, color: Colors.black12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            width: 2, color: Colors.purple))),
                              ),
                            ),
                          ),
                          Container(
                            height: 85,
                            child: AspectRatio(
                              aspectRatio: 0.6,
                              child: TextField(
                                controller: otp2,
                                autofocus: true,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                  if (value.length == 0) {
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                                showCursor: false,
                                readOnly: false,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                decoration: InputDecoration(
                                    counter: const Offstage(),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          width: 2, color: Colors.black12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            width: 2, color: Colors.purple))),
                              ),
                            ),
                          ),
                          Container(
                            height: 85,
                            child: AspectRatio(
                              aspectRatio: 0.6,
                              child: TextField(
                                controller: otp3,
                                autofocus: true,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                  if (value.length == 0) {
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                                showCursor: false,
                                readOnly: false,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                decoration: InputDecoration(
                                    counter: const Offstage(),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          width: 2, color: Colors.black12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            width: 2, color: Colors.purple))),
                              ),
                            ),
                          ),
                          Container(
                            height: 85,
                            child: AspectRatio(
                              aspectRatio: 0.6,
                              child: TextField(
                                controller: otp4,
                                autofocus: true,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                  if (value.length == 0) {
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                                showCursor: false,
                                readOnly: false,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                decoration: InputDecoration(
                                    counter: const Offstage(),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          width: 2, color: Colors.black12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            width: 2, color: Colors.purple))),
                              ),
                            ),
                          ),
                          Container(
                            height: 85,
                            child: AspectRatio(
                              aspectRatio: 0.6,
                              child: TextField(
                                controller: otp5,
                                autofocus: true,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                  if (value.length == 0) {
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                                showCursor: false,
                                readOnly: false,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                decoration: InputDecoration(
                                    counter: const Offstage(),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          width: 2, color: Colors.black12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            width: 2, color: Colors.purple))),
                              ),
                            ),
                          ),
                          Container(
                            height: 85,
                            child: AspectRatio(
                              aspectRatio: 0.6,
                              child: TextField(
                                controller: otp6,
                                autofocus: true,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    // FocusScope.of(context).nextFocus();
                                  }
                                  if (value.length == 0) {
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                                showCursor: false,
                                readOnly: false,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                decoration: InputDecoration(
                                    counter: const Offstage(),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          width: 2, color: Colors.black12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            width: 2, color: Colors.purple))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text("Haven't recived OTP yet? "),
                        resendTime == 0
                            ? GestureDetector(
                                onTap: () {
                                  resendTime = 30;
                                  startTimer();
                                },
                                child: const Text(
                                  'Resend',
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                            : SizedBox()
                      ],
                    ),
                    Row(
                      children: [
                        resendTime != 0
                            ? Text(
                                "you can resend OTP after ${strFormatting(resendTime)} second(s)")
                            : SizedBox(),
                      ],
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () async {
                        if (formkey.currentState!.validate()) {
                          String otp = otp1.text +
                              otp2.text +
                              otp3.text +
                              otp4.text +
                              otp5.text +
                              otp6.text;
                          if (await myauth.verifyOTP(otp: otp) == true) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("OTP is verified"),
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Invalid OTP"),
                            ));
                          }
                          stopTmer();
                          otp1.clear();
                          otp2.clear();
                          otp3.clear();
                          otp4.clear();
                          otp5.clear();
                          otp6.clear();
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
                              "Verify",
                              style: TextStyle(
                                  color: Colors.white,
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
