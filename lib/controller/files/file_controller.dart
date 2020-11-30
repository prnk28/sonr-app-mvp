import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonar_app/database/database.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonar_app/ui/ui.dart';
import 'package:sonr_core/sonr_core.dart';
import '../controller.dart';

class FileController extends GetxController {
  final direction = 0.0.obs;
  final status = Rx<DeviceStatus>();
  SonrController sonr = Get.find();

  // ^ DeviceController handles profile, permissions, and Compass ^
  FileController() {
    FlutterCompass.events.listen((newDegrees) {
      // @ Check if Correct State
      if (sonr.status == SonrStatus.Available ||
          sonr.status == SonrStatus.Searching) {
        // Get Current Direction and Update Cubit
        direction(newDegrees.headingForCameraMode);

        // Update Node Direction
        sonr.updateDirection(newDegrees.headingForCameraMode);
      }
    });
  }

  // ^ StartApp Event ^
  void start() async {
    // Set Sonr Controller
    // @ 1. Check for Location
    if (await Permission.locationWhenInUse.request().isGranted) {
      // @ 2. Check for Profile
      User user = await User.get();
      if (user != null) {
        // Get Current Position
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        // Initialize Sonr Node
        sonr.connect(position, user.contact);
        status(DeviceStatus.Active);
      } else {
        throw ProfileError(" Profile wasnt found");
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
      // Get Data
      var user = await User.create(contact);
      // Get Current Position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Initialize Sonr Node
      sonr.connect(position, user.contact);
      status(DeviceStatus.Active);
    } else {
      throw RequiredPermissionsError("Location Permission Denied");
    }
  }

  // ^ RequestPermission Event ^ //
  void requestPermission(PermissionType type) async {
    switch (type) {
      case PermissionType.Location:
        if (await Permission.locationWhenInUse.request().isGranted) {
          status(DeviceStatus.LocationGranted);
        } else {
          throw PermissionFailure(type.toString());
        }
        break;

      case PermissionType.Camera:
        if (await Permission.camera.request().isGranted) {
          status(DeviceStatus.CameraGranted);
        } else {
          throw PermissionFailure(type.toString());
        }
        break;

      case PermissionType.Photos:
        if (await Permission.mediaLibrary.request().isGranted) {
          status(DeviceStatus.PhotosGranted);
        } else {
          throw PermissionFailure(type.toString());
        }
        break;

      case PermissionType.Notifications:
        if (await Permission.notification.request().isGranted) {
          status(DeviceStatus.NotificationsGranted);
        } else {
          throw PermissionFailure(type.toString());
        }
        break;
    }
  }
}
