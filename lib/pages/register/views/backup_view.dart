import 'package:sonr_app/style.dart';
import 'package:sonr_app/pages/register/register.dart';

class BackupCodeView extends GetView<RegisterController> {
  BackupCodeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DeviceService.hideKeyboard();
    return PagePanel(
      children: [
        GestureDetector(
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: controller.mnemonic.value));
              AppRoute.snack(
                  SnackArgs.alert(title: "Copied!", message: "Backup Code copied to clipboard", icon: Icon(Icons.copy, color: Colors.white)));
            },
            child: BoxContainer(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: ActionButton(
                      iconData: SonrIcons.Info,
                      onPressed: () {
                        AppRoute.alert(
                            title: "About Code",
                            description:
                                "This is your Backup Code if you ever erase your Profile from this device. Back this code in a Safe Location in order to recover your Account.");
                      },
                    ),
                  ),
                  Divider(
                    color: SonrTheme.separatorColor,
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 24),
                    child: controller.mnemonic.value.gradient(value: SonrGradients.CrystalRiver, size: 32),
                  ),
                ],
              ),
            )),
        Padding(padding: EdgeInsets.all(96)),
      ],
    );
  }
}
