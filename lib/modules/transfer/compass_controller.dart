import 'package:get/get.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonar_app/theme/theme.dart';

class CompassController extends GetxController {
  final direction = 0.0.obs;
  final gradient = FlutterGradientNames.angelCare.obs;

  CompassController() {
    Get.find<SonrService>().direction.listen((dir) {
      direction(dir);
    });
  }
}
