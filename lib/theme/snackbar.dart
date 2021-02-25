import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snack.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/data/data.dart';

class SonrSnack {
  // Properties
  final Color color;
  final String title;
  final String message;
  final Widget icon;
  final int time;

  // ^ Default Constructer ^ //
  SonrSnack(this.title, this.message, this.icon, this.color, this.time) {
    if (!Get.isSnackbarOpen) {
      Get.snackbar(title, message,
          snackStyle: SnackStyle.FLOATING,
          duration: Duration(milliseconds: time),
          snackPosition: SnackPosition.BOTTOM,
          forwardAnimationCurve: Curves.easeInCirc,
          reverseAnimationCurve: Curves.elasticInOut,
          backgroundColor: color,
          icon: icon,
          colorText: Colors.white);
    }
  }

  // ^ Succesful Operation ^ //
  factory SonrSnack.success(String message) {
    return SonrSnack("Success!!", message, SonrIcon.success, Colors.green, 2600);
  }

  // ^ Missing Data ^ //
  factory SonrSnack.missing(String message, {bool isLast = false}) {
    // Get Missing Title
    final list = ['Wait!', 'Hold Up!', "Uh Oh!"];
    return SonrSnack(isLast ? "Almost There!" : list.random(), message, SonrIcon.missing, Colors.redAccent, 2600);
  }

  // ^ Invalid Operation ^ //
  factory SonrSnack.invalid(String message) {
    return SonrSnack("Uh Oh!", message, SonrIcon.missing, Colors.orange, 2600);
  }

  // ^ Cancelled Operation ^ //
  factory SonrSnack.cancelled(String message) {
    return SonrSnack("Cancelled.", message, SonrIcon.cancel, Colors.yellow, 2600);
  }

  // ^ Error on Operation ^ //
  factory SonrSnack.error(String message) {
    return SonrSnack("Error.", message, SonrIcon.error, Colors.red, 2600);
  }
}
