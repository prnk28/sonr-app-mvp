import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonar_app/database/database.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonar_app/model/model.dart';
import 'package:sonr_core/sonr_core.dart';
import '../controller.dart';

class DeviceController extends GetxController {
  final direction = 0.0.obs;
  DeviceStatus status = DeviceStatus.Initial;

  // ^ DeviceController handles profile, permissions, and Compass ^
  // ^ StartApp Event ^
  void start() async {
    // Set Sonr Controller
    // @ 1. Check for Location
    if (await Permission.locationWhenInUse.request().isGranted) {
      SonrController sonr = Get.find();
      // @ 2. Check for Profile
      User user = await User.get();
      if (user != null) {
        // Get Current Position
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        // Initialize Sonr Node
        sonr.connect(position, user.contact);
        status = DeviceStatus.Active;
        update(["Active"]);
      } else {
        status = DeviceStatus.NoProfile;
        update(["NoProfile"]);
      }
    } else {
      throw RequiredPermissionsError("Location Permission Denied");
    }
  }

  // ^ CreateUser Event ^
  void createUser(Contact contact) async {
    // Set Sonr Controller
    // @ 1. Check for Location
    if (await Permission.locationWhenInUse.request().isGranted) {
      SonrController sonr = Get.find();
      // Get Data
      var user = await User.create(contact);
      // Get Current Position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Initialize Sonr Node
      sonr.connect(position, user.contact);
      status = DeviceStatus.Active;
      update(["Active"]);
    } else {
      throw RequiredPermissionsError("Location Permission Denied");
    }
  }

  // ^ RequestPermission Event ^ //
  void requestPermission(PermissionType type) async {
    switch (type) {
      case PermissionType.Location:
        if (await Permission.locationWhenInUse.request().isGranted) {
          status = DeviceStatus.LocationGranted;
          update(["LocationGranted"]);
        } else {
          throw PermissionFailure(type.toString());
        }
        break;

      case PermissionType.Camera:
        if (await Permission.camera.request().isGranted) {
          status = DeviceStatus.CameraGranted;
          update(["CameraGranted"]);
        } else {
          throw PermissionFailure(type.toString());
        }
        break;

      case PermissionType.Photos:
        if (await Permission.mediaLibrary.request().isGranted) {
          status = DeviceStatus.PhotosGranted;
          update(["PhotosGranted"]);
        } else {
          throw PermissionFailure(type.toString());
        }
        break;

      case PermissionType.Notifications:
        if (await Permission.notification.request().isGranted) {
          status = DeviceStatus.NotificationsGranted;
          update(["NotificationsGranted"]);
        } else {
          throw PermissionFailure(type.toString());
        }
        break;
    }
  }
}
