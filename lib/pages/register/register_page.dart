import 'package:sonr_app/style.dart';
import 'package:sonr_app/style/buttons/utility.dart';
import 'views/views.dart';
import 'register_controller.dart';

class RegisterPage extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return BoxContainer(
      width: Get.width,
      height: Get.height,
      child: Obx(
        () => AnimatedSlideSwitcher.slideRight(
          child: _buildView(controller.status.value),
          duration: const Duration(milliseconds: 2500),
        ),
      ),
    );
  }

  Widget _buildView(RegisterStatus status) {
    // Return View
    if (status == RegisterStatus.Location) {
      return BoardingLocationView(key: ValueKey<RegisterStatus>(RegisterStatus.Location));
    } else if (status == RegisterStatus.Gallery) {
      return BoardingGalleryView(key: ValueKey<RegisterStatus>(RegisterStatus.Gallery));
    } else if (status == RegisterStatus.Contact) {
      return FormPage(key: ValueKey<RegisterStatus>(RegisterStatus.Contact));
    } else if (status == RegisterStatus.Backup) {
      return BackupCodeView(key: ValueKey<RegisterStatus>(RegisterStatus.Backup));
    } else if (status == RegisterStatus.Start) {
      return _StartView(key: ValueKey<RegisterStatus>(RegisterStatus.Start));
    } else {
      return NamePage(key: ValueKey<RegisterStatus>(RegisterStatus.Name));
    }
  }
}

class _StartView extends StatelessWidget {
  const _StartView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
          top: false,
          bottom: false,
          left: false,
          right: false,
          child: Stack(children: [
            Container(
              width: Get.width,
              height: Get.height,
              child: Image.asset(
                "assets/illustrations/$_imageAsset",
                fit: BoxFit.fill,
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 132, right: 32),
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "Seamless Transfer".heading(color: SonrColor.White),
                  "No File Size Limits".paragraph(color: SonrColor.White),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(bottom: 24),
                alignment: Alignment.bottomCenter,
                child: ColorButton(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(ButtonUtility.K_BORDER_RADIUS),
                      border: Border.all(width: 2, color: Color(0xffE7E7E7))),
                  onPressed: () {},
                  pressedScale: 1.1,
                  child: "Get Started".heading(
                    fontSize: 20,
                    color: SonrColor.White,
                  ),
                ))
          ])),
    );
  }

  String get _imageAsset {
    // Get Quarter from Date
    final date = DateTime.now();

    // Determine Month from Quarter
    if (date.month.isOneOf([3, 4, 5])) {
      return "Spring.png";
    } else if (date.month.isOneOf([6, 7, 8])) {
      return "Summer.png";
    } else if (date.month.isOneOf([9, 10, 11])) {
      return "Fall.png";
    } else {
      return "Winter.png";
    }
  }
}

extension NumUtils on int {
  bool isOneOf(List<int> options) {
    bool contains = false;
    options.forEach((i) {
      if (this == i) {
        contains = true;
      }
    });
    return contains;
  }
}
