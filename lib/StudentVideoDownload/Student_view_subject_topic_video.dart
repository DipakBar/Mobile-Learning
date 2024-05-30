import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/StudentVideoDownload/StudentTopicVideoDownloadProcessDialog.dart';
import 'package:flutter_application_2/studentMobel/studentGetTopicVideo.dart';
import 'package:flutter_application_2/utils.dart';

import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class StudentViewSubjectTopic extends StatefulWidget {
  StudentGetSubjectTopicVideo topicVideo;
  StudentViewSubjectTopic(this.topicVideo);

  @override
  State<StudentViewSubjectTopic> createState() =>
      _StudentViewSubjectTopicState(topicVideo);
}

class _StudentViewSubjectTopicState extends State<StudentViewSubjectTopic> {
  StudentGetSubjectTopicVideo topicVideo;
  _StudentViewSubjectTopicState(this.topicVideo);
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  int? bufferDelay;
  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();

    super.dispose();
  }

  Future<void> initializePlayer() async {
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
        MyUrl.fullurl + MyUrl.SubjectTopicVides + topicVideo.topic_video));

    await Future.wait([
      videoPlayerController.initialize(),
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
      draggableProgressBar: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
          'video',
          style: TextStyle(color: Theme.of(context).colorScheme.background),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (dialogcontext) {
                    return StudentTopicVideoDownloadingProcessIndecator(
                      topicVideo,
                    );
                  });
            },
            icon: Icon(
              Icons.downloading,
              color: Theme.of(context).colorScheme.background,
            ),
          )
        ],
      ),
      body: Center(
        child: chewieController != null &&
                chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(
                controller: chewieController!,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Loading',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
