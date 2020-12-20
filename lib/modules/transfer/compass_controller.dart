import 'package:get/get.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonar_app/theme/theme.dart';

class CompassController extends GetxController {
  // Properties
  final gradients = [
    // First Gradient
    FlutterGradients.findByName(FlutterGradientNames.angelCare,
        type: GradientType.radial),

    // Second Gradient
    FlutterGradients.findByName(FlutterGradientNames.blessing,
        type: GradientType.radial)
  ].obs;
  final RxDouble direction = Get.find<SonrService>().direction;
}
