import 'package:flutter/material.dart';
import 'package:flutter_application_2/add_video.dart';

class UploadVideo extends StatefulWidget {
  const UploadVideo({super.key});

  @override
  State<UploadVideo> createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Upload Video',
        style: TextStyle(fontSize: 20),
      )),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.purple,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddVideo()));
        },
        label: const Text(
          'Add Video',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
