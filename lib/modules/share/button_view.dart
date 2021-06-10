import 'package:get/get.dart';
import 'package:sonr_app/style.dart';
import 'share.dart';

class ShareButton extends StatelessWidget {
  ShareButton() : super(key: GlobalKey());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 36.0),
      child: ObxValue<RxBool>(
          (isPressed) => AnimatedScale(
              duration: Duration(milliseconds: 150),
              scale: isPressed.value ? 1.1 : 1,
              child: Container(
                width: 95,
                height: 95,
                child: GestureDetector(
                  onTapDown: (details) => isPressed(true),
                  onTapUp: (details) {
                    isPressed(false);
                    Future.delayed(150.milliseconds, () => ShareView.popup());
                  },
                  child: ClipPolygon(
                    borderRadius: 24,
                    rotate: 30,
                    boxShadows: SonrTheme.polyBoxShadow,
                    sides: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: SonrTheme.primaryGradient,
                        boxShadow: SonrTheme.boxShadow,
                        border: Border.all(color: SonrTheme.foregroundColor, width: 1),
                      ),
                      alignment: Alignment.center,
                      child: SonrIcons.Share.gradient(size: 34, value: SonrGradients.PremiumWhite),
                    ),
                  ),
                ),
              )),
          false.obs),
    );
  }
}

class ShareOptionsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Height.ratio(0.2),
      width: Get.width,
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        const _ShareCameraButtonItem(),
        VerticalDivider(color: SonrTheme.separatorColor),
        const _ShareContactButtonItem(),
        VerticalDivider(color: SonrTheme.separatorColor),
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
      child: GestureDetector(
        onTap: controller.chooseCamera,
        child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              decoration: BoxDecoration(
                color: SonrTheme.foregroundColor,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(24),
              child: Image.asset("assets/images/Camera.png", fit: BoxFit.fitHeight, height: 52)),
          Padding(padding: EdgeInsets.only(top: 4)),
          'Camera'.light(color: SonrTheme.textColor.withOpacity(0.8)),
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
        onTap: controller.chooseFile,
        child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              decoration: BoxDecoration(
                color: SonrTheme.foregroundColor,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(24),
              child: Image.asset("assets/images/Folder.png", fit: BoxFit.fitHeight, height: 52)),
          Padding(padding: EdgeInsets.only(top: 4)),
          'File'.light(color: SonrTheme.textColor.withOpacity(0.8)),
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
        onTap: controller.chooseContact,
        child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              decoration: BoxDecoration(
                color: SonrTheme.foregroundColor,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(24),
              child: Image.asset("assets/images/Contact.png", fit: BoxFit.fitHeight, height: 52)),
          Padding(padding: EdgeInsets.only(top: 4)),
          'Contact'.light(color: SonrTheme.textColor.withOpacity(0.8)),
        ]),
      ),
    );
  }
}
