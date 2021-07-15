import 'package:introduction_screen/introduction_screen.dart';
import 'package:sonr_app/style/style.dart';
import '../register.dart';
import '../register_controller.dart';

class StartView extends GetView<RegisterController> {
  const StartView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      color: AppColor.White,
      child: ObxValue<RxInt>(
          (index) => IntroductionScreen(
                globalBackgroundColor: AppColor.White,
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
                    color: AppTheme.ItemColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    SimpleIcons.Forward,
                    color: AppTheme.ItemColorInversed,
                    size: 24,
                  ),
                ),
              ),
          0.obs),
    );
  }

  bool _isProgress(int i) {
    return i + 1 != IntroPageType.values.length;
  }

  Widget _buildSkipButton(int i) {
    if (i + 1 == IntroPageType.values.length) {
      return ColorButton.neutral(
        onPressed: () {
          Get.find<RegisterController>().nextPage(RegisterPageType.Name);
        },
        text: 'Continue',
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
        margin: EdgeInsets.only(bottom: 32),
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ColorButton.neutral(
              borderColor: AppTheme.GreyColor.withOpacity(0.9),
              onPressed: () {
                Get.find<RegisterController>().nextPage(RegisterPageType.Name);
              },
              text: "Restore",
            ),
            ColorButton.primary(
              gradientRadius: 1.75,
              onPressed: () {
                Get.find<RegisterController>().nextPage(RegisterPageType.Name);
              },
              text: "Start",
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
