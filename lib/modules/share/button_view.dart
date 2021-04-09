import 'package:get/get.dart';
import 'package:sonr_app/modules/common/lobby/lobby.dart';
import 'package:sonr_app/theme/theme.dart';
import 'share.dart';

class ShareButtonView extends GetView<ShareController> {
  ShareButtonView() : super(key: GlobalKey());
  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedAlign(
          curve: Curves.bounceOut,
          duration: Duration(milliseconds: 600),
          alignment: controller.alignment.value,
          child: AnimatedContainer(
              alignment: controller.alignment.value,
              transform: controller.translation.value,
              curve: Curves.bounceOut,
              duration: Duration(milliseconds: 600),
              width: controller.size.value.width,
              height: controller.size.value.height,
              child: _buildView(controller.status.value)),
        ));
  }

  // @ Build Page View by Navigation Item
  Widget _buildView(ShareStatus status) {
    // Return View
    if (status == ShareStatus.PickMedia) {
      return MediaPickView(key: ValueKey<ShareStatus>(ShareStatus.PickMedia));
    } else if (status == ShareStatus.Queue) {
      return _QueueView(key: ValueKey<ShareStatus>(ShareStatus.Queue));
    } else {
      return _DefaultView(key: ValueKey<ShareStatus>(ShareStatus.Default));
    }
  }
}

// ** Close Share Button View ** //
class _DefaultView extends GetView<ShareController> {
  _DefaultView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
        onPressed: controller.toggle,
        style: SonrStyle.shareButton,
        child: Container(
          child: SonrIcon.send,
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
            const ShareContactButtonItem(),
          ])),
    );
  }
}
