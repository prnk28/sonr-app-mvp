import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'preview_controller.dart';

class MediaPreviewView extends GetView<PreviewController> {
  @override
  Widget build(BuildContext context) {
    // @ Build View
    return NeumorphicBackground(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        borderRadius: BorderRadius.circular(30),
        backendColor: Colors.transparent,
        child: Neumorphic(
          style: NeumorphicStyle(color: SonrColor.base),
          child: Obx(() {
            // @ Display Current Media
            if (controller.captureReady.value) {
              return Column(
                children: [
                  // Preview
                  Expanded(
                    child: controller.isVideo.value
                        ? _VideoCapturePlayer(path: controller.capturePath)
                        : _PhotoCaptureView(path: controller.capturePath),
                  ),

                  // Buttons
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 25),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      // Left Button - Cancel and Retake
                      SonrButton.circle(
                          onPressed: () {
                            controller.clear();
                          },
                          icon: SonrIcon.close),

                      // Right Button - Continue and Accept
                      SonrButton.circle(
                          onPressed: () {
                            controller.continueMedia();
                          },
                          icon: SonrIcon.accept),
                    ]),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
        ));
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
