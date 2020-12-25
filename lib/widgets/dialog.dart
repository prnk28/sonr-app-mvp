import 'package:get/get.dart';
import 'package:sonar_app/theme/theme.dart';

// ** View Class ** //
class _SonrNeumorphicDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// ** Neumorphic Dialog Operations ** //
class SonrDialog {
  // Constructer
  SonrDialog();

  factory SonrDialog.alertOneButton() {
    Get.dialog(_SonrNeumorphicDialog(), barrierColor: K_DIALOG_COLOR);
    return SonrDialog();
  }

  factory SonrDialog.alertTwoButton() {
    Get.dialog(_SonrNeumorphicDialog(), barrierColor: K_DIALOG_COLOR);
    return SonrDialog();
  }

  factory SonrDialog.colorPicker() {
    Get.dialog(_SonrNeumorphicDialog(), barrierColor: K_DIALOG_COLOR);
    return SonrDialog();
  }

  factory SonrDialog.colorComboPicker() {
    Get.dialog(_SonrNeumorphicDialog(), barrierColor: K_DIALOG_COLOR);
    return SonrDialog();
  }

  factory SonrDialog.textField() {
    Get.dialog(_SonrNeumorphicDialog(), barrierColor: K_DIALOG_COLOR);
    return SonrDialog();
  }
}
