// ignore_for_file: must_be_immutable, use_build_context_synchronously, prefer_const_constructors
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/constractor/studentdetails.dart';

import 'package:flutter_application_2/loadingpage.dart';
import 'package:flutter_application_2/student_department_page.dart';

import 'package:flutter_application_2/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StudentDeshboard extends StatefulWidget {
  StudentDetails details;
  StudentDeshboard(this.details);

  @override
  State<StudentDeshboard> createState() => _StudentDeshboardState(details);
}

class _StudentDeshboardState extends State<StudentDeshboard> {
  StudentDetails details;
  _StudentDeshboardState(this.details);
  GlobalKey<FormState> namekey = GlobalKey();
  TextEditingController name = TextEditingController();
  late StreamSubscription<ConnectivityResult> subscription;
  String connectionStatus = 'Unknown';
  var isDeviceConnected = false;
  bool isAlertSet = false;
  File? pickedImage;

  imagePickerOption() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        content: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
          height: 180,
          child: Column(
            children: [
              Text(
                "Pic Image From",
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera).whenComplete(() {
                    UpdateImage(pickedImage!, details.email);
                  });
                },
                icon: Icon(
                  Icons.camera,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                label: Text(
                  "CAMERA",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery).whenComplete(() {
                    UpdateImage(pickedImage!, details.email);
                  });
                },
                icon: Icon(
                  Icons.image,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                label: Text(
                  "GALLERY",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.cancel,
                  color: Theme.of(context).colorScheme.onError,
                ),
                label: Text(
                  "CANCEL",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onError,
                  ),
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
          "POST", Uri.parse(MyUrl.fullurl + "student_image_update.php"));

      request.files.add(await http.MultipartFile.fromBytes(
          'image', uploadpic.readAsBytesSync(),
          filename: uploadpic.path.split("/").last));
      request.fields['email'] = email;

      var response = await request.send();

      var responded = await http.Response.fromStream(response);
      var jsondata = jsonDecode(responded.body);
      if (jsondata['status'] == true) {
        var sp = await SharedPreferences.getInstance();

        details.image = jsondata['imgtitle'];
        sp.setString("image", details.image);

        setState(() {});
        Navigator.pop(context);

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
    var sharedPref = await SharedPreferences.getInstance();
    if (namekey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return LoadingDiologPage();
          });
      try {
        var res = await http.post(
            Uri.http(MyUrl.mainurl, MyUrl.suburl + "student_name_update.php"),
            body: data);

        var jsondata = jsonDecode(res.body);
        if (jsondata['status'] == true) {
          Navigator.of(context).pop();
          Navigator.pop(context);
          details.name = jsondata["name"].toString();
          sharedPref.setString("name", jsondata["name"].toString());

          setState(() {});
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

  startMonitoringConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      setState(() {
        if (result == ConnectivityResult.none) {
          showDiaLogBox();
          setState(() {
            isAlertSet = true;
          });
          // connectionStatus = 'No Internet Connection';
          // Fluttertoast.showToast(msg: connectionStatus);
        } else if (result == ConnectivityResult.wifi) {
          connectionStatus = 'Connected to Wi-Fi';
          Fluttertoast.showToast(msg: connectionStatus);
        } else if (result == ConnectivityResult.mobile) {
          connectionStatus = 'Connected to Mobile Data';
          Fluttertoast.showToast(msg: connectionStatus);
        }
      });
    });
    return connectionStatus;
  }

