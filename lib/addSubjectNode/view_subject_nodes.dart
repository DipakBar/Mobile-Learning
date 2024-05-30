import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/addSubjectNode/DownloadProgressDialog.dart';

import 'package:flutter_application_2/constractor/pdf.dart';
import 'package:flutter_application_2/utils.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class PDFViewerPage extends StatefulWidget {
  SubjectNodes nodes;
  PDFViewerPage(this.nodes);

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState(nodes);
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  SubjectNodes nodes;
  _PDFViewerPageState(this.nodes);
  // final _flutterMediaDownloaderPlugin = MediaDownload();
  String urlPDFPath = "";
  bool exists = true;
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  late PDFViewController _pdfViewController;
  bool loaded = false;

  Future<File> getFileFromUrl(String url, {name}) async {
    var fileName = 'testonline';
    if (name != null) {
      fileName = name;
    }
    try {
      var data = await http.get(Uri.parse(url));
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/" + fileName + ".pdf");
      print(dir.path);
      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  @override
  void initState() {
    getFileFromUrl(MyUrl.fullurl + MyUrl.subjectnodes + nodes.subject_nodes)
        .then(
      (value) => {
        setState(() {
          urlPDFPath = value.path;
          loaded = true;
          exists = true;
        })
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(urlPDFPath);
    if (loaded) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text('Subject nodes'),
          actions: [
            IconButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (dialogcontext) {
                        return DownloadProgressDialog(nodes);
                      });
                },
                icon: Icon(Icons.downloading_sharp))
          ],
        ),
        body: PDFView(
          filePath: urlPDFPath,
          autoSpacing: true,
          enableSwipe: true,
          pageSnap: true,
          swipeHorizontal: true,
          nightMode: false,
          onError: (e) {
            //Show some error message or UI
          },
          onRender: (_pages) {
            setState(() {
              _totalPages = _pages!;
              pdfReady = true;
            });
          },
          onViewCreated: (PDFViewController vc) {
            setState(() {
              _pdfViewController = vc;
            });
          },
          onPageChanged: (page, total) {
            setState(() {
              _currentPage = page!;
            });
          },
          onPageError: (page, e) {},
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.chevron_left),
              iconSize: 30,
              color: Colors.black,
              onPressed: () {
                setState(() {
                  if (_currentPage > 0) {
                    _currentPage--;
                    _pdfViewController.setPage(_currentPage);
                  }
                });
              },
            ),
            Text(
              "${_currentPage + 1}/$_totalPages",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            IconButton(
              icon: Icon(Icons.chevron_right),
              iconSize: 30,
              color: Colors.black,
              onPressed: () {
                setState(() {
                  if (_currentPage < _totalPages - 1) {
                    _currentPage++;
                    _pdfViewController.setPage(_currentPage);
                  }
                });
              },
            ),
          ],
        ),
      );
    } else {
      if (exists) {
        return const Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitFadingCircle(
                color: Colors.black,
                size: 90,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Loading....",
                style: TextStyle(fontSize: 12, color: Colors.black),
              )
            ],
          ),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            title: Text("Subject nodes"),
          ),
          body: const Center(
            child: Text(
              "PDF Not Available",
              style: TextStyle(fontSize: 20),
            ),
          ),
        );
      }
    }
  }
}

// class CustomSnackBar {
//   static show(BuildContext context) {
//     SnackBar snackBar = SnackBar(
//       content: Container(
//         width: double.infinity,
//         height: 80,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           border: Border.all(
//             color: Colors.lightBlue,
//           ),
//           color: Colors.orange.withAlpha(100),
//         ),
//         child: Row(
//           children: [],
//         ),
//       ),
//       margin: const EdgeInsets.symmetric(horizontal: 10),
//       duration: const Duration(seconds: 3),
//       backgroundColor: Colors.transparent,
//       behavior: SnackBarBehavior.floating,
//     );

//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
// }
