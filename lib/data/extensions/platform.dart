import 'package:sonr_plugin/sonr_plugin.dart';
import 'dart:io' as io;

extension PlatformUtils on Platform {
  /// Method checks if platform has Location ability
  bool get hasLocationAbility {
    return (this == Platform.Android || this == Platform.IOS || this == Platform.MacOS);
  }

  /// Method checks if platform is Desktop Based
  bool get isDesktop {
    return (this != Platform.Android || this != Platform.IOS);
  }

  /// Method checks if platform is Mobile Based
  bool get isMobile {
    return (this == Platform.Android || this == Platform.IOS);
  }

  /// Method uses Dart:IO to find current platform
  static Platform determineFromIO() {
    if (io.Platform.isAndroid) {
      return Platform.Android;
    } else if (io.Platform.isIOS) {
      return Platform.IOS;
    } else if (io.Platform.isLinux) {
      return Platform.Linux;
    } else if (io.Platform.isMacOS) {
      return Platform.MacOS;
    } else if (io.Platform.isWindows) {
      return Platform.Windows;
    } else {
      return Platform.Unknown;
    }
  }
}
