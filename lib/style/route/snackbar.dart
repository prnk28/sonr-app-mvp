import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snack.dart';
import 'package:sonr_app/style.dart';
import 'package:sonr_app/data/data.dart';

class Snack {
  // Properties
  final Color? color;
  final String? title;
  final String message;
  final Widget icon;
  final int duration;
  final bool shouldIconPulse;

  /// @ Default Constructer
  Snack(this.title, this.message, this.icon, this.color, this.duration, this.shouldIconPulse) {
    if (!Get.isSnackbarOpen!) {
      Get.snackbar(title!, message,
          snackStyle: SnackStyle.FLOATING,
          duration: Duration(milliseconds: duration),
          snackPosition: SnackPosition.BOTTOM,
          reverseAnimationCurve: Curves.elasticOut,
          backgroundColor: color,
          icon: icon,
          colorText: Colors.white);
    }
  }

  /// @ Custom Alert
  factory Snack.remote({required String message, int duration = 45000, Color color = Colors.purple}) {
    return Snack("Remote Code", message, SonrIcons.Remote.white, color, duration, true);
  }

  /// @ Custom Alert
  factory Snack.alert({required String title, required String message, required Icon icon, Color color = Colors.orange}) {
    return Snack(title, message, icon, color, 2600, false);
  }

  /// @ Cancelled Operation
  factory Snack.cancelled(String message) {
    return Snack("Cancelled.", message, SonrIcons.Stop.white, Colors.yellow, 2600, false);
  }

  /// @ Error on Operation
  factory Snack.error(String message, {ErrorMessage? error}) {
    // @ Internal Error
    if (error != null) {
      switch (error.severity) {
        // Orange - Title Failed
        case ErrorMessage_Severity.CRITICAL:
          DeviceService.playSound(type: UISoundType.Critical);
          return Snack("Failed", error.message, Icon(Icons.sms_failed_outlined), Colors.orange, 2600, false);

        // Red - Title Error
        case ErrorMessage_Severity.FATAL:
          DeviceService.playSound(type: UISoundType.Fatal);
          return Snack("Error", error.message, SonrIcons.Caution.white, Colors.red, 2600, false);

        // Yellow - Title Warning
        default:
          DeviceService.playSound(type: UISoundType.Warning);
          return Snack("Warning", error.message, SonrIcons.Warning.white, Colors.yellow, 2600, false);
      }
    }
    // @ App Error
    else {
      DeviceService.playSound(type: UISoundType.Warning);
      return Snack("Error", message, SonrIcons.Caution.white, Colors.red, 2600, false);
    }
  }

  /// @ Invalid Operation
  factory Snack.invalid(String message) {
    return Snack("Uh Oh!", message, SonrIcons.Warning.white, Colors.orange[900], 2600, false);
  }

  /// @ Missing Data
  factory Snack.missing(String message, {bool isLast = false}) {
    // Get Missing Title
    final list = ['Wait!', 'Hold Up!', "Uh Oh!"];
    return Snack(isLast ? "Almost There!" : list.random(), message, SonrIcons.Warning.white, SonrColor.Critical, 2600, false);
  }

  /// @ Succesful Operation
  factory Snack.success(String message) {
    return Snack("Success!!", message, SonrIcons.Success.white, Colors.green, 2600, true);
  }
}
