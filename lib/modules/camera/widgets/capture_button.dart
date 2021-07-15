import 'package:sonr_app/style/style.dart';
import '../camera_controller.dart';

class CaptureButton extends StatelessWidget {
  final CameraController controller;
  const CaptureButton({Key? key, required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 100,
        height: 100,
        child: AspectRatio(
          aspectRatio: 1,
          child: GestureDetector(
            onTap: () {
              controller.capturePhoto();
            },
            onLongPressStart: (LongPressStartDetails tapUpDetails) {
              if (GetPlatform.isIOS) {
                controller.startCaptureVideo();
              }
            },
            onLongPressEnd: (LongPressEndDetails tapUpDetails) {
              if (GetPlatform.isIOS) {
                controller.stopCaptureVideo();
              }
            },
            child: Obx(
              () => CircleContainer(
                child: Center(
                    child: SimpleIcons.Camera.gradient(
                  value: DesignGradients.PhoenixStart,
                  size: 40,
                )),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
