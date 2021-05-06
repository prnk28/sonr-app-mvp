import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snack.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_app/data/data.dart';

class SonrSnack {
  // Properties
  final Color? color;
  final String? title;
  final String message;
  final Widget icon;
  final int duration;
  final bool shouldIconPulse;

  // ^ Default Constructer ^ //
  SonrSnack(this.title, this.message, this.icon, this.color, this.duration, this.shouldIconPulse) {
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

  // ^ Custom Alert ^ //
  factory SonrSnack.remote({required String message, int duration = 45000, Color color = Colors.purple}) {
    return SonrSnack("Remote Code", message, SonrIcons.Remote.white, color, duration, true);
  }

  // ^ Custom Alert ^ //
  factory SonrSnack.alert({required String title, required String message, required Icon icon, Color color = Colors.orange}) {
    return SonrSnack(title, message, icon, color, 2600, false);
  }

  // ^ Cancelled Operation ^ //
  factory SonrSnack.cancelled(String message) {
    return SonrSnack("Cancelled.", message, SonrIcons.Stop.white, Colors.yellow, 2600, false);
  }

  // ^ Error on Operation ^ //
  factory SonrSnack.error(String message, {ErrorMessage? error}) {
    // @ Internal Error
    if (error != null) {
      switch (error.severity) {
        // Orange - Title Failed
        case ErrorMessage_Severity.CRITICAL:
          DeviceService.playSound(type: UISoundType.Critical);
          return SonrSnack("Failed", error.message, Icon(Icons.sms_failed_outlined), Colors.orange, 2600, false);

        // Red - Title Error
        case ErrorMessage_Severity.FATAL:
          DeviceService.playSound(type: UISoundType.Fatal);
          return SonrSnack("Error", error.message, SonrIcons.Caution.white, Colors.red, 2600, false);

        // Yellow - Title Warning
        default:
          DeviceService.playSound(type: UISoundType.Warning);
          return SonrSnack("Warning", error.message, SonrIcons.Warning.white, Colors.yellow, 2600, false);
      }
    }
    // @ App Error
    else {
      DeviceService.playSound(type: UISoundType.Warning);
      return SonrSnack("Error", message, SonrIcons.Caution.white, Colors.red, 2600, false);
    }
  }

  // ^ Invalid Operation ^ //
  factory SonrSnack.invalid(String message) {
    return SonrSnack("Uh Oh!", message, SonrIcons.Warning.white, Colors.orange[900], 2600, false);
  }

  // ^ Missing Data ^ //
  factory SonrSnack.missing(String message, {bool isLast = false}) {
    // Get Missing Title
    final list = ['Wait!', 'Hold Up!', "Uh Oh!"];
    return SonrSnack(isLast ? "Almost There!" : list.random(), message, SonrIcons.Warning.white, SonrColor.Critical, 2600, false);
  }

  // ^ Succesful Operation ^ //
  factory SonrSnack.success(String message) {
    return SonrSnack("Success!!", message, SonrIcons.Success.white, Colors.green, 2600, true);
  }
}
