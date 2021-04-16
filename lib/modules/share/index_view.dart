import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'share.dart';

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
    if (controller.status.value == ShareStatus.PickMedia) {
      return Container(key: ValueKey<ShareStatus>(ShareStatus.PickMedia));
    } else if (controller.status.value == ShareStatus.Queue) {
      return _QueueView(key: ValueKey<ShareStatus>(ShareStatus.Queue));
    } else {
      return _DefaultButtonView(key: ValueKey<ShareStatus>(ShareStatus.Default));
    }
  }
}

// ** Close Share Button View ** //
class _DefaultButtonView extends GetView<ShareController> {
  _DefaultButtonView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
        onPressed: controller.toggle,
        style: SonrStyle.shareButton,
        child: Container(
          child: SonrIcons.Share.white,
          padding: EdgeWith.vertical(8),
        ));
  }
}

// ** Expanded Share Button View ** //
class _QueueView extends GetView<ShareController> {
  _QueueView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      onPressed: controller.toggle,
      style: SonrStyle.shareButton,
      child: OpacityAnimatedWidget(
          enabled: true,
          duration: 150.milliseconds,
          delay: 350.milliseconds,
          curve: Curves.easeIn,
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            const ShareCameraButtonItem(),
            const ShareGalleryButtonItem(),
            const ShareFileButtonItem(),
            const ShareContactButtonItem(),
          ])),
    );
  }
}
