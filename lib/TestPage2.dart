// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter_application_2/details.dart';
// import 'package:flutter_application_2/utils.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:flutter_file_downloader/flutter_file_downloader.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:pdfx/pdfx.dart';

// class TestPage2 extends StatefulWidget {
//   const TestPage2({super.key});

//   @override
//   State<TestPage2> createState() => _TestPage2State();
// }

// class _TestPage2State extends State<TestPage2> {
//   List<pdf> studentpdf = [];
//   Future getUserdata() async {
//     try {
//       var response = await http.get(
//         // ignore: prefer_interpolation_to_compose_strings
//         Uri.http(MyUrl.mainurl, MyUrl.suburl + "get_pdf.php"),
//       );
//       var jsondata = jsonDecode(response.body.toString());

//       if (jsondata["status"] == true) {
//         studentpdf.clear();
//         for (int i = 0; i < jsondata['data'].length; i++) {
//           pdf data = pdf(
//             id: jsondata['data'][i]['id'].toString(),
//             pdffile: jsondata['data'][i]['pdffile'].toString(),
//             mobile: jsondata['data'][i]['mobile'].toString(),
//           );
//           setState(() {
//             studentpdf.add(data);
//           });
//         }
//       }
//       // ignore: use_build_context_synchronously
//       else {
//         Fluttertoast.showToast(
//           msg: jsondata['msg'],
//         );
//       }

//       return studentpdf;
//     } catch (e) {
//       print(e.toString());
//       Fluttertoast.showToast(
//         msg: e.toString(),
//       );
//     }
//   }

//   late PdfControllerPinch pdfControllerPinch;
//   String name = 'assets/pdf/SUMANMAISHAL_34001221042_E-COMMERCE.pdf';
//   var process = 0.0;
//   int totalPageCount = 0;
//   int currentPage = 1;
//   @override
//   void initState() {
//     getUserdata();
//     super.initState();
//     pdfControllerPinch = PdfControllerPinch(
//         document: PdfDocument.openAsset(
//             'assets/pdf/SUMANMAISHAL_34001221042_E-COMMERCE.pdf'));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('PDF VIEW'),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 FileDownloader.downloadFile(
//                   url: name.toString(),
//                   onDownloadError: (errorMessage) {
//                     print('error:$errorMessage');
//                   },
//                   onDownloadCompleted: (path) {
//                     final File file = File(path);
//                     print(file);
//                   },
//                   onProgress: (fileName, progress) {
//                     setState(() {
//                       process = progress;
//                     });
//                   },
//                 );
//               },
//               icon: Icon(Icons.download))
//         ],
//       ),
//       // backgroundColor: Colors.blueAccent,

//       body: buildUI(),
//     );
//   }

//   Widget buildUI() {
//     return Column(
//       children: [
//         Row(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text('Total Page :${totalPageCount}'),
//             IconButton(
//                 onPressed: () {
//                   pdfControllerPinch.previousPage(
//                       duration: Duration(milliseconds: 2),
//                       curve: Curves.linear);
//                 },
//                 icon: Icon(Icons.arrow_back_ios)),
//             Text('Current Page :${currentPage}'),
//             IconButton(
//                 onPressed: () {
//                   pdfControllerPinch.nextPage(
//                       duration: Duration(milliseconds: 2),
//                       curve: Curves.linear);
//                 },
//                 icon: Icon(Icons.arrow_forward_ios))
//           ],
//         ),
//         Container(
//           height: 100,
//           width: process * 4,
//           color: Colors.red,
//         ),
//         Text('${process.toString()} %'),
//         pdfView()
//       ],
//     );
//   }

//   Widget pdfView() {
//     return Expanded(
//         child: PdfViewPinch(
//       controller: pdfControllerPinch,
//       onDocumentLoaded: (document) {
//         setState(() {
//           totalPageCount = document.pagesCount;
//         });
//       },
//       onPageChanged: (page) {
//         setState(() {
//           currentPage = page;
//         });
//       },
//     ));
//   }
// }
