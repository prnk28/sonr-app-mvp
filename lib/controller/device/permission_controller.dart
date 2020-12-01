import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonar_app/model/model.dart';

class PermissionController extends GetxController {
  PermissionType type;
  bool granted;

  // ^ RequestPermission Event ^ //
  void requestPermission(PermissionType type) async {
    type = type;

    switch (type) {
      case PermissionType.Location:
        granted = await Permission.locationWhenInUse.request().isGranted;
        update();
        break;

      case PermissionType.Camera:
        granted = await Permission.camera.request().isGranted;
        update();
        break;

      case PermissionType.Photos:
        granted = await Permission.mediaLibrary.request().isGranted;
        update();
        break;

      case PermissionType.Notifications:
        granted = await Permission.notification.request().isGranted;
        update();
        break;
    }
  }
}
