import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/constractor/topic_video.dart';
import 'package:flutter_application_2/utils.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  SubjectTopicVideo video;
  VideoPlayerScreen(this.video);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState(video);
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  SubjectTopicVideo video;
  _VideoPlayerScreenState(this.video);

  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  int? bufferDelay;
  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(MyUrl.fullurl + MyUrl.SubjectTopicVides + video.topic_video));

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
  void dispose() {
    super.dispose();
    // Pause and dispose of the video player controller
    videoPlayerController.pause();
    videoPlayerController.dispose();
    // Dispose of the chewie controller
    chewieController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'video',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.downloading))
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
                  SizedBox(height: 20),
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
