import 'package:sonr_app/style/style.dart';

import 'status.dart';

enum UserOptions {
  Devices,
  Names,
  Phone,
  Addresses,
  //Gender,
  // Music
  // Social
  // Emails
  // Websites
  // Payments
}

extension UserOptionsUtils on UserOptions {
  IconData get iconData {
    switch (this) {
      case UserOptions.Devices:
        return SimpleIcons.IPhoneClassic;
      case UserOptions.Names:
        return SimpleIcons.Pen;
      case UserOptions.Phone:
        return SimpleIcons.Call;
      case UserOptions.Addresses:
        return SimpleIcons.Location;
      // case ContactOptions.Gender:
      //   return SimpleIcons.User;
    }
  }

  String get name {
    return this.toString().substring(this.toString().indexOf('.') + 1);
  }

  EditorFieldStatus get editorStatus {
    switch (this) {
      case UserOptions.Names:
        return EditorFieldStatus.FieldName;
      case UserOptions.Phone:
        return EditorFieldStatus.FieldPhone;
      case UserOptions.Addresses:
        return EditorFieldStatus.FieldAddresses;
      default:
        return EditorFieldStatus.Default;
    }
  }
}
