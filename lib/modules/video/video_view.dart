import 'dart:io';
import 'package:sonr_app/theme/theme.dart';
import 'package:video_player/video_player.dart';

enum VideoPlayerViewType {
  Asset,
  Network,
  File,
}

class VideoPlayerView extends StatefulWidget {
  final VideoPlayerViewType type;
  final String source;
  final File sourceFile;
  const VideoPlayerView(this.type, {Key key, this.source, this.sourceFile}) : super(key: key);

  factory VideoPlayerView.asset(String source) => VideoPlayerView(VideoPlayerViewType.Asset, source: source);
  factory VideoPlayerView.file(File source) => VideoPlayerView(VideoPlayerViewType.Network, sourceFile: source);
  factory VideoPlayerView.network(String source) => VideoPlayerView(VideoPlayerViewType.File, source: source);

  @override
  _VideoPlayerViewState createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Check Type
    if (widget.type == VideoPlayerViewType.Asset) {
      _controller = VideoPlayerController.asset(widget.source)
        ..initialize().then((_) {
          setState(() {
            _controller.play();
          });
        });
    } else if (widget.type == VideoPlayerViewType.File) {
      _controller = VideoPlayerController.file(widget.sourceFile)
        ..initialize().then((_) {
          setState(() {
            _controller.play();
          });
        });
    } else {
      _controller = VideoPlayerController.network(widget.source)
        ..initialize().then((_) {
          setState(() {
            _controller.play();
          });
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container());
  }
}
