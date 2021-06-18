import 'package:sonr_app/style.dart';
import '../register_controller.dart';

class BackupCodeView extends GetView<RegisterController> {
  BackupCodeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DeviceService.hideKeyboard();
    return PagePanel(
      children: [
        Divider(
          color: SonrTheme.separatorColor,
        ),
        GestureDetector(
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: controller.mnemonic.value));
              AppRoute.snack(
                  SnackArgs.alert(title: "Copied!", message: "Backup Code copied to clipboard", icon: Icon(Icons.copy, color: Colors.white)));
            },
            child: BoxContainer(
              padding: EdgeInsets.all(24),
              child: Stack(
                children: [
                  Container(padding: EdgeWith.top(24),child: controller.mnemonic.value.gradient(value: SonrGradient.Theme(radius: 2), size: 36)),
                  Align(
                    alignment: Alignment.topRight,
                    child: ActionButton(
                      iconData: SonrIcons.Info,
                      onPressed: () {
                        AppRoute.alert(
                            title: "About",
                            description:
                                "This is your Backup Code if you ever erase your Profile from this device. Back this code in a Safe Location in order to recover your Account.");
                      },
                    ),
                  )
                ],
              ),
            )),
        Padding(padding: EdgeInsets.all(64)),
      ],
    );
  }
}
