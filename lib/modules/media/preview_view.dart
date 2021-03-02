import 'dart:io';
import 'package:sonr_app/core/core.dart';
import 'package:sonr_app/modules/media/camera_binding.dart';
import 'package:sonr_app/core/core.dart';
import 'package:better_player/better_player.dart';

class MediaPreviewView extends GetView<PreviewController> {
  @override
  Widget build(BuildContext context) {
    // @ Build View
    return SafeArea(
      top: false,
      bottom: false,
      child: Obx(() {
        return Stack(
          children: [
            // Preview
            controller.isVideo.value
                ? _VideoCapturePlayer(file: File(controller.videoPath))
                : Positioned.fill(child: _PhotoCaptureView(path: controller.photoPath)),

            // Buttons
            _CaptureToolsView()
          ],
        );
      }),
    );
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
                  MediaController.confirmCaptured();
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
class _VideoCapturePlayer extends StatelessWidget {
  final File file;
  const _VideoCapturePlayer({Key key, @required this.file}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: Get.width,
        height: Get.height,
        child: AspectRatio(
            aspectRatio: 9 / 16,
            child: BetterPlayer.file(file.path,
                betterPlayerConfiguration: BetterPlayerConfiguration(
                  controlsConfiguration: BetterPlayerControlsConfiguration(),
                  allowedScreenSleep: false,
                  autoPlay: true,
                  looping: true,
                  aspectRatio: 9 / 16,
                ))));
  }
}

// ** Preview Capture View Controller ** //
class PreviewController extends GetxController {
  // Properties
  final isVideo = false.obs;

  // References
  String photoPath = "";
  String videoPath = "";

  // ^ Clear Current Photo ^ //
  clear() async {
    // Reset Properties
    isVideo(false);
    photoPath = "";
    videoPath = "";

    // Get Temp Directories
    Directory temp = await getTemporaryDirectory();
    var videoDir = Directory('${temp.path}/videos');
    var photoDir = Directory('${temp.path}/photos');

    // Clear Temp Photo Directory
    if (await photoDir.exists()) {
      await photoDir.delete(recursive: true);
    }

    // Clear Temp Video Directory
    if (await videoDir.exists()) {
      await videoDir.delete(recursive: true);
    }
    MediaController.ready();
  }

  // ^ Video Completed Recording ^ //
  setVideo(String path) async {
    videoPath = path;
    isVideo(true);
  }

  // ^ Set Photo and Capture Ready ^ //
  setPhoto(String path) {
    photoPath = path;
    isVideo(false);
  }
}
