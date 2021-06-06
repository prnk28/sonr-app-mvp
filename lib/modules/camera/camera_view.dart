import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sonr_app/modules/camera/tools_view.dart';
import 'package:sonr_app/modules/card/file/views.dart';
import 'package:sonr_app/style.dart';
import 'camera_controller.dart';

class CameraView extends StatelessWidget {
  // Properties
  final Function(SonrFile file) onMediaSelected;
  CameraView({required this.onMediaSelected});

  static void open({required Function(SonrFile file) onMediaSelected}) {
    Get.to(
      CameraView(onMediaSelected: onMediaSelected),
      fullscreenDialog: true,
      transition: Transition.downToUp,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetX<CameraController>(
        init: CameraController(onMediaSelected),
        global: false,
        autoRemove: false,
        builder: (controller) => Stack(
              children: [
                // Camera Window
                AnimatedSlideSwitcher.fade(child: _buildWindowView(controller.status.value, controller)),

                // Button Tools View
                CameraToolsView(controller: controller),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 14, top: Get.statusBarHeight / 2),
                  child: PlainIconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: SonrIcons.Close.gradient(value: SonrGradients.PhoenixStart)),
                ),

                // Video Duration
                _VideoDurationWidget(controller: controller)
              ],
            ));
  }

  Widget _buildWindowView(CameraViewStatus status, CameraController controller) {
    if (status == CameraViewStatus.Default) {
      return _CameraWindow(controller: controller, key: ValueKey(true));
    } else {
      return _CapturePreview(controller: controller, key: ValueKey(false));
    }
  }
}

class _CameraWindow extends StatelessWidget {
  final CameraController controller;
  const _CameraWindow({Key? key, required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        // Update Double Zoomed
        controller.doubleZoomed(!controller.doubleZoomed.value);

        // Set Zoom Level
        if (controller.doubleZoomed.value) {
          controller.zoomLevel(0.25);
        } else {
          controller.zoomLevel(0.0);
        }
      },
      onScaleUpdate: (ScaleUpdateDetails scaleDetails) {
        // Calculate Scale
        var factor = 1.0 / scaleDetails.scale;
        var adjustedScale = 1 - factor;

        // Set Zoom Level
        if (scaleDetails.pointerCount > 1) {
          controller.zoomLevel(adjustedScale);
        }
      },
      onHorizontalDragUpdate: (details) {},
      child: CameraAwesome(
        testMode: false,
        sensor: controller.sensor,
        zoom: controller.zoomNotifier,
        photoSize: controller.photoSize,
        switchFlashMode: controller.switchFlash,
        captureMode: controller.captureMode,
        brightness: controller.brightness,
      ),
    );
  }
}

class _CapturePreview extends StatelessWidget {
  final CameraController controller;
  const _CapturePreview({Key? key, required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return controller.result.value.single.mime.isVideo
        // Video Player View
        ? Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: AspectRatio(
                aspectRatio: 9 / 16,
                child: VideoPlayerView.file(
                  controller.result.value.single.file,
                  true,
                )))

        // Photo View
        : Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              image: DecorationImage(image: FileImage(controller.result.value.single.file), fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(30),
            ),
          );
  }
}

class _VideoDurationWidget extends StatelessWidget {
  final CameraController controller;
  const _VideoDurationWidget({Key? key, required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.videoInProgress.value
        ? Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: SonrColor.AccentNavy.withOpacity(0.75)),
            child: RichText(
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
                text: TextSpan(children: [
                  TextSpan(
                      text: controller.videoDurationString.value,
                      style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w300, fontSize: 16, color: SonrColor.Black)),
                  TextSpan(text: "  s", style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w600, fontSize: 16, color: SonrColor.Black)),
                ])),
          )
        : Container());
  }
}
