import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:hidden_hiding_app/screens/SecretVault/models/storage_item.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerScreen extends StatefulWidget {
  final StorageItem mediaFile;
  const VideoPlayerScreen({Key? key, required this.mediaFile})
      : super(key: key);
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late ChewieController chewieController;

  @override
  void initState() {
    _controller = VideoPlayerController.file(File(widget.mediaFile.key.path))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        chewieController = ChewieController(
            videoPlayerController: _controller,
            looping: false,
            aspectRatio: _controller.value.aspectRatio,
            errorBuilder: (context, errorMessage) {
              return Center(
                child: Text(errorMessage),
              );
            });
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _controller.value.isInitialized
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? chewieController.pause()
                        : chewieController.play();
                  });
                },
                child: Stack(
                  children: [
                    Chewie(controller: chewieController),
                    Positioned(
                      top: 10,
                      left: 0,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          child: const Icon(
                            Icons.close,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),
      ),
    );
  }
}
