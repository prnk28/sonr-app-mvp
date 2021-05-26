import 'package:sonr_app/style/style.dart';

enum ContactOptions {
  Names,
  Addresses,
  Gender,
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
        return SonrIcons.Pen;
      case ContactOptions.Addresses:
        return SonrIcons.Location;
      case ContactOptions.Gender:
        return SonrIcons.User;
    }
  }

  String get name {
    return this.toString().substring(this.toString().indexOf('.') + 1);
  }
}
