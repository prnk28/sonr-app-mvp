import 'dart:async';
import 'dart:math';
import 'package:sonr_app/service/service.dart';
import 'package:sonr_app/theme/theme.dart';

class TransferController extends GetxController {
  // @ Properties
  final Rx<Gradient> gradient = SonrColor.inactiveBulb.obs;
  final title = "Nobody Here".obs;

  // @ Direction Properties
  final angle = 0.0.obs;
  final degrees = 0.0.obs;
  final direction = 0.0.obs;

  // @ String Properties
  final string = "".obs;
  final heading = "".obs;

  // References
  StreamSubscription<CompassEvent> compassStream;
  StreamSubscription<int> lobbySizeStream;
  List<String> peerIDs = <String>[];

  // ^ Controller Constructer ^
  void onInit() {
    compassStream = DeviceService.direction.stream.listen(_handleCompassUpdate);
    lobbySizeStream = SonrService.lobbySize.listen(_handleLobbySizeUpdate);
    super.onInit();
  }

  // ^ On Dispose ^ //
  void onDispose() {
    compassStream.cancel();
    lobbySizeStream.cancel();
  }

  // ^ Handle Compass Update ^ //
  _handleCompassUpdate(CompassEvent newDir) {
    // Update String Elements
    string(_directionString(newDir.headingForCameraMode));
    heading(_headingString(newDir.headingForCameraMode));

    // Reference
    direction(newDir.headingForCameraMode);
    angle(((newDir.headingForCameraMode ?? 0) * (pi / 180) * -1));

    // Calculate Degrees
    if (newDir.headingForCameraMode + 90 > 360) {
      degrees(newDir.headingForCameraMode - 270);
    } else {
      degrees(newDir.headingForCameraMode + 90);
    }
  }

  // ^ Handle Lobby Size Update ^ //
  _handleLobbySizeUpdate(int size) {
    if (size == 0) {
      title("Nobody Here");
      gradient(SonrColor.inactiveBulb);
    } else if (size == 1) {
      title("1 Person");
      gradient(SonrColor.activeBulb);
    } else {
      title("$size People");
      gradient(SonrColor.activeBulb);
    }
  }

  // ^ Retreives Direction String ^ //
  _directionString(double dir) {
    // Calculated
    var adjustedDegrees = dir.round();
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
  _headingString(double dir) {
    var adjustedDesignation = ((dir / 22.5) + 0.5).toInt();
    var compassEnum = Position_Heading.values[(adjustedDesignation % 16)];
    return compassEnum.toString().substring(compassEnum.toString().indexOf('.') + 1);
  }
}
