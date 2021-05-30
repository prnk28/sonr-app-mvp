import 'package:get/get.dart';
import 'package:sonr_app/service/device/mobile.dart';
import 'package:sonr_app/style/style.dart';
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
                    Future.delayed(150.milliseconds, () => Share.popup());
                  },
                  child: ClipPolygon(
                    borderRadius: 18,
                    rotate: 30,
                    sides: 6,
                    child: Container(
                      decoration: BoxDecoration(gradient: SonrGradients.SeaShore),
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
      height: Height.ratio(0.18),
      width: Get.width,
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        const _ShareCameraButtonItem(),
        VerticalDivider(color: SonrColor.Grey),
        const _ShareContactButtonItem(),
        VerticalDivider(color: SonrColor.Grey),
        const _ShareFileButtonItem(),
      ]),
    );
  }
}

/// @ Camera Share Button
class _ShareCameraButtonItem extends StatelessWidget {
  const _ShareCameraButtonItem();
  @override
  Widget build(BuildContext context) {
    return FadeInDownBig(
      delay: 225.milliseconds,
      duration: [265.milliseconds, 225.milliseconds, 285.milliseconds, 245.milliseconds, 300.milliseconds].random(),
      child: GestureDetector(
        onTap: () async {
          // Check for Permissions
          if (MobileService.hasCamera.value) {
            TransferService.chooseCamera();
          }
          // Request Permissions
          else {
            var result = await Get.find<MobileService>().requestCamera();
            result ? TransferService.chooseCamera() : SonrSnack.error("Sonr cannot open Camera without Permissions");
          }
        },
        child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset("assets/images/Camera.png", fit: BoxFit.fitHeight, height: 75),
          Padding(padding: EdgeInsets.only(top: 4)),
          UserService.isDarkMode ? 'Camera'.h6_White : 'Camera'.h6_Grey,
        ]),
      ),
    );
  }
}

/// @ File Share Button
class _ShareFileButtonItem extends StatelessWidget {
  const _ShareFileButtonItem();
  @override
  Widget build(BuildContext context) {
    return FadeInDownBig(
      delay: 225.milliseconds,
      duration: [265.milliseconds, 225.milliseconds, 285.milliseconds, 245.milliseconds, 300.milliseconds].random(),
      child: GestureDetector(
        onTap: () async {
          // Check Permissions
          if (MobileService.hasGallery.value) {
            await TransferService.chooseFile();
          } else {
            // Request Permissions
            var status = await Get.find<MobileService>().requestGallery();
            SonrOverlay.back();

            // Check Status
            if (status) {
              await TransferService.chooseFile();
            } else {
              SonrSnack.error("Cannot pick Media without Permissions");
            }
          }
        },
        child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset("assets/images/Folder.png", fit: BoxFit.fitHeight, height: 75),
          Padding(padding: EdgeInsets.only(top: 4)),
          UserService.isDarkMode ? 'File'.h6_White : 'File'.h6_Grey,
        ]),
      ),
    );
  }
}

/// @ Contact Share Button
class _ShareContactButtonItem extends StatelessWidget {
  const _ShareContactButtonItem();
  @override
  Widget build(BuildContext context) {
    return FadeInDownBig(
      delay: 225.milliseconds,
      duration: [265.milliseconds, 225.milliseconds, 285.milliseconds, 245.milliseconds, 300.milliseconds].random(),
      child: GestureDetector(
        onTap: () => TransferService.chooseContact(),
        child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset("assets/images/Contact.png", fit: BoxFit.fitHeight, height: 75),
          Padding(padding: EdgeInsets.only(top: 4)),
          UserService.isDarkMode ? 'Contact'.h6_White : 'Contact'.h6_Grey,
        ]),
      ),
    );
  }
}
