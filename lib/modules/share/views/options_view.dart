import 'package:get/get.dart';
import 'package:sonr_app/modules/share/share.dart';
import 'package:sonr_app/style.dart';

class ShareOptionsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Height.ratio(0.2),
      width: Get.width,
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        const _ShareCameraButtonItem(),
        VerticalDivider(color: SonrTheme.dividerColor),
        const _ShareContactButtonItem(),
        VerticalDivider(color: SonrTheme.dividerColor),
        const _ShareFileButtonItem(),
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
      child: ImageButton(
        label: 'Camera',
        imageWidth: K_ROW_BUTTON_SIZE,
        imageHeight: K_ROW_BUTTON_SIZE,
        circleSize: K_ROW_CIRCLE_SIZE,
        onPressed: controller.chooseCamera,
        path: 'assets/images/Camera.png',
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
        child: ImageButton(
          label: 'File',
          imageWidth: K_ROW_BUTTON_SIZE,
          imageHeight: K_ROW_BUTTON_SIZE,
          circleSize: K_ROW_CIRCLE_SIZE,
          onPressed: controller.chooseFile,
          path: 'assets/images/Folder.png',
        ));
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
        child: ImageButton(
          label: 'Contact',
          imageWidth: K_ROW_BUTTON_SIZE,
          imageHeight: K_ROW_BUTTON_SIZE,
          circleSize: K_ROW_CIRCLE_SIZE,
          onPressed: controller.chooseContact,
          path: 'assets/images/Contact.png',
        ));
  }
}
