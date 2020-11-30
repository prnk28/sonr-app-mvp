import 'package:flutter_compass/flutter_compass.dart';
import 'package:get/get.dart' hide Node;

class DirectionController extends GetxController {
  final direction = 0.0.obs;
  DirectionController() {
    FlutterCompass.events.listen((newDegrees) {
      // Get Current Direction and Update Cubit
      direction(newDegrees.headingForCameraMode);
    });
  }
}
