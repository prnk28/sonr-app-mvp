import 'package:sonr_app/style.dart';
import 'package:sonr_app/style/buttons/utility.dart';

class SNameField extends StatelessWidget {
  /// Widget for Action Icon: Max Size 32
  const SNameField({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ObxValue<RxBool>(
        (isPressed) => GestureDetector(
              onTapDown: (details) => isPressed(true),
              onTapCancel: () => isPressed(false),
              onTapUp: (details) async {
                isPressed(false);
                await HapticFeedback.mediumImpact();
                Future.delayed(ButtonUtility.K_BUTTON_DURATION, () {});
              },
              child: AnimatedScale(
                  scale: isPressed.value ? 1.1 : 1.0,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: UserService.contact.value.sName.size(DisplayTextStyle.Light, fontSize: 24).width + 75),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 24,
                          width: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: SonrColor.Primary.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            SonrIcons.ATSign,
                            color: SonrTheme.itemColorInversed,
                            size: 18,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 4),
                          child: [
                            "${UserService.contact.value.sName}".lightSpan(color: SonrTheme.itemColor, fontSize: 24),
                            ".snr/".lightSpan(color: SonrTheme.greyColor, fontSize: 24),
                          ].rich(),
                        ),
                      ],
                    ),
                  )),
            ),
        false.obs);
  }
}
