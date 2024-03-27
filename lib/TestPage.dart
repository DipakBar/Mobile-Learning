import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_application_2/utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_application_2/TestPage2.dart';
import 'package:flutter_application_2/loadingpage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  File? pickedFile;
  String mobile = '7047189337';
  pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result == null) return;
      File tempFile = File(result.files.single.path!);
      setState(() {
        pickedFile = tempFile;
        var pickName = result.files.single.name;
        print(pickName);
        print(pickedFile);
        upload(mobile, pickedFile);
      });
      Get.back();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future upload(
    String mobile,
    File? filepath,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDiologPage();
      },
    );
    try {
      var request =
          http.MultipartRequest("POST", Uri.parse("${MyUrl.fullurl}file.php"));

      request.fields["mobile"] = mobile;

      request.files.add(await http.MultipartFile.fromBytes(
          "file", filepath!.readAsBytesSync(),
          filename: filepath.path.split("/").last));

      var response = await request.send();
      var responded = await http.Response.fromStream(response);
      var jsondata = jsonDecode(responded.body);
      if (jsondata['status'] == true) {
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
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
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF UPLOAD'),
        actions: [
          InkWell(
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: ((context) => TestPage2())));
              },
              child: const Icon(Icons.arrow_forward_ios))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          pickFile();
        },
      ),
    );
  }
}
