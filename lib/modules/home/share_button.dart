import 'dart:async';

import 'package:get/get.dart';
import 'package:sonr_app/modules/media/media_picker.dart';
import 'package:sonr_app/theme/theme.dart';

class ShareButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<ShareButtonController>(
        init: ShareButtonController(),
        builder: (controller) {
          // Get Views
          final expandedView = _ExpandedView(controller);
          final defaultView = _DefaultView();

          // Build Container
          return Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
                curve: Curves.easeInBack,
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsetsDirectional.only(start: 30),
                width: controller.isExpanded.value ? Get.width / 2 + K_EXPANDED_WIDTH : Get.width / 2 + K_DEFAULT_WIDTH,
                height: controller.isExpanded.value ? K_EXPANDED_HEIGHT : K_DEFAULT_HEIGHT,
                child: Center(
                  child: GestureDetector(
                    onLongPress: () async {},
                    child: NeumorphicButton(
                      child: controller.isExpanded.value ? expandedView : defaultView,
                      onPressed: controller.toggle,
                      style: SonrStyle.shareButton,
                    ),
                  ),
                )),
          );
        });
  }
}

// ** Close Share Button View ** //
class _DefaultView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      SonrIcon.send,
      SonrText(
        "Share",
        isGradient: true,
        isCentered: true,
        weight: FontWeight.w700,
        size: 32,
        key: key,
        gradient: FlutterGradientNames.glassWater.linear(),
      )
    ]);
  }
}

// ** Expanded Share Button View ** //
class _ExpandedView extends StatelessWidget {
  final ShareButtonController controller;

  const _ExpandedView(this.controller, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
        tween: (0.0).tweenTo(1.0),
        duration: 150.milliseconds,
        delay: 150.milliseconds,
        builder: (context, child, value) {
          return Container(
            width: Get.width / 2 + 165,
            height: 130,
            child: AnimatedOpacity(
                opacity: value,
                duration: 150.milliseconds,
                child: NeumorphicTheme(
                    theme: NeumorphicThemeData(
                      baseColor: Color.fromRGBO(239, 238, 238, 1.0),
                      lightSource: LightSource.top,
                      depth: 8,
                      intensity: 0.4,
                    ),
                    child: _ShareButtonRow(controller))),
          );
        });
  }
}

// ** Share Button Row ** //
class _ShareButtonRow extends StatelessWidget {
  final ShareButtonController controller;
  const _ShareButtonRow(this.controller);
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
                  controller.close();

                  // Check Permissions
                  if (Get.find<DeviceService>().cameraPermitted.val) {
                    Get.to(CameraView.withPreview(onMediaSelected: (MediaFile file) {
                      SonrService.queueMedia(file);
                      Get.toNamed("/transfer");
                    }), transition: Transition.downToUp);
                  } else {
                    Get.find<DeviceService>().requestCamera().then((value) {
                      // Go to Camera View
                      if (value) {
                        Get.to(CameraView.withPreview(onMediaSelected: (MediaFile file) {
                          SonrService.queueMedia(file);
                          Get.toNamed("/transfer");
                        }), transition: Transition.downToUp);
                      } else {
                        // Present Error
                        SonrSnack.error("Sonr cannot open Camera without Permissions");
                      }
                    });
                  }
                },
                type: ArtboardType.Camera,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(K_ITEM_SPACING)),
          Expanded(
            child: Container(
              child: _ShareButtonItem(
                onPressed: () {
                  controller.close();
                  // Check Permissions
                  if (Get.find<DeviceService>().galleryPermitted.val) {
                    MediaService.refreshGallery();
                    Get.bottomSheet(MediaPickerSheet(onMediaSelected: (file) {
                      SonrService.queueMedia(file);
                      Get.toNamed("/transfer");
                    }), isDismissible: false);
                  } else {
                    Get.find<DeviceService>().requestGallery().then((value) {
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
                type: ArtboardType.Gallery,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(K_ITEM_SPACING)),
          Expanded(
            child: Container(
              child: _ShareButtonItem(
                onPressed: () {
                  SonrService.queueContact();

                  // Close Share Button
                  controller.close();

                  // Go to Transfer
                  Get.toNamed("/transfer");
                },
                type: ArtboardType.Contact,
              ),
            ),
          )
        ]);
  }
}

// ** Share Button Item View ** //
class _ShareButtonItem extends StatelessWidget {
  // Properties
  final ArtboardType type;
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
              shape: NeumorphicShape.convex,
              shadowDarkColor: SonrColor.fromHex("333333"),
              depth: 12,
              color: SonrColor.fromHex("EFEEEE"),
              boxShape: NeumorphicBoxShape.circle()),
          child: RiveContainer(
            type: type,
            width: Get.width,
            height: Get.height,
          ),
          onPressed: onPressed,
        ),
      ),
      Padding(padding: EdgeInsets.only(top: 4)),
      SonrText(_typeText, weight: FontWeight.w500, size: 14, key: key, color: Colors.white),
    ]);
  }
}

// @ Widget Constants
const double K_ITEM_SPACING = 12;
const double K_EXPANDED_HEIGHT = 130;
const double K_EXPANDED_WIDTH = 165;
const double K_DEFAULT_HEIGHT = 70;
const double K_DEFAULT_WIDTH = 30;
enum ShareButtonState { Default, Expanded, Remote, Pending }

extension ShareButtonStateUtil on ShareButtonState {
  double get width {
    switch (this) {
      case ShareButtonState.Expanded:
        return 165;
      case ShareButtonState.Remote:
        return 165;
        break;
      case ShareButtonState.Pending:
        return 60;
      default:
        return 30;
    }
  }

  double get height {
    switch (this) {
      case ShareButtonState.Expanded:
        return 130;
      case ShareButtonState.Remote:
        return 165;
        break;
      case ShareButtonState.Pending:
        return 60;
      default:
        return 70;
    }
  }
}

class ShareButtonController extends GetxController {
  // Properties
  final isExpanded = false.obs;
  final isRemote = false.obs;
  final counter = 0.obs;
  final state = ShareButtonState.Default.obs;

  // References
  Timer _timer;

  // ^ Close Share Button ^ //
  void close() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
      HapticFeedback.mediumImpact();
      isExpanded(false);
      state(ShareButtonState.Default);
      counter(0);
    }
  }

  // ^ Expand Share Button ^ //
  void expand() {
    HapticFeedback.heavyImpact();

    // Create Timeout
    _timer = Timer.periodic(500.milliseconds, (_) {
      // Add to Counter
      counter(counter.value += 500);

      // Check if Timeout Reached
      if (counter.value == 4000) {
        if (isExpanded.value) {
          close();
        }
      }
    });
  }

  // ^ Toggles Expanded Share Button ^ //
  void toggle() {
    if (!isExpanded.value) {
      isExpanded(true);
      state(ShareButtonState.Expanded);
      expand();
    } else {
      close();
    }
  }

  // ^ Toggles Remote Share View ^ //
  void toggleRemote() {
    if (!isRemote.value) {
      isRemote(true);
      state(ShareButtonState.Remote);
    } else {
      close();
    }
  }
}
