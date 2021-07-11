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
        return SimpleIcons.ATSign.icon(color: AppTheme.ItemColorInversed, size: size);
      case NewSNameStatus.Available:
        return SimpleIcons.Check.icon(color: AppColor.Green, size: size);
      case NewSNameStatus.Returning:
        return SimpleIcons.Zap.icon(color: AppColor.Purple, size: size);
      default:
        return SimpleIcons.Alert.icon(color: AppColor.AccentPink, size: size);
    }
  }

  /// Returns Label for Status
  Widget label() {
    final color = AppTheme.GreyColor;
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
        return DesignGradients.MalibuBeach;
      case NewSNameStatus.Available:
        return DesignGradients.ItmeoBranding;
      case NewSNameStatus.Returning:
        return DesignGradients.CrystalRiver;
      default:
        return DesignGradients.PhoenixStart;
    }
  }
}
