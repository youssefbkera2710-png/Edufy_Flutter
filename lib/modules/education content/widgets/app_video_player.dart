import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class AppVideoPlayer extends StatefulWidget {
  final String url;
  const AppVideoPlayer({super.key, required this.url});

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    await _videoController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: false,
      aspectRatio: _videoController.value.aspectRatio,
      materialProgressColors: ChewieProgressColors(
        playedColor: Theme.of(context).primaryColor,
      ),
    );
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: _chewieController != null
          ? Chewie(controller: _chewieController!)
          : const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}
