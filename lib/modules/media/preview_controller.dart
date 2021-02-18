import 'package:get/get.dart';
import 'package:sonr_app/service/device_service.dart';
import 'package:sonr_app/service/sonr_service.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:sonr_core/models/models.dart';
import '../home/home_controller.dart';

class PreviewController extends GetxController {
  // Properties
  final hasCapture = false.obs;
  final capturePath = "".obs;

  // ^ Clear Current Photo ^ //
  clear() async {
    hasCapture(false);
    capturePath("");
  }

  // ^ Continue with Media Capture ^ //
  continueMedia() async {
    // Save Photo
    Get.find<DeviceService>().savePhotoFromCamera(capturePath.value);

    Get.find<SonrService>().setPayload(Payload.MEDIA, path: capturePath.value);

    // Close Share Button
    Get.find<HomeController>().toggleShareExpand();

    // Go to Transfer
    Get.offNamed("/transfer");
  }
}
