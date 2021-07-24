import 'package:sonr_app/style/style.dart';

extension NameStatusUtil on NameStatus {
  /// Checks if NameStatus is Valid
  bool get isValid {
    switch (this) {
      case NameStatus.Available:
        return true;
      default:
        return false;
    }
  }

  /// Returns Icon for Status
  Widget icon() {
    final size = 28.0;
    switch (this) {
      case NameStatus.Default:
        return SimpleIcons.ATSign.icon(color: AppTheme.ItemColorInversed, size: size);
      case NameStatus.Available:
        return SimpleIcons.Check.icon(color: AppColor.Green, size: size);
      case NameStatus.Returning:
        return SimpleIcons.Zap.icon(color: AppColor.Purple, size: size);
      default:
        return SimpleIcons.Alert.icon(color: AppColor.AccentPink, size: size);
    }
  }

  /// Returns Label for Status
  Widget label() {
    final color = AppTheme.GreyColor;
    switch (this) {
      case NameStatus.Default:
        return "Pick Name".light(color: color);
      case NameStatus.Available:
        return "Available!".light(color: color);
      case NameStatus.TooShort:
        return "Too Short".light(color: color);
      case NameStatus.Unavailable:
        return "Unavailable".light(color: color);
      case NameStatus.Blocked:
        return "Blocked".light(color: color);
      case NameStatus.Restricted:
        return "Restricted".light(color: color);
      case NameStatus.DeviceRegistered:
        return "Already Exists".light(color: color);
      case NameStatus.Returning:
        return "Welcome Back!".light(color: color);
      case NameStatus.InvalidCharacters:
        return "Only use a-z letters".light(color: color);
    }
  }

  /// Returns Gradient Data for Status
  Gradient get gradient {
    switch (this) {
      case NameStatus.Default:
        return DesignGradients.MalibuBeach;
      case NameStatus.Available:
        return DesignGradients.ItmeoBranding;
      case NameStatus.Returning:
        return DesignGradients.CrystalRiver;
      default:
        return DesignGradients.PhoenixStart;
    }
  }
}
