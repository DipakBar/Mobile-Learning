import 'package:flutter/material.dart';
import 'package:flutter_application_2/add_yearly_question_paper.dart';

class UploadYearlyQuestionPager extends StatefulWidget {
  const UploadYearlyQuestionPager({super.key});

  @override
  State<UploadYearlyQuestionPager> createState() =>
      _UploadYearlyQuestionPagerState();
}

class _UploadYearlyQuestionPagerState extends State<UploadYearlyQuestionPager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Upload PDF',
        style: TextStyle(fontSize: 20),
      )),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.purple,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddQuestionPaper()));
        },
        label: const Text(
          'Add PDF',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
