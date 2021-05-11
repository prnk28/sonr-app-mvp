import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sonr_app/style/style.dart';
import 'camera_controller.dart';

class CameraToolsView extends StatelessWidget {
  final CameraController controller;

  const CameraToolsView({Key? key, required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.bottomCenter,
        child: Container(
            decoration: Neumorphic.floating(),
            padding: EdgeInsets.only(top: 20, bottom: 40),
            child: AnimatedSlideSwitcher.slideUp(child: _buildToolsView(controller.status.value))));
  }

  Widget _buildToolsView(CameraViewStatus status) {
    if (status == CameraViewStatus.Default) {
      return _DefaultToolsView(controller: controller, key: ValueKey(true));
    } else {
      return _CaptureToolsView(controller: controller, key: ValueKey(false));
    }
  }
}

class _CaptureToolsView extends StatelessWidget {
  final CameraController controller;

  const _CaptureToolsView({Key? key, required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Height.ratio(0.15),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        // Left Button - Cancel and Retake
        PlainButton(
          onPressed: () {
            HapticFeedback.heavyImpact();
            controller.handleCapture(false);
          },
          child: [SonrIcons.Refresh.black, Padding(padding: EdgeInsets.all(8)), "Redo".h6].row(),
        ),

        // Right Button - Continue
        ColorButton.primary(
            onPressed: () {
              HapticFeedback.heavyImpact();
              controller.handleCapture(true);
            },
            text: "Continue",
            icon: SonrIcons.Check),
      ]),
    );
  }
}

class _DefaultToolsView extends StatelessWidget {
  final CameraController controller;

  const _DefaultToolsView({Key? key, required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Height.ratio(0.2),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        // Switch Camera
        Obx(() {
          var iconData = controller.isFlipped.value ? Icons.camera_rear_rounded : Icons.camera_front_rounded;
          return GestureDetector(
              child: AnimatedSlideSwitcher.slideUp(
                  child: Container(
                      key: ValueKey<IconData>(iconData),
                      child: iconData.gradient(
                        value: SonrGradients.LoveKiss,
                        size: 36,
                      ))),
              onTap: () async {
                await HapticFeedback.heavyImpact();
                controller.toggleCameraSensor();
              });
        }),

        // Neumorphic Camera Button Stack
        _CaptureButton(controller: controller),

        // Media Gallery Picker
        GestureDetector(
            child: SonrIcons.Photos.gradient(
              value: SonrGradients.OctoberSilence,
              size: 36,
            ),
            onTap: () async {
              await HapticFeedback.heavyImpact();
              // Check for Permssions
              await TransferService.chooseMedia();
            }),
      ]),
    );
  }
}

class _CaptureButton extends StatelessWidget {
  final CameraController controller;
  const _CaptureButton({Key? key, required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 150,
        height: 150,
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            margin: EdgeInsets.all(14),
            decoration: Neumorphic.floating(shape: BoxShape.circle),
            child: Container(
              decoration: Neumorphic.floating(shape: BoxShape.circle),
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
                      value: UserService.isDarkMode ? SonrGradients.PremiumWhite : SonrGradients.PremiumDark,
                      size: 40,
                    )),
                    decoration: Neumorphic.floating(
                        shape: BoxShape.circle,
                        border: controller.videoInProgress.value
                            ? Border.all(color: SonrColor.Critical, width: 4)
                            : Border.all(color: SonrColor.Black, width: 0)),
                  ),
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
