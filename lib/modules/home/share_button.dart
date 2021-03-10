import 'package:get/get.dart';
import 'package:sonr_app/modules/media/media_picker.dart';
import 'package:sonr_app/theme/theme.dart';
import 'home_controller.dart';

// @ Widget Constants
const double K_ITEM_SPACING = 12;
const double K_EXPANDED_HEIGHT = 130;
const double K_EXPANDED_WIDTH = 165;
const double K_DEFAULT_HEIGHT = 70;
const double K_DEFAULT_WIDTH = 30;
const Duration K_ANIMATION_DURATION = const Duration(milliseconds: 200);

class ShareButton extends GetView<HomeController> {
  final expandedView = _ExpandedView();
  final defaultView = _DefaultView();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
            curve: Curves.easeInBack,
            padding: EdgeInsetsDirectional.only(start: 30),
            width: controller.isShareExpanded.value ? Get.width / 2 + K_EXPANDED_WIDTH : Get.width / 2 + K_DEFAULT_WIDTH,
            height: controller.isShareExpanded.value ? K_EXPANDED_HEIGHT : K_DEFAULT_HEIGHT,
            duration: K_ANIMATION_DURATION,
            child: Center(
              child: NeumorphicButton(
                child: controller.isShareExpanded.value ? expandedView : defaultView,
                onPressed: controller.toggleShare,
                style: SonrStyle.shareButton,
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
                    child: _ShareButtonRow())),
          );
        });
  }
}

// ** Share Button Row ** //
class _ShareButtonRow extends GetView<HomeController> {
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
                  controller.closeShare();

                  // Check Permissions
                  DeviceService.requestCamera().then((value) {
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
                  controller.closeShare();

                  // Check Permissions
                  DeviceService.requestGallery().then((value) {
                    // Present Sheet
                    if (value) {
                      Get.bottomSheet(MediaPickerSheet(onMediaSelected: (file) {
                        SonrService.queueMedia(file);
                        Get.toNamed("/transfer");
                      }), isDismissible: false);
                    } else {
                      // Present Error
                      SonrSnack.error("Sonr cannot open Media Picker without Gallery Permissions");
                    }
                  });
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
                  controller.closeShare();

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
