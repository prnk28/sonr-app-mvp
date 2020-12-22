import 'dart:math';

import 'package:get/get.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonar_app/theme/theme.dart';

// ** Compass Designation Enum **
enum CompassHeading {
  N,
  NNE,
  NE,
  ENE,
  E,
  ESE,
  SE,
  SSE,
  S,
  SSW,
  SW,
  WSW,
  W,
  WNW,
  NW,
  NNW
}

class CompassController extends GetxController {
  // @ Properties
  //final Rx<Direction> direction = Direction(0).obs;
  final Rx<Gradient> gradient = FlutterGradients.findByName(
          FlutterGradientNames.octoberSilence,
          type: GradientType.linear)
      .obs;

  // @ References
  final Rx<SonrStatus> _status = Get.find<SonrService>().status;
  final inactiveGradient = FlutterGradients.findByName(
      FlutterGradientNames.octoberSilence,
      type: GradientType.linear);

  final activeGradient = FlutterGradients.findByName(
      FlutterGradientNames.summerGames,
      type: GradientType.linear);

  final pendingGradient = FlutterGradients.findByName(
      FlutterGradientNames.angelCare,
      type: GradientType.linear);

  final busyGradient = FlutterGradients.findByName(
      FlutterGradientNames.nightParty,
      type: GradientType.linear);

  // @ Direction Properties
  final direction = 0.0.obs;
  final angle = 0.0.obs;
  final degrees = 0.0.obs;

  // @ Direction Methods
  final string = "".obs;
  final heading = "".obs;

  // ^ Controller Constructer ^
  CompassController() {
    // @ Update Direction
    Get.find<SonrService>().direction.listen((newDir) {
      // Reference
      direction(newDir);
      angle(((newDir ?? 0) * (pi / 180) * -1));

      // Calculate Degrees
      if (newDir + 90 > 360) {
        degrees(newDir - 270);
      } else {
        degrees(newDir + 90);
      }

      // Update String Elements
      if ((direction.value - newDir).abs() > 6) {
        string(_directionString());
        heading(_headingString());
      }
    });

    // @ Check Peers Length
    Get.find<SonrService>().lobby.listen((lob) {
      if (lob.length > 0) {
        if (_status.value == SonrStatus.Pending) {
          gradient(pendingGradient);
        } else if (_status.value == SonrStatus.Busy) {
          gradient(busyGradient);
        } else {
          gradient(activeGradient);
        }
      } else {
        gradient(inactiveGradient);
      }
    });
  }

  // ^ Retreives Direction String ^ //
  _directionString() {
    // Calculated
    var adjustedDegrees = direction.round();
    final unit = "°";

    // @ Convert To String
    if (adjustedDegrees >= 0 && adjustedDegrees <= 9) {
      return "0" + "0" + adjustedDegrees.toString() + unit;
    } else if (adjustedDegrees > 9 && adjustedDegrees <= 99) {
      return "0" + adjustedDegrees.toString() + unit;
    } else {
      return adjustedDegrees.toString() + unit;
    }
  }

  // ^ Retreives Heading String ^ //
  _headingString() {
    var adjustedDesignation = ((direction / 22.5) + 0.5).toInt();
    var compassEnum = CompassHeading.values[(adjustedDesignation % 16)];
    return compassEnum
        .toString()
        .substring(compassEnum.toString().indexOf('.') + 1);
  }
}
