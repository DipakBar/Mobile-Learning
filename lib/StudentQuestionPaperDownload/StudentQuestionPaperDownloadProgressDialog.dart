import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/studentMobel/studentGetQuestionPaper.dart';
import 'package:flutter_application_2/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

// ignore: must_be_immutable
class StudentQuestionPaperDownloadProcessDialog extends StatefulWidget {
  StudentGetQuestionPaper questionPaper;
  StudentQuestionPaperDownloadProcessDialog(this.questionPaper);

  @override
  State<StudentQuestionPaperDownloadProcessDialog> createState() =>
      _StudentQuestionPaperDownloadProcessDialogState(questionPaper);
}

class _StudentQuestionPaperDownloadProcessDialogState
    extends State<StudentQuestionPaperDownloadProcessDialog> {
  StudentGetQuestionPaper questionPaper;
  _StudentQuestionPaperDownloadProcessDialogState(this.questionPaper);
  double progress = 0.0;
  late ProgressDialog pd;
  bool _isDownloading = false;
  bool isSuccess = false;
  @override
  void initState() {
    super.initState();
    pd = ProgressDialog(context: context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDownloading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startDownload();
      });
      _isDownloading = true;
    }
  }

  Future<String> _getFilePath(String filename) async {
    Directory? dir;

    try {
      if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory(); // for iOS
      } else {
        dir = Directory('/storage/emulated/0/Download/'); // for android
        if (!await dir.exists()) dir = (await getExternalStorageDirectory())!;
      }
    } catch (err) {
      print("Cannot get download folder path $err");
    }
    return "${dir?.path}$filename";
  }

  void _startDownload() async {
    pd.show(
      max: 100,
      msg: 'Downloading...',
    );
    try {
      String fileName = questionPaper.question_paper;
      String baseUrl =
          MyUrl.fullurl + MyUrl.questionpapers + questionPaper.question_paper;
      String path = await _getFilePath(fileName);
      Dio dio = Dio();
      await dio.download(
        baseUrl,
        path,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              progress = received / total;
              pd.update(value: (progress * 100).toInt());
            });
          }
        },
      ).then((_) {
        isSuccess = true;
      });

      pd.close();
    } catch (e) {
      pd.close();

      print('Download error: $e');
    }
    if (isSuccess) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
        id: 1,
        channelKey: "basic_channel",
        body: "Download sucessfull",
        //  payload: {'pdfPath': path},
      ));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
