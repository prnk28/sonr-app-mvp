import 'package:get/get.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/modules/media/media_picker.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:vector_math/vector_math_64.dart';

import 'nav_controller.dart';

class BottomShareButton extends GetView<SonrNavController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AnimatedContainer(
          curve: Curves.bounceOut,
          transform: controller.shareState.value.translation,
          duration: Duration(milliseconds: 600),
          width: controller.shareState.value.width,
          height: controller.shareState.value.height,
          child: Center(
            child: NeumorphicButton(
              child: controller.shareState.value.getView(controller),
              onPressed: controller.toggleShare,
              style: SonrStyle.shareButton,
            ),
          ));
    });
  }
}

// ** Close Share Button View ** //
class _DefaultView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: SonrIcon.send, padding: EdgeInsetsX.vertical(8));
  }
}

// ** Expanded Share Button View ** //
class _ExpandedView extends StatelessWidget {
  const _ExpandedView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OpacityAnimatedWidget(
      enabled: true,
      duration: 150.milliseconds,
      delay: 150.milliseconds,
      child: NeumorphicTheme(
          theme: NeumorphicThemeData(
            baseColor: Color.fromRGBO(239, 238, 238, 1.0),
            lightSource: LightSource.top,
            depth: 8,
            intensity: 0.4,
          ),
          child: _ShareButtonRow()),
    );
  }
}

// ** Share Button Row ** //
class _ShareButtonRow extends GetView<SonrNavController> {
  const _ShareButtonRow();
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        verticalDirection: VerticalDirection.up,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              child: _ShareButtonItem(
                onPressed: () {
                  // Toggle Share Expand
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
                type: RiveBoard.Camera,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(12)),
          Expanded(
            child: Container(
              child: _ShareButtonItem(
                onPressed: () {
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
                type: RiveBoard.Gallery,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(12)),
          Expanded(
            child: Container(
              child: _ShareButtonItem(
                onPressed: () {
                  SonrService.queueContact();

                  // Close Share Button
                  controller.shrinkShare();

                  // Go to Transfer
                  Get.toNamed("/transfer");
                },
                type: RiveBoard.Contact,
              ),
            ),
          )
        ]);
  }
}

// ** Share Button Item View ** //
class _ShareButtonItem extends StatelessWidget {
  // Properties
  final RiveBoard type;
  final Function onPressed;

  // Method to Return Type
  String get _typeText => type.toString().split('.').last;

  const _ShareButtonItem({Key key, this.type, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
        child: NeumorphicButton(
          style: NeumorphicStyle(
              surfaceIntensity: 0.3,
              shape: NeumorphicShape.flat,
              shadowDarkColor: SonrColor.fromHex("333333"),
              depth: 12,
              color: SonrColor.fromHex("EFEEEE"),
              boxShape: NeumorphicBoxShape.circle()),
          child: RiveContainer(
            type: type,
            width: 200,
            height: 200,
          ),
          onPressed: onPressed,
        ),
      ),
      Padding(padding: EdgeInsets.only(top: 4)),
      SonrText(_typeText, weight: FontWeight.w500, size: 14, key: key, color: SonrColor.White),
    ]);
  }
}

enum BottomShareButtonState { Default, Expanded }

extension BottomShareButtonStateUtil on BottomShareButtonState {
  double get width {
    switch (this) {
      case BottomShareButtonState.Expanded:
        return Get.width / 2 + 165;
      default:
        return 120;
    }
  }

  double get height {
    switch (this) {
      case BottomShareButtonState.Expanded:
        return 130;
      default:
        return 120;
    }
  }

  double get heightFactor {
    switch (this) {
      case BottomShareButtonState.Expanded:
        return 1.0;
      default:
        return 0.6;
    }
  }

  Matrix4 get translation {
    switch (this) {
      case BottomShareButtonState.Expanded:
        return Matrix4.translation(Vector3(0, -115, 0));
      default:
        return Matrix4.translation(Vector3(0, -15, 0));
    }
  }

  Widget getView(SonrNavController controller) {
    switch (this) {
      case BottomShareButtonState.Expanded:
        return _ExpandedView();
      default:
        return _DefaultView();
    }
  }
}
