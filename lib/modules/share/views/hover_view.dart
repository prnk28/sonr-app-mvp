import 'package:sonr_app/style/style.dart';

class ShareHoverView extends GetView<ShareController> {
  final Peer peer;

  ShareHoverView({required this.peer});
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: AppTheme.backgroundColor,
            border: Border.all(
              color: AppTheme.foregroundColor,
              width: 1.5,
            )),
        constraints: BoxConstraints(maxWidth: 200, maxHeight: 300),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 24),
        child: GridView(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 24),
          children: [
            _ShareCameraButtonItem(),
            _ShareFileButtonItem(),
            _ShareContactButtonItem(),
          ],
        ));
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
      child: IntricateIcons.Camera.svg(
        //label: 'Camera',
        width: K_ROW_BUTTON_SIZE,
        height: K_ROW_BUTTON_SIZE,
        // circleSize: K_ROW_CIRCLE_SIZE,
        // onPressed: controller.chooseCamera,
        // path: 'assets/images/icons/Camera.png',
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
          path: 'assets/images/icons/Folder.png',
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
          path: 'assets/images/icons/Contact.png',
        ));
  }
}
