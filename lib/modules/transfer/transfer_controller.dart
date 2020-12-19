import 'package:get/get.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonar_app/theme/theme.dart';

class CompassController extends GetxController {
  // Properties
  final gradient = FlutterGradientNames.angelCare.obs;
  final RxDouble direction = Get.find<SonrService>().direction;

  // Inferred Properties
}
