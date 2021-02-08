import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';

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

// ** Edit Sheet View for Profile ** //
enum EditType { Color, ColorCombo, TextField }

class EditDialog extends StatelessWidget {
  final Function(dynamic) onChanged;
  final EditType type;
  final String headerText;
  final String textfieldLabel;
  final String textfieldHint;
  final String textfieldValue;
  EditDialog(this.type, this.headerText, this.onChanged, {this.textfieldLabel, this.textfieldHint, this.textfieldValue});

  factory EditDialog.colorPicker({@required String text, @required Function(dynamic) onChanged}) {
    return EditDialog(EditType.Color, text, onChanged);
  }

  factory EditDialog.colorComboPicker({@required String text, @required Function(dynamic) onChanged}) {
    return EditDialog(EditType.ColorCombo, text, onChanged);
  }

  factory EditDialog.textField(String label, String hint, String value, {@required String text, @required Function(dynamic) onChanged}) {
    return EditDialog(
      EditType.TextField,
      text,
      onChanged,
      textfieldLabel: label,
      textfieldHint: hint,
      textfieldValue: value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicBackground(
        margin: EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 200),
        borderRadius: BorderRadius.circular(20),
        backendColor: Colors.transparent,
        child: Neumorphic(
            style: NeumorphicStyle(color: K_BASE_COLOR),
            child: Container(
                width: _getSize().width,
                height: _getSize().height,
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  // @ Top Banner
                  Expanded(
                    child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      // Bottom Left Close/Cancel Button
                      SonrButton.close(() {
                        Get.back();
                      }),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: SonrText.header("Edit + $headerText", size: 24),
                      ),

                      // Bottom Right Confirm Button
                      SonrButton.accept(() {
                        Get.back();
                      }),
                    ]),
                  ),

                  // @ Window Content
                  Spacer(),
                  _buildView(),
                  Spacer()
                ]))));
  }

  // ^ Build View by EditType ^ //
  Widget _buildView() {
    switch (type) {
      case EditType.Color:
        return Container();
        break;
      case EditType.ColorCombo:
        return Container();
        break;
      case EditType.TextField:
        return Material(
          color: Colors.transparent,
          child: SonrTextField(hint: textfieldHint, label: textfieldLabel, value: textfieldValue, onChanged: onChanged),
        );
        break;
    }
    return Container();
  }

  // ^ Get Window Size by EditType ^ //
  Size _getSize() {
    switch (type) {
      case EditType.Color:
        return Size(Get.width - 60, Get.height / 3 + 150);
        break;
      case EditType.ColorCombo:
        return Size(Get.width - 60, Get.height / 4 + 95);
        break;
      case EditType.TextField:
        return Size(Get.width - 60, 80);
        break;
    }
    return Size(0, 0);
  }
}
