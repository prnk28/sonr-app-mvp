import 'package:introduction_screen/introduction_screen.dart';
import 'package:sonr_app/style.dart';
import 'package:sonr_app/style/buttons/utility.dart';
import '../register.dart';
import '../register_controller.dart';

class StartView extends GetView<RegisterController> {
  const StartView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ObxValue<RxInt>(
        (index) => IntroductionScreen(
              pages: IntroPageType.values.map<PageViewModel>((e) => e.pageViewModel()).toList(),
              isProgress: _isProgress(index.value),
              onChange: (i) => index(i),
              globalFooter: _buildGlobalFooter(index.value),
              controlsPadding: EdgeInsets.symmetric(horizontal: 16),
              controlsMargin: EdgeInsets.only(bottom: 24),
              showSkipButton: true,
              skip: _buildSkipButton(index.value),
              showDoneButton: false,
              next: Container(
                constraints: BoxConstraints.tight(Size(40, 40)),
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Preferences.isDarkMode ? AppTheme.foregroundColor : Color(0xffEAEAEA),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  SonrIcons.Forward,
                  color: AppTheme.itemColor,
                  size: 24,
                ),
              ),
            ),
        0.obs);
  }

  bool _isProgress(int i) {
    return i + 1 != IntroPageType.values.length;
  }

  Widget _buildSkipButton(int i) {
    if (i + 1 == IntroPageType.values.length) {
      return ColorButton(
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(ButtonUtility.K_BORDER_RADIUS),
            border: Border.all(width: 2, color: Color(0xffE7E7E7))),
        onPressed: () {
          Get.find<RegisterController>().nextPage(RegisterPageType.Name);
        },
        pressedScale: 1.1,
        child: "Continue".heading(
          fontSize: 20,
          color: SonrColor.Black,
        ),
      );
    } else {
      return Container(
        child: "Skip".light(fontSize: 24, align: TextAlign.justify),

        height: 40,
      );
    }
  }

  Widget _buildGlobalFooter(int i) {
    if (i + 1 == IntroPageType.values.length) {
      return Container(
        margin: EdgeInsets.only(bottom: 24),
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ColorButton.neutral(
              borderColor: AppTheme.greyColor.withOpacity(0.9),
              onPressed: () {
                Get.find<RegisterController>().nextPage(RegisterPageType.Name);
              },
              text: "Restore",
            ),
            ColorButton.primary(
              onPressed: () {
                Get.find<RegisterController>().nextPage(RegisterPageType.Name);
              },
              text: "Sign Up",
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class RestoreView extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
    );
  }
}
