import 'package:sonr_app/style.dart';
import '../camera_controller.dart';

class CaptureButton extends StatelessWidget {
  final CameraController controller;
  const CaptureButton({Key? key, required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 150,
        height: 150,
        child: AspectRatio(
          aspectRatio: 1,
          child: CircleContainer(
            margin: EdgeInsets.all(14),
            child: CircleContainer(
              margin: EdgeInsets.all(14),
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
                  () => Container(
                      child: Center(
                          child: SonrIcons.Camera.gradient(
                        value: ContactService.isDarkMode ? SonrGradients.PremiumWhite : SonrGradients.PremiumDark,
                        size: 40,
                      )),
                      decoration: BoxDecoration(
                          border: controller.videoInProgress.value
                              ? Border.all(color: SonrColor.Critical, width: 4)
                              : Border.all(color: SonrColor.Black, width: 0),
                          color: SonrColor.White,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(offset: Offset(2, 2), blurRadius: 8, color: SonrColor.Black.withOpacity(0.2)),
                          ])),
                ),
              ),
              // Interior Compass
            ),
          ),
        ),
      ),
    ]);
  }
}
