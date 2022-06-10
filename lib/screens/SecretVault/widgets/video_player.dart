import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:hidden_hiding_app/screens/SecretVault/models/storage_item.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerWidget extends StatefulWidget {
  final StorageItem mediaFile;
  final bool isExpandedVideo;
  const VideoPlayerWidget(
      {Key? key, required this.mediaFile, required this.isExpandedVideo})
      : super(key: key);
  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.mediaFile.key))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    chewieController = ChewieController(
      videoPlayerController: _controller,
      looping: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? GestureDetector(
            onTap: widget.isExpandedVideo
                ? () {
                    setState(() {
                      _controller.value.isPlaying
                          ? chewieController.pause()
                          : chewieController.play();
                    });
                  }
                : null,
            child: widget.isExpandedVideo
                ? Chewie(controller: chewieController)
                : VideoPlayer(_controller),
          )
        : Container();
  }
}
