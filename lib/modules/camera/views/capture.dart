import 'package:camerawesome/camerapreview.dart';
import 'package:sonr_app/style/style.dart';
import '../camera_controller.dart';

class CaptureWindow extends StatelessWidget {
  final CameraController controller;
  const CaptureWindow({Key? key, required this.controller}) : super(key: key);
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
