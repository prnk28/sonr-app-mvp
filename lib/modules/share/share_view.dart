import 'package:get/get.dart';
import 'package:sonr_app/modules/share/share_controller.dart';
import 'package:sonr_app/service/device/mobile.dart';
import 'package:sonr_app/style/style.dart';

class ShareView extends GetView<ShareController> {
  ShareView() : super(key: GlobalKey());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Obx(
        () => AnimatedContainer(
            curve: Curves.bounceOut,
            duration: Duration(milliseconds: 600),
            width: controller.size.value.width,
            height: controller.size.value.height,
            child: _buildView()),
      ),
    );
  }

  // @ Build Page View by Navigation Item
  Widget _buildView() {
    // Return View
    if (controller.status.value == ShareStatus.Queue) {
      return _QueueView(key: ValueKey<ShareStatus>(ShareStatus.Queue));
    } else {
      return _DefaultButtonView(key: ValueKey<ShareStatus>(ShareStatus.Default));
    }
  }
}

// ** Close Share Button View ** //
class _DefaultButtonView extends GetView<ShareController> {
  _DefaultButtonView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.toggle,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: SonrColor.Black,
        ),
        alignment: Alignment.center,
        child: SonrIcons.Share.white,
      ),
    );
  }
}

// ** Expanded Share Button View ** //
class _QueueView extends GetView<ShareController> {
  _QueueView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.toggle,
      child: Container(
        decoration: BoxDecoration(color: SonrColor.Black, borderRadius: BorderRadius.circular(24)),
        child: FadeInUpBig(
            delay: 200.milliseconds,
            duration: 250.milliseconds,
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Padding(padding: EdgeInsets.all(4)),
              const _ShareCameraButtonItem(),
              VerticalDivider(color: SonrColor.Grey),
              const _ShareGalleryButtonItem(),
              VerticalDivider(color: SonrColor.Grey),
              const _ShareFileButtonItem(),
              VerticalDivider(color: SonrColor.Grey),
              const _ShareContactButtonItem(),
              Padding(padding: EdgeInsets.all(4)),
            ])),
      ),
    );
  }
}

/// ^ Camera Share Button ^ //
class _ShareCameraButtonItem extends GetView<ShareController> {
  const _ShareCameraButtonItem();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }
}

/// ^ Gallery Share Button ^ //
class _ShareGalleryButtonItem extends GetView<ShareController> {
  const _ShareGalleryButtonItem();
  @override
  Widget build(BuildContext context) {
    // Return View
    return GestureDetector(
      onTap: controller.selectMedia,
      child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(height: 55, width: 55, child: Center(child: SonrIcons.Photos.gradient(value: SonrGradients.FrozenHeat, size: 42))),
        Padding(padding: EdgeInsets.only(top: 4)),
        'Gallery'.p_White,
      ]),
    );
  }
}

/// ^ File Share Button ^ //
class _ShareFileButtonItem extends GetView<ShareController> {
  const _ShareFileButtonItem();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.selectFile,
      child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(height: 55, width: 55, child: Center(child: SonrIcons.Folder.gradient(value: SonrGradients.ItmeoBranding, size: 42))),
        Padding(padding: EdgeInsets.only(top: 4)),
        'File'.p_White,
      ]),
    );
  }
}

/// ^ Contact Share Button ^ //
class _ShareContactButtonItem extends GetView<ShareController> {
  const _ShareContactButtonItem();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.selectContact,
      child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(height: 55, width: 55, child: Center(child: SonrIcons.ContactCard.gradient(value: SonrGradients.LoveKiss, size: 42))),
        Padding(padding: EdgeInsets.only(top: 4)),
        'Contact'.p_White,
      ]),
    );
  }
}
