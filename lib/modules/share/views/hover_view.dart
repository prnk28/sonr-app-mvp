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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ShareCameraButtonItem(),
                Padding(padding: EdgeInsets.only(left: 24)),
                _ShareMediaButtonItem(),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 24)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ShareFileButtonItem(),
                Padding(padding: EdgeInsets.only(left: 24)),
                _ShareContactButtonItem(),
              ],
            ),
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
        child: ImageButton(
          label: 'Camera',
          size: K_HOVER_BUTTON_SIZE,
          onPressed: controller.chooseCamera,
          icon: SVGIcons.Camera,
        ));
  }
}

/// @ Camera Share Button
class _ShareMediaButtonItem extends GetView<ShareController> {
  const _ShareMediaButtonItem();
  @override
  Widget build(BuildContext context) {
    return FadeInDownBig(
        delay: 225.milliseconds,
        duration: [265.milliseconds, 225.milliseconds, 285.milliseconds, 245.milliseconds, 300.milliseconds].random(),
        child: ImageButton(
          label: 'Media',
          size: K_HOVER_BUTTON_SIZE,
          onPressed: controller.chooseMedia,
          icon: SVGIcons.MediaSelect,
        ));
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
          size: K_HOVER_BUTTON_SIZE,
          onPressed: controller.chooseFile,
          icon: SVGIcons.Document,
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
          icon: SVGIcons.ContactCard,
          onPressed: controller.chooseContact,
          size: K_HOVER_BUTTON_SIZE,
        ));
  }
}
