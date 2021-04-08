import 'package:get/get.dart';
import 'package:sonr_app/modules/common/media/queue_view.dart';
import 'package:sonr_app/modules/share/share_controller.dart';
import 'package:sonr_app/modules/share/option_widget.dart';
import 'package:sonr_app/theme/theme.dart';

class ShareButton extends GetView<ShareController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedContainer(
        curve: Curves.bounceOut,
        duration: Duration(milliseconds: 600),
        width: controller.size.value.width,
        height: controller.size.value.height,
        child: NeumorphicButton(
          child: _buildChild(),
          onPressed: controller.toggle,
          style: SonrStyle.shareButton,
        )));
  }

  Widget _buildChild() {
    if (controller.status.value.isQueued) {
      return _QueueView();
    }
    if (controller.status.value.isMedia) {
      return MediaQueueView();
    }
    return _DefaultView();
  }
}

// ** Close Share Button View ** //
class _DefaultView extends GetView<ShareController> {
  @override
  Widget build(BuildContext context) {
    return Container(child: SonrIcon.send, padding: EdgeWith.vertical(8));
  }
}

// ** Expanded Share Button View ** //
class _QueueView extends GetView<ShareController> {
  @override
  Widget build(BuildContext context) {
    return OpacityAnimatedWidget(
        enabled: true,
        duration: 150.milliseconds,
        delay: 350.milliseconds,
        curve: Curves.easeIn,
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          const ShareCameraButtonItem(),
          const ShareGalleryButtonItem(),
          const ShareContactButtonItem(),
        ]));
  }
}
