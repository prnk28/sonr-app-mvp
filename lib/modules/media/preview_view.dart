import 'dart:io';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'preview_controller.dart';

class MediaPreviewView extends GetView<PreviewController> {
  @override
  Widget build(BuildContext context) {
    // @ Build View
    return Obx(() {
      if (controller.captureReady.value) {
        return Stack(
          children: [
            // Preview
            Expanded(
              child: controller.isVideo.value ? _VideoCapturePlayer(path: controller.capturePath) : _PhotoCaptureView(path: controller.capturePath),
            ),

            // Buttons
            _CaptureToolsView()
          ],
        );
      } else {
        return Center(child: CircularProgressIndicator());
      }
    });
  }
}

class _CaptureToolsView extends GetView<PreviewController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: NeumorphicBackground(
        backendColor: Colors.transparent,
        child: Neumorphic(
          padding: EdgeInsets.only(top: 20, bottom: 40),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            // Left Button - Cancel and Retake
            SonrButton.circle(
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  controller.clear();
                },
                icon: SonrIcon.close),

            // Right Button - Continue and Accept
            SonrButton.circle(
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  controller.continueMedia();
                },
                icon: SonrIcon.accept),
          ]),
        ),
      ),
    );
  }
}

// ** Captured Photo View ** //
class _PhotoCaptureView extends StatelessWidget {
  final String path;

  const _PhotoCaptureView({Key key, @required this.path}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      child: Image.file(File(path)),
    );
  }
}

// ** Captured Video View ** //
class _VideoCapturePlayer extends StatefulWidget {
  final String path;

  const _VideoCapturePlayer({Key key, @required this.path}) : super(key: key);
  @override
  _VideoCapturePlayerState createState() => _VideoCapturePlayerState();
}

class _VideoCapturePlayerState extends State<_VideoCapturePlayer> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        setState(() {
          _controller.setLooping(true);
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.initialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Center(child: CircularProgressIndicator());
  }
}
