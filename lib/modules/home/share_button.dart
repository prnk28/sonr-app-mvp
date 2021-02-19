import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonr_app/modules/media/picker_sheet.dart';
import 'package:sonr_app/service/sonr_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

// @ Widget Constants
const double K_ITEM_SPACING = 12;
const double K_EXPANDED_HEIGHT = 130;
const double K_EXPANDED_WIDTH = 165;
const double K_DEFAULT_HEIGHT = 70;
const double K_DEFAULT_WIDTH = 30;
const Duration K_ANIMATION_DURATION = const Duration(milliseconds: 200);

class ShareButton extends GetView<ShareButtonController> {
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
            width: controller.isExpanded.value ? Get.width / 2 + K_EXPANDED_WIDTH : Get.width / 2 + K_DEFAULT_WIDTH,
            height: controller.isExpanded.value ? K_EXPANDED_HEIGHT : K_DEFAULT_HEIGHT,
            duration: K_ANIMATION_DURATION,
            child: Center(
              child: NeumorphicButton(
                child: controller.isExpanded.value ? expandedView : defaultView,
                onPressed: controller.toggle,
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
      SonrText.header(
        "Share",
        size: 32,
        gradient: FlutterGradientNames.glassWater,
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
class _ShareButtonRow extends GetView<ShareButtonController> {
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
              height: Get.height,
              child: _ShareButtonItem(
                onPressed: () {
                  controller.presentCamera();
                },
                type: ArtboardType.Camera,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(K_ITEM_SPACING)),
          Expanded(
            child: Container(
              height: Get.height,
              child: _ShareButtonItem(
                onPressed: () {
                  controller.presentMediaPicker();
                },
                type: ArtboardType.Gallery,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(K_ITEM_SPACING)),
          Expanded(
            child: Container(
              height: Get.height,
              child: _ShareButtonItem(
                onPressed: () {
                  controller.queueContact();
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
          child: SonrRiveWidget.fromType(
            type: type,
            width: Get.width,
            height: Get.height,
          ),
          onPressed: onPressed,
        ),
      ),
      Padding(padding: EdgeInsets.only(top: 4)),
      SonrText.medium(_typeText, size: 14, color: Colors.white),
    ]);
  }
}

// ** Share Button Controller ** //
class ShareButtonController extends GetxController {
  // Properties
  final isExpanded = false.obs;

  // ^ Close Share Button ^ //
  static void close() {
    HapticFeedback.heavyImpact();
    Get.find<ShareButtonController>().isExpanded(false);
  }

  // ^ Expand Share Button ^ //
  void expand() {
    HapticFeedback.heavyImpact();
    Get.find<ShareButtonController>().isExpanded(true);
  }

  // ^ Toggles Expanded Share Button ^ //
  void toggle() {
    HapticFeedback.heavyImpact();
    Get.find<ShareButtonController>().isExpanded(!isExpanded.value);
  }

  // ^ Opens Camera Picker ^ //
  void presentCamera() async {
    // Check for Permssions
    if (await Permission.camera.request().isGranted) {
      // Toggle Share Expand
      close();

      // Go to Camera View
      Get.offNamed("/camera");
    } else {
      // Display Error
      SonrSnack.error("Sonr isnt permitted to access your media.");
    }
  }

  // ^ Opens Media Picker UI ^ //
  void presentMediaPicker() async {
    // Check for Permssions
    if (await Permission.photos.request().isGranted) {
      // Toggle Share Expand
      close();

      // Display Bottom Sheet
      Get.bottomSheet(PickerSheet(), isDismissible: false);
    } else {
      // Display Error
      SonrSnack.error("Sonr isnt permitted to access your media.");
    }
  }

  // ^ Queues a Contact for Transfer ^ //
  void queueContact() {
    Get.find<SonrService>().setPayload(Payload.CONTACT);

    // Close Share Button
    close();

    // Go to Transfer
    Get.offNamed("/transfer");
  }
}
