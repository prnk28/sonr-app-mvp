import 'package:sonr_app/pages/register/widgets/notifier.dart';
import 'package:sonr_app/style.dart';
import 'views/views.dart';
import 'register_controller.dart';

class RegisterPage extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Obx(
        () => AnimatedSlideSwitcher.slideRight(
          child: _buildView(controller.status.value),
          duration: const Duration(milliseconds: 2500),
        ),
      ),
    );
  }

  Widget _buildView(RegisterPageType status) {
    // Return View
    if (status.isPermissions) {
      return NotifyingPermissionsView(
          pages: List<Widget>.generate(RegisterPageTypeUtils.permissionsPageTypes.length, (index) {
        final item = RegisterPageTypeUtils.permissionsPageTypes[index];
        return PermPanel(
          buttonText: item.permissionsButtonText(),
          onPressed: item.permissionsButtonOnPressed(),
          imagePath: item.permissionsImagePath(),
          buttonTextColor: Colors.white,
        );
      }));
    } else if (status.isSetup) {
      return NotifyingSetupView(
        pages: [
          NamePage(key: RegisterPageType.Name.key),
          BackupCodeView(key: RegisterPageType.Backup.key),
          ProfileSetupView(key: RegisterPageType.Contact.key),
        ],
        titleBar: RegisterTitleBar(
          title: status.title,
          instruction: status.instruction,
          isGradient: status.isGradient,
        ),
        bottomSheet: RegisterBottomSheet(
          leftButton: status.leftButton(),
          rightButton: status.rightButton(),
        ),
      );
    } else {
      return _StartView(key: RegisterPageType.Intro.key);
    }
  }
}

class _StartView extends GetView<RegisterController> {
  const _StartView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      AnimatedBuilder(
        animation: controller.panelNotifier,
        builder: (context, _) {
          return Container(
            child: SlidingImage(
              notifier: controller.panelNotifier,
              screenCount: InfoPanelType.values.length,
              image: AssetImage("assets/illustrations/$_imageAsset"),
            ),
          );
        },
      ),
      // Scrollable Page View
      NotifyingIntroView(
        pages: List<Widget>.generate(
            InfoPanelType.values.length,
            (index) => InfoPanel(
                  type: InfoPanelType.values[index],
                )),
      ),
    ]);
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
