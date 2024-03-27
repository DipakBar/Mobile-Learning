import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TeacherOTPValidation extends StatefulWidget {
  const TeacherOTPValidation({super.key});

  @override
  State<TeacherOTPValidation> createState() => _TeacherOTPValidationState();
}

class _TeacherOTPValidationState extends State<TeacherOTPValidation> {
  TextEditingController otp1 = TextEditingController();
  TextEditingController otp2 = TextEditingController();
  TextEditingController otp3 = TextEditingController();
  TextEditingController otp4 = TextEditingController();
  TextEditingController otp5 = TextEditingController();
  TextEditingController otp6 = TextEditingController();
  final formkey = GlobalKey<FormState>();
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
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        if (formkey.currentState!.validate()) {
                          String otp = otp1.text +
                              otp2.text +
                              otp3.text +
                              otp4.text +
                              otp5.text +
                              otp6.text;
                          print(otp.toString());
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
