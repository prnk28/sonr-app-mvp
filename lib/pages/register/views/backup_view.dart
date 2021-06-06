import 'package:sonr_app/style/style.dart';
import '../register_controller.dart';

class BackupCodeView extends GetView<RegisterController> {
  BackupCodeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SonrScaffold(
      gradient: SonrGradients.SeaShore,
      body: Container(
        padding: EdgeInsets.all(16),
        width: Get.width,
        height: Get.height,
        child: Column(
          children: [
            "Backup Code".gradient(value: SonrGradients.PremiumWhite, size: 52),
            Divider(color: Get.theme.hintColor.withOpacity(0.6), indent: 8, endIndent: 8),
            Padding(padding: EdgeInsets.all(8)),
            "This is your Backup Code if you ever erase your Profile from this device. Back this code in a Safe Location in order to recover your Account."
                .paragraph(color: Get.theme.focusColor),
            Padding(padding: EdgeInsets.all(8)),

            // Code
            GestureDetector(
              onTap: _copyCode,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 56),
                child: controller.mnemonic.value.subheading(),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(bottom: 32),
                  child: ColorButton.neutral(onPressed: controller.exportCode, text: "Save"),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(bottom: 32),
                  child: ColorButton.primary(onPressed: controller.nextFromBackup, text: "Next"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Copy Backup Code to Clipboard
  void _copyCode() async {
    Clipboard.setData(ClipboardData(text: controller.mnemonic.value));
    Snack.alert(title: "Copied!", message: "Backup Code copied to clipboard", icon: Icon(Icons.copy, color: Colors.white));
  }
}
