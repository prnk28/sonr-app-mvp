import 'package:sonr_app/style.dart';
import '../register_controller.dart';

class BackupCodeView extends GetView<RegisterController> {
  BackupCodeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DeviceService.hideKeyboard();
    return PagePanel(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          child: GestureDetector(
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: controller.mnemonic.value));
              AppRoute.snack(
                  SnackArgs.alert(title: "Copied!", message: "Backup Code copied to clipboard", icon: Icon(Icons.copy, color: Colors.white)));
            },
            child:
                "This is your Backup Code if you ever erase your Profile from this device. Back this code in a Safe Location in order to recover your Account."
                    .paragraph(color: Get.theme.focusColor),
          ),
        ),
      ],
    );
  }
}
