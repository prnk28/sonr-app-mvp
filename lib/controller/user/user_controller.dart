import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonar_app/database/database.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonar_app/model/model.dart';
import 'package:sonr_core/sonr_core.dart';
import '../controller.dart';

class UserController extends GetxController {
  UserStatus status = UserStatus.Initial;
  // ^ StartApp Event ^
  void getUser() async {
    // Set Sonr Controller
    // @ 1. Check for Location
    if (await Permission.locationWhenInUse.request().isGranted) {
      ConnController sonrConn = Get.find();
      // @ 2. Check for Profile
      User user = await User.get();
      if (user != null) {
        // Get Current Position
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        // Initialize Sonr Node
        sonrConn.connect(position, user.contact);
        status = UserStatus.Active;
        update(["Listener"]);
      } else {
        status = UserStatus.Inactive;
        update(["Listener"]);
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
      ConnController sonrConn = Get.find();
      // Get Data
      var user = await User.create(contact);
      // Get Current Position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Initialize Sonr Node
      sonrConn.connect(position, user.contact);
      status = UserStatus.Active;
      update(["Listener"]);
    } else {
      throw RequiredPermissionsError("Location Permission Denied");
    }
  }
}
