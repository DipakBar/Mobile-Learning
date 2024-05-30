import 'package:flutter/material.dart';
import 'package:flutter_application_2/StudentSubjectNodeDownload/StudentDownloadProgressDialog.dart';
import 'dart:io';
import 'package:flutter_application_2/addSubjectNode/DownloadProgressDialog.dart';
import 'package:flutter_application_2/studentMobel/StudentGetNodes.dart';

import 'package:flutter_application_2/utils.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class StudentViewSubjectNodes extends StatefulWidget {
  StudentGetNodes node;
  StudentViewSubjectNodes(this.node);

  @override
  State<StudentViewSubjectNodes> createState() =>
      _StudentViewSubjectNodesState(node);
}

class _StudentViewSubjectNodesState extends State<StudentViewSubjectNodes> {
  StudentGetNodes node;
  _StudentViewSubjectNodesState(this.node);
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
    print(MyUrl.fullurl + MyUrl.subjectnodes + node.sub_nodes);
    getFileFromUrl(MyUrl.fullurl + MyUrl.subjectnodes + node.sub_nodes).then(
      (value) => {
        setState(() {
          urlPDFPath = value.path;
          loaded = true;
          exists = false;
        })
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(urlPDFPath);
    if (loaded) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text(
            'Subject nodes',
            style: TextStyle(
              color: Theme.of(context).colorScheme.background,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (dialogcontext) {
                        return StudentDownloadProgressDialog(node);
                      });
                },
                icon: const Icon(
                  Icons.downloading_sharp,
                  color: Colors.white,
                ))
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
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitFadingCircle(
                color: Theme.of(context).colorScheme.onBackground,
                size: 90,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Loading....",
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
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
