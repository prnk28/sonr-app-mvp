import 'package:flutter/foundation.dart';
import 'package:sonr_app/service/client/sonr.dart';
import 'package:sonr_app/style.dart';
import 'package:sonr_app/data/data.dart';

// ** ─── BuildMode Arguments ────────────────────────────────────────────────────────
/// Build Mode Enum
enum BuildMode { Release, Debug }

extension BuildModeUtil on BuildMode {
  /// Returns Current BuildMode from Foundation
  static BuildMode current() {
    if (kReleaseMode) {
      return BuildMode.Release;
    } else {
      return BuildMode.Debug;
    }
  }

  /// Checks if Build Mode is Debug
  bool get isDebug => this == BuildMode.Debug && !kReleaseMode;

  /// Checks if Build Mode is Release
  bool get isRelease => this == BuildMode.Release && kReleaseMode;
}

// ** ─── Snackbar Arguments ────────────────────────────────────────────────────────
/// Class to Provide Snackbar Properties to AppRoute
class SnackArgs {
  // Properties
  final Color? color;
  final String? title;
  final String message;
  final Widget icon;
  final int duration;
  final bool shouldIconPulse;
  final SnackPosition position;

  SnackArgs(this.title, this.message, this.icon, this.color, this.duration, this.shouldIconPulse, this.position);

  /// @ Custom Alert
  factory SnackArgs.remote({
    required String message,
    int duration = 45000,
    Color color = Colors.purple,
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    return SnackArgs("Remote Code", message, SonrIcons.Remote.white, color, duration, true, position);
  }

  /// @ Custom Alert
  factory SnackArgs.alert({
    required String title,
    required String message,
    required Icon icon,
    Color color = Colors.orange,
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    return SnackArgs(title, message, icon, color, 2600, false, position);
  }

  /// @ Cancelled Operation
  factory SnackArgs.cancelled(String message, {SnackPosition position = SnackPosition.BOTTOM}) {
    return SnackArgs("Cancelled.", message, SonrIcons.Stop.white, Colors.yellow, 2600, false, position);
  }

  /// @ Error on Operation
  factory SnackArgs.error(String message, {ErrorMessage? error}) {
    // @ Internal Error
    if (error != null) {
      switch (error.severity) {
        // Orange - Title Failed
        case ErrorMessage_Severity.CRITICAL:
          DeviceService.playSound(type: UISoundType.Critical);
          return SnackArgs(
            "Failed",
            error.message,
            Icon(Icons.sms_failed_outlined),
            Colors.orange,
            2600,
            false,
            SnackPosition.TOP,
          );

        // Red - Title Error
        case ErrorMessage_Severity.FATAL:
          DeviceService.playSound(type: UISoundType.Fatal);
          return SnackArgs(
            "Error",
            error.message,
            SonrIcons.Caution.white,
            Colors.red,
            2600,
            false,
            SnackPosition.TOP,
          );

        // Yellow - Title Warning
        default:
          DeviceService.playSound(type: UISoundType.Warning);
          return SnackArgs(
            "Warning",
            error.message,
            SonrIcons.Warning.white,
            Colors.yellow,
            2600,
            false,
            SnackPosition.BOTTOM,
          );
      }
    }
    // @ App Error
    else {
      DeviceService.playSound(type: UISoundType.Warning);
      return SnackArgs(
        "Error",
        message,
        SonrIcons.Caution.white,
        Colors.red,
        2600,
        false,
        SnackPosition.TOP,
      );
    }
  }

  /// @ Invalid Operation
  factory SnackArgs.invalid(String message, {SnackPosition position = SnackPosition.BOTTOM}) {
    return SnackArgs(
      "Uh Oh!",
      message,
      SonrIcons.Warning.white,
      Colors.orange[900],
      2600,
      false,
      position,
    );
  }

  /// @ Missing Data
  factory SnackArgs.missing(String message, {bool isLast = false, SnackPosition position = SnackPosition.BOTTOM}) {
    // Get Missing Title
    final list = ['Wait!', 'Hold Up!', "Uh Oh!"];
    return SnackArgs(
      isLast ? "Almost There!" : list.random(),
      message,
      SonrIcons.Warning.white,
      SonrColor.Critical,
      2600,
      false,
      position,
    );
  }

  /// @ Succesful Operation
  factory SnackArgs.success(String message, {SnackPosition position = SnackPosition.BOTTOM}) {
    return SnackArgs(
      "Success!!",
      message,
      SonrIcons.Success.white,
      Colors.green,
      2600,
      true,
      position,
    );
  }
}
