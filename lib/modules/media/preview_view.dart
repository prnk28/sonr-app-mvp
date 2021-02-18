import 'dart:io';

import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'preview_controller.dart';

class MediaPreviewView extends GetView<PreviewController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // @ Display Current Picture
      return Stack(
        children: [
          // Preview
          Container(
            width: Get.width,
            height: Get.height,
            child: Image.file(File(controller.capturePath.value)),
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
    });
  }
}
