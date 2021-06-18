import 'package:sonr_app/style.dart';
import '../register_controller.dart';

class BackupCodeView extends GetView<RegisterController> {
  BackupCodeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PagePanel(
      titleBar: RegisterTitleBar(
        title: "Backup Code",
        instruction: "Secure Your",
      ),
      buttons: [
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(bottom: 32),
          child: ColorButton.neutral(onPressed: controller.exportCode, text: "Save"),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(bottom: 32),
          child: ColorButton.primary(onPressed: () => controller.nextPage(RegisterPageType.Contact), text: "Next"),
        )
      ],
      children: [
        Padding(padding: EdgeInsets.all(8)),
        GestureDetector(
          onLongPress: () => _copyCode(),
          child:
              "This is your Backup Code if you ever erase your Profile from this device. Back this code in a Safe Location in order to recover your Account."
                  .paragraph(color: Get.theme.focusColor),
        ),
        Padding(padding: EdgeInsets.all(8)),
      ],
    );
  }

  /// Copy Backup Code to Clipboard
  void _copyCode() async {
    Clipboard.setData(ClipboardData(text: controller.mnemonic.value));
    AppRoute.snack(SnackArgs.alert(title: "Copied!", message: "Backup Code copied to clipboard", icon: Icon(Icons.copy, color: Colors.white)));
  }
}
