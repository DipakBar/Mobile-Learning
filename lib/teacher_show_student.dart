import 'package:flutter/material.dart';
import 'package:flutter_application_2/constractor/allStudentDetails.dart';

import 'package:flutter_application_2/utils.dart';

// ignore: must_be_immutable
class TeacherShowStudent extends StatefulWidget {
  // const TeacherShowStudent({super.key});
  allStudentDetais sdetails;
  TeacherShowStudent(this.sdetails);

  @override
  State<TeacherShowStudent> createState() => _TeacherShowStudentState(sdetails);
}

class _TeacherShowStudentState extends State<TeacherShowStudent> {
  allStudentDetais sdetails;
  _TeacherShowStudentState(this.sdetails);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
                Container(
                  height: 60,
                  child: const Center(
                      child: Text(
                    'PROFILE  INFO',
                    style: TextStyle(fontSize: 25),
                  )),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 25),
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45)),
                  color: Colors.black,
                ),
                child: Container(
                  padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
                  child: ListView(children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.blueAccent, width: 5),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                        child: sdetails.image == 'no image'
                            ? CircleAvatar(
                                radius: 70.0,
                                backgroundColor: Colors.black,
                                child: Image.asset(
                                  "assets/images/default.png",
                                  height: 150,
                                  width: 160,
                                ),
                              )
                            : CircleAvatar(
                                radius: 70.0,
                                backgroundImage: NetworkImage(
                                  MyUrl.fullurl +
                                      MyUrl.Studentimageurl +
                                      sdetails.image,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 5),
                                color: Colors.blue.withOpacity(.5),
                                spreadRadius: 2,
                                blurRadius: 8)
                          ]),
                      child: ListTile(
                        title: const Text("id"),
                        subtitle: Text(sdetails.id),
                        leading: const Icon(Icons.info_rounded),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 5),
                                color: Colors.blue.withOpacity(.5),
                                spreadRadius: 2,
                                blurRadius: 8)
                          ]),
                      child: ListTile(
                        title: const Text("name"),
                        subtitle: Text(sdetails.name),
                        leading: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 5),
                                color: Colors.blue.withOpacity(.5),
                                spreadRadius: 2,
                                blurRadius: 8)
                          ]),
                      child: ListTile(
                        title: const Text("Email"),
                        subtitle: Text(sdetails.email),
                        leading: Icon(Icons.email_rounded),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 5),
                                color: Colors.blue.withOpacity(.5),
                                spreadRadius: 2,
                                blurRadius: 8)
                          ]),
                      child: ListTile(
                        title: const Text("Password"),
                        subtitle: Text(sdetails.pass),
                        leading: const Icon(Icons.lock),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 5),
                                color: Colors.blue.withOpacity(.5),
                                spreadRadius: 2,
                                blurRadius: 8)
                          ]),
                      child: ListTile(
                        leading: const Icon(Icons.phone_android),
                        title: const Text("Mobile no."),
                        subtitle: Text(sdetails.mobile),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 5),
                                color: Colors.blue.withOpacity(.5),
                                spreadRadius: 2,
                                blurRadius: 8)
                          ]),
                      child: ListTile(
                        leading: const Icon(Icons.phone_android),
                        title: const Text("Course"),
                        subtitle: Text(sdetails.course),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Center(
                        child: Text(
                      'DIPAK',
                      style: TextStyle(color: Colors.blue, fontSize: 15),
                    ))
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
