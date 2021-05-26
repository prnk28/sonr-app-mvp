import 'package:get/get.dart';
import 'package:sonr_app/pages/home/share/share_view.dart';
import 'package:sonr_app/service/device/mobile.dart';
import 'package:sonr_app/style/style.dart';

class ShareButton extends StatelessWidget {
  ShareButton() : super(key: GlobalKey());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 36.0),
      child: AnimatedContainer(
          curve: Curves.bounceOut,
          duration: Duration(milliseconds: 600),
          width: 90,
          height: 90,
          child: GestureDetector(
            onTap: () {
              Get.to(SharePopupView(), transition: Transition.downToUp, duration: 350.milliseconds);
            },
            child: ClipPolygon(
              borderRadius: 10,
              rotate: 30,
              sides: 6,
              child: Container(
                decoration: BoxDecoration(gradient: SonrGradients.SeaShore),
                alignment: Alignment.center,
                child: SonrIcons.Share.gradient(size: 32, value: SonrGradients.PremiumWhite),
              ),
            ),
          )),
    );
  }
}

class ButtonsAltOptionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Height.ratio(0.15),
      width: Get.width,
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        const _ShareFileButtonItem(),
        VerticalDivider(color: SonrColor.Grey),
        const _ShareContactButtonItem(),
        VerticalDivider(color: SonrColor.Grey),
        const _ShareCameraButtonItem(),
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
          SizedBox(height: 65, width: 55, child: Center(child: SonrIcons.Camera.gradient(value: SonrGradients.CrystalRiver, size: 52))),
          Padding(padding: EdgeInsets.only(top: 4)),
          'Camera'.p_White,
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
          SizedBox(height: 65, width: 65, child: Center(child: SonrIcons.Folder.gradient(value: SonrGradients.ItmeoBranding, size: 52))),
          Padding(padding: EdgeInsets.only(top: 4)),
          'File'.p_White,
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
          SizedBox(height: 65, width: 65, child: Center(child: SonrIcons.ContactCard.gradient(value: SonrGradients.LoveKiss, size: 52))),
          Padding(padding: EdgeInsets.only(top: 4)),
          'Contact'.p_White,
        ]),
      ),
    );
  }
}
