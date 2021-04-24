import 'package:get/get.dart';
import 'package:sonr_app/modules/share/share_controller.dart';
import 'package:sonr_app/theme/theme.dart';

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
  _QueueView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.toggle,
      child: Container(
        decoration: BoxDecoration(color: SonrColor.Black, borderRadius: BorderRadius.circular(40)),
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
      ),
    );
  }
}
