import 'package:sonr_app/style.dart';
import 'views/views.dart';
import 'register_controller.dart';

class RegisterPage extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: Neumorphic.floating(theme: Get.theme),
      child: DeviceService.isMobile ? _RegisterMobile() : _RegisterDesktop(),
    );
  }
}

class _RegisterDesktop extends GetView<RegisterController> {
  final RxInt counter = 0.obs;
  final hintName = SonrTextField.hintName();
  final lastNameFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 280),
        child: Column(children: <Widget>[
          Container(
            // child: SonrAssetLogo.Side.widget,
            height: 128,
          ),
          VerticalDivider(),
          Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // ****************** //
                // ** <First Name> ** //
                // ****************** //
                SonrTextField(
                    label: "First Name",
                    hint: hintName.item1,
                    value: controller.firstName.value,
                    status: controller.firstNameStatus,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    autoFocus: true,
                    autoCorrect: false,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(lastNameFocus);
                      controller.firstName(controller.firstName.value.capitalizeFirst!);
                      controller.firstName.refresh();
                    },
                    onChanged: (String value) {
                      controller.firstName(value);
                      controller.firstName.refresh();
                    }),

                // ***************** //
                // ** <Last Name> ** //
                // ***************** //
                SonrTextField(
                    label: "Last Name",
                    hint: hintName.item2,
                    textInputAction: TextInputAction.next,
                    value: controller.lastName.value,
                    textCapitalization: TextCapitalization.words,
                    focusNode: lastNameFocus,
                    status: controller.lastNameStatus,
                    autoCorrect: false,
                    onEditingComplete: () {
                      controller.lastName(controller.lastName.value.capitalizeFirst!);
                      controller.lastName.refresh();
                      FocusScopeNode currentFocus = FocusScope.of(Get.context!);
                      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                        FocusManager.instance.primaryFocus!.unfocus();
                        controller.setContact();
                      }
                    },
                    onChanged: (String value) {
                      controller.lastName(value);
                      controller.lastName.refresh();
                    }),

                // ********************* //
                // ** <Submit Button> ** //
                // ********************* //
                Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 48.0, left: 200, right: 200),
                    child: ColorButton.primary(
                      icon: SonrIcons.Link,
                      text: "Link",
                      onPressed: () {
                        controller.setContact();
                      },
                      //margin: EdgeInsets.only(top: 12),
                    ),
                  ),
                )
              ],
            ),
          )
        ]),
      )),
    );
  }
}

class _RegisterMobile extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedSlideSwitcher.slideRight(
        child: _buildView(controller.status.value),
        duration: const Duration(milliseconds: 2500),
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
    } else {
      return NamePage(key: ValueKey<RegisterStatus>(RegisterStatus.Name));
    }
  }
}
