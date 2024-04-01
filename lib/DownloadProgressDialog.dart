import 'package:flutter/material.dart';
import 'package:flutter_application_2/FileDownload.dart';
import 'package:flutter_application_2/constractor/Download_url.dart';
import 'package:flutter_application_2/constractor/pdf.dart';
import 'package:flutter_application_2/utils.dart';

// ignore: must_be_immutable
class DownloadProgressDialog extends StatefulWidget {
  SubjectNodes nodes;
  DownloadProgressDialog(this.nodes);
  @override
  State<DownloadProgressDialog> createState() =>
      _DownloadProgressDialogState(nodes);
}

class _DownloadProgressDialogState extends State<DownloadProgressDialog> {
  SubjectNodes nodes;
  _DownloadProgressDialogState(this.nodes);
  double progress = 0.0;

  @override
  void initState() {
    _startDownload();
    super.initState();
  }

  void _startDownload() {
    DownloadUrl.url = MyUrl.fullurl + MyUrl.subjectnodes + nodes.pdf;
    FileName.fileName = nodes.pdf;
    FileDownload().startDownloading(context, (recivedBytes, totalBytes) {
      setState(() {
        progress = recivedBytes / totalBytes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String downloadingProgress = (progress * 100).toInt().toString();
    return AlertDialog(
        content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: const Text(
            "Downloading",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey,
          color: Colors.green,
          minHeight: 10,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            "$downloadingProgress %",
          ),
        )
      ],
    ));
  }
}
