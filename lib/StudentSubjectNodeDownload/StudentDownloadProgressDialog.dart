import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_2/studentMobel/StudentGetNodes.dart';
import 'package:flutter_application_2/utils.dart';

class StudentDownloadProgressDialog extends StatefulWidget {
  final StudentGetNodes node;
  StudentDownloadProgressDialog(this.node);

  @override
  State<StudentDownloadProgressDialog> createState() =>
      _StudentDownloadProgressDialogState(node);
}

class _StudentDownloadProgressDialogState
    extends State<StudentDownloadProgressDialog> {
  final StudentGetNodes node;
  _StudentDownloadProgressDialogState(this.node);
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
      String fileName = node.sub_nodes;
      String baseUrl = MyUrl.fullurl + MyUrl.subjectnodes + node.sub_nodes;
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
