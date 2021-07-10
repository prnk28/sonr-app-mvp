import 'package:sonr_app/style/style.dart';

/// Button that opens share View
class ShareButton extends StatelessWidget {
  ShareButton() : super(key: GlobalKey());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
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
                    Future.delayed(150.milliseconds, () => AppPage.Share.to(init: ShareController.initPopup));
                  },
                  child: PolyContainer(
                    radius: 24,
                    rotate: 30,
                    sides: 6,
                    child: SimpleIcons.Share.gradient(size: 34, value: DesignGradients.PremiumWhite),
                  ),
                ),
              )),
          false.obs),
    );
  }
}
