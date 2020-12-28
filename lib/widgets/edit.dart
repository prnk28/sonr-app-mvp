import 'package:get/get.dart';
import 'package:sonar_app/theme/theme.dart';

// ** Edit Dialog View ** //
class SonrEditDialog extends StatelessWidget {
  SonrEditDialog();
  factory SonrEditDialog.colorPicker() {
    Get.dialog(SonrEditDialog(), barrierColor: K_DIALOG_COLOR);
    return SonrEditDialog();
  }

  factory SonrEditDialog.colorComboPicker() {
    Get.dialog(SonrEditDialog(), barrierColor: K_DIALOG_COLOR);
    return SonrEditDialog();
  }

  factory SonrEditDialog.textField() {
    Get.dialog(SonrEditDialog(), barrierColor: K_DIALOG_COLOR);
    return SonrEditDialog();
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// ** Alert Dialog View ** //
class SonrAlertDialog extends StatelessWidget {
  SonrAlertDialog();

  factory SonrAlertDialog.alertOneButton() {
    return SonrAlertDialog();
  }

  factory SonrAlertDialog.alertTwoButton() {
    return SonrAlertDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
