import 'package:sonr_app/style/style.dart';

enum NewSNameStatus {
  Default,
  Returning,
  TooShort,
  Available,
  Unavailable,
  Blocked,
  Restricted,
  DeviceRegistered,
  InvalidCharacters,
}

extension NewSNameStatusUtil on NewSNameStatus {
  /// Checks if NewSNameStatus is Valid
  bool get isValid {
    switch (this) {
      case NewSNameStatus.Available:
        return true;
      default:
        return false;
    }
  }

  /// Returns Icon for Status
  Widget icon() {
    final size = 28.0;
    switch (this) {
      case NewSNameStatus.Default:
        return SonrIcons.ATSign.icon(color: AppTheme.itemColorInversed, size: size);
      case NewSNameStatus.Available:
        return SonrIcons.Check.icon(color: SonrColor.Tertiary, size: size);
      case NewSNameStatus.Returning:
        return SonrIcons.Zap.icon(color: SonrColor.Secondary, size: size);
      default:
        return SonrIcons.Alert.icon(color: SonrColor.AccentPink, size: size);
    }
  }

  /// Returns Label for Status
  Widget label() {
    final color = AppTheme.greyColor;
    switch (this) {
      case NewSNameStatus.Default:
        return "Pick Name".light(color: color);
      case NewSNameStatus.Available:
        return "Available!".light(color: color);
      case NewSNameStatus.TooShort:
        return "Too Short".light(color: color);
      case NewSNameStatus.Unavailable:
        return "Unavailable".light(color: color);
      case NewSNameStatus.Blocked:
        return "Blocked".light(color: color);
      case NewSNameStatus.Restricted:
        return "Restricted".light(color: color);
      case NewSNameStatus.DeviceRegistered:
        return "Already Exists".light(color: color);
      case NewSNameStatus.Returning:
        return "Welcome Back!".light(color: color);
      case NewSNameStatus.InvalidCharacters:
        return "Only use a-z letters".light(color: color);
    }
  }

  /// Returns Gradient Data for Status
  Gradient get gradient {
    switch (this) {
      case NewSNameStatus.Default:
        return SonrGradient.Primary;
      case NewSNameStatus.Available:
        return SonrGradient.Tertiary;
      case NewSNameStatus.Returning:
        return SonrGradient.Secondary;
      default:
        return SonrGradient.Critical;
    }
  }
}
