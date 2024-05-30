import 'package:cached_network_image/cached_network_image.dart';
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
      backgroundColor: Colors.lightBlue,
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
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).colorScheme.background,
                    )),
                Container(
                  height: 60,
                  child: Center(
                      child: Text(
                    'PROFILE',
                    style: TextStyle(
                      fontSize: 25,
                      color: Theme.of(context).colorScheme.background,
                    ),
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
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45)),
                  color: Theme.of(context).colorScheme.background,
                ),
                child: Container(
                  padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
                  child: ListView(children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.lightBlue, width: 5),
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
                            : CachedNetworkImage(
                                imageUrl: MyUrl.fullurl +
                                    MyUrl.Studentimageurl +
                                    sdetails.image,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  height: 130,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(90),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 5),
                                color: Colors.blue.withOpacity(.5),
                                spreadRadius: 2,
                                blurRadius: 8)
                          ]),
                      child: ListTile(
                        title: Text(
                          "name",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        subtitle: Text(
                          sdetails.name,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        leading: Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 5),
                                color: Colors.blue.withOpacity(.5),
                                spreadRadius: 2,
                                blurRadius: 8)
                          ]),
                      child: ListTile(
                        title: Text(
                          "Email",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        subtitle: Text(
                          sdetails.email,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        leading: Icon(
                          Icons.email_rounded,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 5),
                                color: Colors.blue.withOpacity(.5),
                                spreadRadius: 2,
                                blurRadius: 8)
                          ]),
                      child: ListTile(
                        title: Text(
                          "Password",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        subtitle: Text(
                          sdetails.pass,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        leading: Icon(
                          Icons.lock,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 5),
                                color: Colors.blue.withOpacity(.5),
                                spreadRadius: 2,
                                blurRadius: 8)
                          ]),
                      child: ListTile(
                        leading: Icon(
                          Icons.phone_android,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        title: Text(
                          "Mobile no.",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        subtitle: Text(
                          sdetails.mobile,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 5),
                                color: Colors.blue.withOpacity(.5),
                                spreadRadius: 2,
                                blurRadius: 8)
                          ]),
                      child: ListTile(
                        leading: Icon(
                          Icons.school_outlined,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        title: Text(
                          "Course",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        subtitle: Text(
                          sdetails.course,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
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
