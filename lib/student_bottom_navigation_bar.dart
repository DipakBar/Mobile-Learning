import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/screen/Student_subject_pdf.dart';
import 'package:flutter_application_2/screen/student_subject_question_paper.dart';
import 'package:flutter_application_2/screen/student_subject_topic_video.dart';

class StudentBottomNavigationBar extends StatefulWidget {
  final String semester;
  final String subject_code;
  StudentBottomNavigationBar(
      {required this.semester, required this.subject_code});

  @override
  State<StudentBottomNavigationBar> createState() =>
      _StudentBottomNavigationBarState();
}

class _StudentBottomNavigationBarState
    extends State<StudentBottomNavigationBar> {
  PageController pageController = PageController();
  late String semester;
  late String subject_code;
  int selectedIndex = 0;
  List<Widget> screens = [];

  @override
  void initState() {
    super.initState();
    if (widget.semester != null) {
      semester = widget.semester;
      subject_code = widget.subject_code;
      screens = [
        StudentSubjectPDF(semester: semester, subject_code: subject_code),
        StudentSubjectQuestionPaper(
            semester: semester, subject_code: subject_code),
        StudentSubjectTopicVideo(semester: semester, subject_code: subject_code)
      ];
    }
  }

  void onPageChanged(int index) {
    if (mounted) {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  void onItemTapped(int i) {
    pageController.jumpToPage(i);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: PageView(
          controller: pageController,
          children: screens,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          buttonBackgroundColor: Theme.of(context).colorScheme.onBackground,
          animationDuration: const Duration(milliseconds: 300),
          color: Colors.lightBlue,
          items: [
            CurvedNavigationBarItem(
              child: Icon(
                Icons.file_copy_sharp,
                color: Theme.of(context).colorScheme.background,
              ),
              label: 'PDF',
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.background,
              ),
            ),
            CurvedNavigationBarItem(
              child: Icon(
                Icons.book_rounded,
                color: Theme.of(context).colorScheme.background,
              ),
              label: 'Question Paper',
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.background,
              ),
            ),
            CurvedNavigationBarItem(
              child: Icon(
                Icons.video_collection_sharp,
                color: Theme.of(context).colorScheme.background,
              ),
              label: 'Video',
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.background,
              ),
            ),
          ],
          index: selectedIndex,
          onTap: onItemTapped,
        ),
      ),
    );
  }
}
