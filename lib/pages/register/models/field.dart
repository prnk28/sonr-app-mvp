import 'package:sonr_app/pages/register/register_controller.dart';
import 'package:sonr_app/style/style.dart';

enum RegisterTextFieldType { FirstName, LastName }

extension RegisterTextFieldTypeUtils on RegisterTextFieldType {
  bool get autoCorrect {
    switch (this) {
      case RegisterTextFieldType.FirstName:
        return false;
      case RegisterTextFieldType.LastName:
        return false;
    }
  }

  bool get autoFocus {
    switch (this) {
      case RegisterTextFieldType.FirstName:
        return true;
      case RegisterTextFieldType.LastName:
        return false;
    }
  }

  TextInputType get textInputType {
    switch (this) {
      case RegisterTextFieldType.FirstName:
        return TextInputType.name;
      case RegisterTextFieldType.LastName:
        return TextInputType.name;
    }
  }

  RxString get value {
    switch (this) {
      case RegisterTextFieldType.FirstName:
        return Get.find<RegisterController>().firstName;
      case RegisterTextFieldType.LastName:
        return Get.find<RegisterController>().lastName;
    }
  }

  String get label {
    switch (this) {
      case RegisterTextFieldType.FirstName:
        return "FIRST NAME";
      case RegisterTextFieldType.LastName:
        return "LAST NAME";
    }
  }

  Rx<TextInputValidStatus> get status {
    switch (this) {
      case RegisterTextFieldType.FirstName:
        return Get.find<RegisterController>().firstNameStatus;
      case RegisterTextFieldType.LastName:
        return Get.find<RegisterController>().lastNameStatus;
    }
  }

  List<TextInputFormatter> get inputFormatters => [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))];

  TextInputAction get textInputAction {
    switch (this) {
      case RegisterTextFieldType.FirstName:
        return TextInputAction.next;
      case RegisterTextFieldType.LastName:
        return TextInputAction.done;
    }
  }

  TextCapitalization get textCapitalization {
    switch (this) {
      case RegisterTextFieldType.FirstName:
        return TextCapitalization.words;
      case RegisterTextFieldType.LastName:
        return TextCapitalization.words;
    }
  }
}
