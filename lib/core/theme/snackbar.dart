import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snack.dart';
import 'theme.dart';
import 'package:sonr_app/core/core.dart';

class SonrSnack {
  // Properties
  final Color color;
  final String title;
  final String message;
  final Widget icon;
  final int duration;

  // ^ Default Constructer ^ //
  SonrSnack(this.title, this.message, this.icon, this.color, this.duration) {
    if (!Get.isSnackbarOpen) {
      Get.snackbar(title, message,
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
  factory SonrSnack.alert({@required String title, @required String message, @required Icon icon, Color color = Colors.orange}) {
    return SonrSnack(title, message, icon, color, 2600);
  }

  // ^ Cancelled Operation ^ //
  factory SonrSnack.cancelled(String message) {
    return SonrSnack("Cancelled.", message, SonrIcon.cancel, Colors.yellow, 2600);
  }

  // ^ Error on Operation ^ //
  factory SonrSnack.error(String message) {
    return SonrSnack("Error.", message, SonrIcon.error, Colors.red, 2600);
  }

  // ^ Invalid Operation ^ //
  factory SonrSnack.invalid(String message) {
    return SonrSnack("Uh Oh!", message, SonrIcon.missing, Colors.orange[900], 2600);
  }

  // ^ Missing Data ^ //
  factory SonrSnack.missing(String message, {bool isLast = false}) {
    // Get Missing Title
    final list = ['Wait!', 'Hold Up!', "Uh Oh!"];
    return SonrSnack(isLast ? "Almost There!" : list.random(), message, SonrIcon.missing, Colors.redAccent, 2600);
  }

  // ^ Succesful Operation ^ //
  factory SonrSnack.success(String message) {
    return SonrSnack("Success!!", message, SonrIcon.success, Colors.green, 2600);
  }
}
