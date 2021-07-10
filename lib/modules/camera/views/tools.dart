import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/modules/camera/widgets/capture_button.dart';
import 'package:sonr_app/style/style.dart';
import '../camera_controller.dart';

class CameraToolsView extends StatelessWidget {
  final CameraController controller;

  const CameraToolsView({Key? key, required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.bottomCenter, child: BoxContainer(child: AnimatedSlider.slideUp(child: _buildToolsView(controller.status.value))));
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
        ColorButton.neutral(
          onPressed: () {
            HapticFeedback.heavyImpact();
            controller.handleCapture(false);
          },
          text: 'Redo',
        ),

        // Right Button - Continue
        ColorButton.primary(
            onPressed: () {
              HapticFeedback.heavyImpact();
              controller.handleCapture(true);
            },
            text: "Continue",
            icon: SimpleIcons.Check),
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
          return AnimatedSlider.slideUp(
            child: ActionButton(
              iconData: iconData,
              onPressed: () async {
                await HapticFeedback.heavyImpact();
                controller.toggleCameraSensor();
              },
            ),
          );
        }),

        // Media Gallery Picker
        CaptureButton(controller: controller),

        // Neumorphic Camera Button Stack
        ActionButton(
          iconData: SimpleIcons.Photos,
          onPressed: () async {
            await HapticFeedback.heavyImpact();
            // Check for Permssions
            await SenderService.choose(ChooseOption.Media);
          },
        ),
      ]),
    );
  }
}
