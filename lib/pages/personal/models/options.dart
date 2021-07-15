import 'package:sonr_app/style/style.dart';

import 'status.dart';

enum ContactOptions {
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

extension ContactOptionUtils on ContactOptions {
  IconData get iconData {
    switch (this) {
      case ContactOptions.Names:
        return SimpleIcons.Pen;
      case ContactOptions.Phone:
        return SimpleIcons.Call;
      case ContactOptions.Addresses:
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
      case ContactOptions.Names:
        return EditorFieldStatus.FieldName;
      case ContactOptions.Phone:
        return EditorFieldStatus.FieldPhone;
      case ContactOptions.Addresses:
        return EditorFieldStatus.FieldAddresses;
      // case ContactOptions.Gender:
      //   return EditorFieldStatus.FieldGender;
    }
  }
}
