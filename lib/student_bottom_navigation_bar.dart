import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/screen/Student_subject_pdf.dart';
import 'package:flutter_application_2/screen/student_subject_question_paper.dart';
import 'package:flutter_application_2/screen/student_subject_topic_video.dart';

class StudentBottomNavigationBar extends StatefulWidget {
  const StudentBottomNavigationBar({super.key});

  @override
  State<StudentBottomNavigationBar> createState() =>
      _StudentBottomNavigationBarState();
}

class _StudentBottomNavigationBarState
    extends State<StudentBottomNavigationBar> {
  PageController pageController = PageController();
  int selectedIndex = 0;
  List<Widget> screens = [
    const StudentSubjectPDF(),
    const StudentSubjectQuestionPaper(),
    const StudentSubjectTopicVideo()
  ];
  void onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void onItemTapped(int i) {
    pageController.jumpToPage(i);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: PageView(
        controller: pageController,
        // ignore: sort_child_properties_last
        children: screens,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.green,
        animationDuration: const Duration(milliseconds: 300),
        color: Colors.black,
        items: const [
          CurvedNavigationBarItem(
            child: Icon(Icons.file_copy_sharp, color: Colors.white),
            label: 'PDF',
            labelStyle: TextStyle(color: Colors.white),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.book_rounded, color: Colors.white),
            label: 'Question Paper',
            labelStyle: TextStyle(color: Colors.white),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.video_collection_sharp, color: Colors.white),
            label: 'Video',
            labelStyle: TextStyle(color: Colors.white),
          ),
        ],
        index: selectedIndex,
        onTap: onItemTapped,
      ),
    ));
  }
}
