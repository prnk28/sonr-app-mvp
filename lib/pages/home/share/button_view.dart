import 'package:get/get.dart';
import 'share_controller.dart';
import 'package:sonr_app/service/device/mobile.dart';
import 'package:sonr_app/style/style.dart';

class ShareView extends GetView<ShareController> {
  ShareView() : super(key: GlobalKey());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 36.0),
      child: AnimatedContainer(
          curve: Curves.bounceOut,
          duration: Duration(milliseconds: 600),
          width: 80,
          height: 80,
          child: GestureDetector(
            onTap: controller.toggle,
            child: ClipPolygon(
              borderRadius: 10,
              rotate: 30,
              sides: 6,
              child: Container(
                decoration: BoxDecoration(gradient: SonrGradients.SeaShore),
                alignment: Alignment.center,
                child: SonrIcons.Share.white,
              ),
            ),
          )),
    );
  }
}

class ButtonsAltOptionView extends GetView<ShareController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Height.ratio(0.15),
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Padding(padding: EdgeInsets.all(4)),
        const _ShareCameraButtonItem(),
        VerticalDivider(color: SonrColor.Grey),
        const _ShareFileButtonItem(),
        VerticalDivider(color: SonrColor.Grey),
        const _ShareContactButtonItem(),
        Padding(padding: EdgeInsets.all(4)),
      ]),
    );
  }
}

/// @ Camera Share Button
class _ShareCameraButtonItem extends GetView<ShareController> {
  const _ShareCameraButtonItem();
  @override
  Widget build(BuildContext context) {
    return FadeInDownBig(
      delay: 225.milliseconds,
      duration: [265.milliseconds, 225.milliseconds, 285.milliseconds, 245.milliseconds, 300.milliseconds].random(),
      child: GestureDetector(
        onTap: () async {
          // Check for Permissions
          if (controller.cameraPermitted.value) {
            controller.presentCameraView();
          }
          // Request Permissions
          else {
            var result = await Get.find<MobileService>().requestCamera();
            result ? controller.presentCameraView() : SonrSnack.error("Sonr cannot open Camera without Permissions");
          }
        },
        child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(height: 55, width: 55, child: Center(child: SonrIcons.Camera.gradient(value: SonrGradients.CrystalRiver, size: 42))),
          Padding(padding: EdgeInsets.only(top: 4)),
          'Camera'.p_White,
        ]),
      ),
    );
  }
}

/// @ File Share Button
class _ShareFileButtonItem extends GetView<ShareController> {
  const _ShareFileButtonItem();
  @override
  Widget build(BuildContext context) {
    return FadeInDownBig(
      delay: 225.milliseconds,
      duration: [265.milliseconds, 225.milliseconds, 285.milliseconds, 245.milliseconds, 300.milliseconds].random(),
      child: GestureDetector(
        onTap: controller.selectFile,
        child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(height: 55, width: 55, child: Center(child: SonrIcons.Folder.gradient(value: SonrGradients.ItmeoBranding, size: 42))),
          Padding(padding: EdgeInsets.only(top: 4)),
          'File'.p_White,
        ]),
      ),
    );
  }
}

/// @ Contact Share Button
class _ShareContactButtonItem extends GetView<ShareController> {
  const _ShareContactButtonItem();
  @override
  Widget build(BuildContext context) {
    return FadeInDownBig(
      delay: 225.milliseconds,
      duration: [265.milliseconds, 225.milliseconds, 285.milliseconds, 245.milliseconds, 300.milliseconds].random(),
      child: GestureDetector(
        onTap: controller.selectContact,
        child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(height: 55, width: 55, child: Center(child: SonrIcons.ContactCard.gradient(value: SonrGradients.LoveKiss, size: 42))),
          Padding(padding: EdgeInsets.only(top: 4)),
          'Contact'.p_White,
        ]),
      ),
    );
  }
}