  void stopMonitoringConnectivity() {
    subscription.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      startMonitoringConnectivity();
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  getData() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => StudentDepartmentScreen(details)));
  }

  Widget imageShow(String image) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  maxRadius: 150,
                  child: ClipOval(
                    child: Container(
                      width: 300,
                      height: 300,
                      color: Colors.grey[200], // Placeholder background color
                    ),
                  ),
                ),
                Positioned(
                  child: CircularProgressIndicator(),
                ),
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  maxRadius: 150,
                  foregroundImage: NetworkImage(
                    MyUrl.fullurl + MyUrl.Studentimageurl + image,
                  ),
                  onForegroundImageError: (exception, stackTrace) {
                    // Handle error here if needed
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget imageShow(image) {
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.pop(context);
  //       Navigator.pop(context);
  //     },
  //     child: BackdropFilter(
  //       filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
  //       child: Container(
  //         color: Colors.transparent,
  //         child: Center(
  //           child: CircleAvatar(
  //               backgroundColor: Colors.transparent,
  //               maxRadius: 150,
  //               foregroundImage: NetworkImage(
  //                 MyUrl.fullurl + MyUrl.Studentimageurl + image,
  //               )),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget defalut() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: Colors.transparent,
          child: const Center(
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              maxRadius: 150,
              foregroundImage: AssetImage(
                "assets/images/default.png",
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () => getData(),
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
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
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).colorScheme.background,
                      )),
                  Container(
                    height: 60,
                    child: Center(
                        child: Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.4,
                        color: Theme.of(context).colorScheme.background,
                      ),
                    )),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 25),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(45)),
                    color: Theme.of(context).colorScheme.background,
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(left: 15, top: 5, right: 15),
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
                                  ? CircleAvatar(
                                      radius: 80,
                                      backgroundImage: FileImage(
                                        pickedImage!,
                                      ),
                                    )
                                  : details.image == 'no image'
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
                                          height: 150,
                                          width: 150,
                                          imageUrl: MyUrl.fullurl +
                                              MyUrl.Studentimageurl +
                                              details.image,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: imageProvider),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
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
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        context: context,
                                        builder: ((context) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: ListTile(
                                                  leading: Icon(
                                                    Icons.cancel,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onError,
                                                  ),
                                                  title: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onError),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return details.image ==
                                                                'no image'
                                                            ? defalut()
                                                            : imageShow(
                                                                details.image);
                                                      });
                                                },
                                                child: ListTile(
                                                  leading: Icon(
                                                    Icons.person,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onBackground,
                                                  ),
                                                  title: Text(
                                                    'See profile picture',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onBackground),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: imagePickerOption,
                                                child: ListTile(
                                                  leading: Icon(
                                                    Icons.image_sharp,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onBackground,
                                                  ),
                                                  title: Text(
                                                    'Choose profile picture',
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onBackground,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      );
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
                        height: 30,
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
                            "Name",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                          subtitle: Text(
                            details.name,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                          leading: Icon(
                            Icons.person,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              name.text = details.name;
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      child: AlertDialog(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        title: Text(
                                          "Enter your name",
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                        ),
                                        content: Form(
                                          key: namekey,
                                          child: TextFormField(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            controller: name,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'please enter name';
                                              } else if (value.length < 2) {
                                                return 'To short';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onBackground,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onBackground,
                                                  ),
                                                )),
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
                                                  updatename(
                                                      details.email, name.text);
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
                          leading: Icon(
                            Icons.email_rounded,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          title: Text(
                            "Email",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                          subtitle: Text(
                            details.email,
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
                          title: Text(
                            "Password",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                          subtitle: Text(
                            details.pass,
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
                            details.mobile,
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
                                blurRadius: 8,
                              )
                            ]),
                        child: ListTile(
                          leading: Icon(
                            Icons.school,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          title: Text(
                            "Course",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                          subtitle: Text(
                            details.course,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ),
                      ),
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

  showDiaLogBox() => showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
            title: const Text('No Connection'),
            content: const Text('Please check your internet connection'),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context, 'Cancel');
                    setState(() {
                      isAlertSet = false;
                    });
                    isDeviceConnected =
                        await InternetConnectionChecker().hasConnection;
                    if (!isDeviceConnected) {
                      showDiaLogBox();
                      setState(() {
                        isAlertSet = true;
                      });
                    }
                  },
                  child: const Text('ok')),
            ],
          ));
}
