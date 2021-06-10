import 'package:get/get.dart';
import 'package:sonr_app/style.dart';
import 'share.dart';

const K_ROW_BUTTON_SIZE = 75.0;
const K_ROW_CIRCLE_SIZE = 95.0;

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
