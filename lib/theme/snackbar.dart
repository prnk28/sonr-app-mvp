import 'dart:math';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snack.dart';
import 'package:sonr_app/theme/theme.dart';

class SonrSnack {
  // Properties
  final Color color;
  final String title;
  final String message;
  final Widget icon;
  final int time;

  // ^ Default Constructer ^ //
  SonrSnack(this.title, this.message, this.icon, this.color, this.time) {
    Get.snackbar(title, message,
        snackStyle: SnackStyle.FLOATING,
        duration: Duration(milliseconds: time),
        snackPosition: SnackPosition.BOTTOM,
        forwardAnimationCurve: Curves.bounceIn,
        reverseAnimationCurve: Curves.easeOut,
        backgroundColor: color,
        icon: icon,
        colorText: Colors.white);
  }

  // ^ Succesful Operation ^ //
  factory SonrSnack.success(String message) {
    return SonrSnack("Success!!", message, SonrIcon.success, Colors.green, 1250);
  }

  // ^ Missing Data ^ //
  factory SonrSnack.missing(String message, {bool isLast = false}) {
    // Get Missing Title
    final random = new Random();
    final list = ['Wait!', 'Hold Up!', "Uh Oh!"];

    return SonrSnack(isLast ? "Almost There!" : list[random.nextInt(list.length)], message, SonrIcon.missing, Colors.redAccent, 1500);
  }

  // ^ Invalid Operation ^ //
  factory SonrSnack.invalid(String message) {
    return SonrSnack("Uh Oh!", message, SonrIcon.missing, Colors.orange, 1250);
  }

  // ^ Cancelled Operation ^ //
  factory SonrSnack.cancelled(String message) {
    return SonrSnack("Cancelled.", message, SonrIcon.cancel, Colors.yellow, 1250);
  }

  // ^ Error on Operation ^ //
  factory SonrSnack.error(String message) {
    return SonrSnack("Error.", message, SonrIcon.error, Colors.red, 1500);
  }
}
