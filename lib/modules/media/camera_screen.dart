import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';

import 'media_camera.dart';
import 'media_controller.dart';
import 'preview_view.dart';

class CameraScreen extends GetView<MediaController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.state.value == CameraControllerState.Default) {
        return SonrAnimatedWaveIcon(Icons.camera_alt_outlined);
      } else if (controller.state.value == CameraControllerState.Captured) {
        return MediaPreviewView();
      } else {
        return MediaCameraView();
      }
    });
  }
}
