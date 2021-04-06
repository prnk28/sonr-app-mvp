import 'package:get/get.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/modules/media/media_picker.dart';
import 'package:sonr_app/theme/theme.dart';
import 'home_controller.dart';

class ShareButton extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedContainer(
        curve: Curves.bounceOut,
        padding: controller.isShareExpanded ? EdgeInsetsX.bottom(20) : EdgeInsets.zero,
        duration: Duration(milliseconds: 600),
        width: _width,
        height: _height,
        child: NeumorphicButton(
          child: controller.isShareExpanded ? _ExpandedView() : _DefaultView(),
          onPressed: controller.toggleShare,
          style: SonrStyle.shareButton,
        )));
  }

  double get _width {
    if (controller.isShareExpanded) {
      return Get.width / 2 + 165;
    } else {
      return 60;
    }
  }

  double get _height {
    if (controller.isShareExpanded) {
      return 120;
    } else {
      return 60;
    }
  }
}

// ** Close Share Button View ** //
class _DefaultView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(child: SonrIcon.send, padding: EdgeInsetsX.vertical(8));
  }
}

// ** Expanded Share Button View ** //
class _ExpandedView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              // Close Share Button
              controller.shrinkShare();
              // Check Permissions
              if (UserService.permissions.value.hasCamera) {
                Get.to(CameraView.withPreview(onMediaSelected: (MediaFile file) {
                  SonrService.queueCapture(file);
                  Get.toNamed("/transfer");
                }), transition: Transition.downToUp);
              } else {
                Get.find<UserService>().requestCamera().then((value) {
                  // Go to Camera View
                  if (value) {
                    Get.to(CameraView.withPreview(onMediaSelected: (MediaFile file) {
                      SonrService.queueCapture(file);
                      Get.toNamed("/transfer");
                    }), transition: Transition.downToUp);
                  } else {
                    // Present Error
                    SonrSnack.error("Sonr cannot open Camera without Permissions");
                  }
                });
              }
            },
            child: Container(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Expanded(
                  child: RiveContainer(
                    type: RiveBoard.Camera,
                    width: 80,
                    height: 80,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 4)),
                SonrText(_typeText(RiveBoard.Camera), weight: FontWeight.w500, size: 14, key: key, color: SonrColor.White),
              ]),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Close Share Button
              controller.shrinkShare();
              // Check Permissions
              if (UserService.permissions.value.hasGallery) {
                MediaService.refreshGallery();
                Get.bottomSheet(MediaPickerSheet(onMediaSelected: (file) {
                  SonrService.queueMedia(file);
                  Get.toNamed("/transfer");
                }), isDismissible: false);
              } else {
                Get.find<UserService>().requestGallery().then((value) {
                  // Present Sheet
                  if (value) {
                    MediaService.refreshGallery();
                    Get.bottomSheet(MediaPickerSheet(onMediaSelected: (file) {
                      SonrService.queueMedia(file);
                      Get.toNamed("/transfer");
                    }), isDismissible: false);
                  } else {
                    // Present Error
                    SonrSnack.error("Sonr cannot open Media Picker without Gallery Permissions");
                  }
                });
              }
            },
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                child: RiveContainer(
                  type: RiveBoard.Gallery,
                  width: 80,
                  height: 80,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 4)),
              SonrText(_typeText(RiveBoard.Gallery), weight: FontWeight.w500, size: 14, key: key, color: SonrColor.White),
            ]),
          ),
          GestureDetector(
            onTap: () {
              // Close Share Button
              controller.shrinkShare();
              SonrService.queueContact();

              // Go to Transfer
              Get.toNamed("/transfer");
            },
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                child: RiveContainer(
                  type: RiveBoard.Contact,
                  width: 80,
                  height: 80,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 4)),
              SonrText(_typeText(RiveBoard.Contact), weight: FontWeight.w500, size: 14, key: key, color: SonrColor.White),
            ]),
          )
        ]);
  }

  String _typeText(RiveBoard type) {
    // Method to Return Type
    return type.toString().split('.').last;
  }
}
