import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/teacher_otp_validation.dart';
import 'package:lottie/lottie.dart';
import 'package:validators/validators.dart';

class TeacherForgetPassword extends StatefulWidget {
  const TeacherForgetPassword({super.key});

  @override
  State<TeacherForgetPassword> createState() => _TeacherForgetPasswordState();
}

class _TeacherForgetPasswordState extends State<TeacherForgetPassword> {
  TextEditingController email = TextEditingController();
  bool isEmailCorrect = false;
  EmailOTP myauth = EmailOTP();

  @override
  void dispose() {
    email.dispose();
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
                      'Enter Email',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: email,
                        onChanged: (value) {
                          setState(() {
                            isEmailCorrect = isEmail(value);
                          });
                        },
                        showCursor: true,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email),
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
                                    color: Colors.greenAccent, width: 1))),
                      ),
                    ),
                    const Spacer(),
                    Visibility(
                      visible: isEmailCorrect,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TeacherOTPValidation()));
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
                                "Send OTP",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic),
                              ),
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
