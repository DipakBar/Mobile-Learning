import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/constractor/teacherDetails.dart';
import 'package:flutter_application_2/loadingpage.dart';
import 'package:flutter_application_2/teacher_home_page.dart';
import 'package:flutter_application_2/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class TeacherDeshbord extends StatefulWidget {
  TeacherDetails tdetails;
  TeacherDeshbord(this.tdetails);

  @override
  State<TeacherDeshbord> createState() => _TeacherDeshbordState(tdetails);
}

class _TeacherDeshbordState extends State<TeacherDeshbord> {
  TeacherDetails tdetails;
  _TeacherDeshbordState(this.tdetails);
  GlobalKey<FormState> namekey = GlobalKey();
  TextEditingController name = TextEditingController();

  File? pickedImage;

  imagePickerOption() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
          height: 180,
          child: Column(
            children: [
              const Text(
                "Pic Image From",
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera).whenComplete(() {
                    UpdateImage(pickedImage!, tdetails.email);
                  });
                },
                icon: const Icon(
                  Icons.camera,
                  color: Colors.black,
                ),
                label: const Text(
                  "CAMERA",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery).whenComplete(() {
                    UpdateImage(pickedImage!, tdetails.email);
                  });
                },
                icon: const Icon(
                  Icons.image,
                  color: Colors.black,
                ),
                label: const Text(
                  "GALLERY",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                label: const Text(
                  "CANCEL",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future pickImage(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });

      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future UpdateImage(File uploadpic, String email) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDiologPage();
      },
    );

    try {
      var request = http.MultipartRequest(
          "POST", Uri.parse(MyUrl.fullurl + "teacher_image_update.php"));
      var sp = await SharedPreferences.getInstance();
      request.files.add(await http.MultipartFile.fromBytes(
          'image', uploadpic.readAsBytesSync(),
          filename: uploadpic.path.split("/").last));
      request.fields['email'] = email;

      var response = await request.send();

      var responded = await http.Response.fromStream(response);
      var jsondata = jsonDecode(responded.body);
      if (jsondata['status'] == true) {
        tdetails.image = jsondata['imgtitle'];

        sp.setString("timage", jsondata['imgtitle'].toString());
        print(sp);
        print(sp.setString("timage", jsondata['imgtitle'].toString()));

        setState(() {});
        Navigator.pop(context);

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
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: e.toString(),
      );
    }
  }

  Future<void> updatename(String email, String name) async {
    Map data = {'email': email, 'name': name};
    print(data);
    var sharedPref = await SharedPreferences.getInstance();
    if (namekey.currentState!.validate()) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return const LoadingDiologPage();
          });
      try {
        var res = await http.post(
            Uri.http(MyUrl.mainurl, MyUrl.suburl + "teacher_name_update.php"),
            body: data);

        var jsondata = jsonDecode(res.body);
        if (jsondata['status'] == true) {
          Navigator.of(context).pop();
          Navigator.pop(context);
          tdetails.name = jsondata["name"].toString();
          sharedPref.setString("tname", jsondata["name"].toString());

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
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: jsondata['msg'],
          );
        }
      } catch (e) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  getData() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => TeacherHomeScreen(tdetails)));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => getData(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        getData();
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
                    padding:
                        const EdgeInsets.only(left: 15, top: 20, right: 15),
                    child: ListView(children: [
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.blueAccent, width: 5),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              child: pickedImage != null
                                  ? ClipOval(
                                      child: Image.file(
                                        pickedImage!,
                                        height: 150,
                                        width: 160,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : tdetails.image == 'no image'
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
                                                MyUrl.Teacherimageurl +
                                                tdetails.image,
                                          ),
                                        ),
                            ),
                            Positioned(
                                bottom: 1,
                                right: 1,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  // ignore: sort_child_properties_last
                                  child: IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: ((context) {
                                            return Container(
                                              height: 150,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      TextButton(
                                                          onPressed: () {},
                                                          child: const Text(
                                                            "Wiew profile image",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 20,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic),
                                                          )),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      TextButton(
                                                          onPressed:
                                                              imagePickerOption,
                                                          child: const Text(
                                                            "Edit profile image",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 20,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic),
                                                          ))
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          }));
                                    },
                                    icon: const Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                    ),
                                  ),
                                  decoration: const BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                ))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
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
                          subtitle: Text(tdetails.name),
                          leading: const Icon(Icons.person),
                          trailing: IconButton(
                            onPressed: () {
                              name.text = tdetails.name;
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      child: AlertDialog(
                                        title: const Text("Enter your name"),
                                        content: Form(
                                          key: namekey,
                                          child: TextFormField(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            controller: name,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'please enter name';
                                              } else if (value.length < 2) {
                                                return 'To short';
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                "CANCLE",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              )),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                if (namekey.currentState!
                                                    .validate()) {
                                                  updatename(tdetails.email,
                                                      name.text);
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Please Enter Your Name");
                                                }
                                              },
                                              child: const Text(
                                                "OK",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ))
                                        ],
                                      ),
                                    );
                                  });
                            },
                            icon: const Icon(Icons.edit),
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
                          title: const Text("Email"),
                          subtitle: Text(tdetails.email),
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
                          subtitle: Text(tdetails.pass),
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
                          subtitle: Text(tdetails.mobile),
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
      ),
    );
  }
}
