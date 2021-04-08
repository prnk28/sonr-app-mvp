import 'package:get/get.dart';
import 'package:sonr_app/modules/share/share_controller.dart';
import 'package:sonr_app/theme/theme.dart';

// ^ Camera Share Button ^ //
class ShareCameraButtonItem extends GetView<ShareController> {
  const ShareCameraButtonItem();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.onCameraShare,
      child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
        RiveContainer(
          width: 55,
          height: 55,
          type: RiveBoard.Camera,
        ),
        Padding(padding: EdgeInsets.only(top: 4)),
        SonrText('Camera', weight: FontWeight.w500, size: 14, key: key, color: SonrColor.White),
      ]),
    );
  }
}

// ^ Gallery Share Button ^ //
class ShareGalleryButtonItem extends GetView<ShareController> {
  const ShareGalleryButtonItem();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.onGalleryShare,
      child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
        RiveContainer(
          width: 55,
          height: 55,
          type: RiveBoard.Gallery,
        ),
        Padding(padding: EdgeInsets.only(top: 4)),
        SonrText('Gallery', weight: FontWeight.w500, size: 14, key: key, color: SonrColor.White),
      ]),
    );
  }
}

// ^ Contact Share Button ^ //
class ShareContactButtonItem extends GetView<ShareController> {
  const ShareContactButtonItem();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SonrService.queueContact();

        // Go to Transfer
        Get.toNamed("/transfer");
        controller.shrink(delay: 150.milliseconds);
      },
      child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
        RiveContainer(
          width: 55,
          height: 55,
          type: RiveBoard.Contact,
        ),
        Padding(padding: EdgeInsets.only(top: 4)),
        SonrText('Contact', weight: FontWeight.w500, size: 14, key: key, color: SonrColor.White),
      ]),
    );
  }
}