import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonar_app/data/data.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonr_core/sonr_core.dart';

class DeviceService extends GetxService {
  SharedPreferences _prefs;
  bool _hasLocation;
  bool _hasUser;
  final direction = 0.0.obs;

  // ^ Open SharedPreferences on Init ^ //
  init() async {
    // Init Shared Preferences
    _prefs = await SharedPreferences.getInstance();

    // Check Location Status
    _hasLocation = await Permission.locationWhenInUse.serviceStatus ==
        ServiceStatus.enabled;

    // Check User Status
    _hasUser = _prefs.containsKey("user");
  }

  // ^ Method to Connect User Event ^
  void connectUser() async {
    // @ 1. Check for Location
    if (_hasLocation) {
      // @ 2. Get Profile
      if (_hasUser) {
        // Get Json Value
        var profileJson = _prefs.getString("user");

        // Get Profile object
        var user = User.fromJson(profileJson);

        if (user != null) {
          // Get Current Position
          Position position = await user.position;

          // Initialize Sonr Node
          await Get.putAsync(() => SonrService().init(position, user));

          // Push to Home Screen
          Get.offNamed("/home");
        }
      } else {
        // Push to Register Screen
        Get.offNamed("/register");
      }
    } else {
      // Request Location again
      _hasLocation = await Permission.locationWhenInUse.request().isGranted;
      connectUser();
    }
  }

  // ^ CreateUser Event ^
  void createUser(Contact contact, String username) async {
    // Set Sonr Controller
    // @ 1. Check for Location
    if (await Permission.locationWhenInUse.request().isGranted) {
      // Get Data
      var user = new User(contact, username);

      // Save in SharedPreferences Instance
      _prefs.setString("user", user.toJson());

      // Get Current Position
      Position position = await user.position;

      // Initialize Sonr Node
      await Get.putAsync(() => SonrService().init(position, user));

      // Push to Home Screen
      Get.offNamed("/home");
    } else {
      throw RequiredPermissionsError("Location Permission Denied");
    }
  }

  // ^ RequestPermission Event ^ //
  // ignore: missing_return
  Future<bool> requestPermission(PermissionType type) async {
    switch (type) {
      case PermissionType.Location:
        return await Permission.locationWhenInUse.request().isGranted;
        break;

      case PermissionType.Camera:
        return await Permission.camera.request().isGranted;
        break;

      case PermissionType.Photos:
        return await Permission.mediaLibrary.request().isGranted;
        break;

      case PermissionType.Notifications:
        return await Permission.notification.request().isGranted;
        break;
      default:
        break;
    }
  }
}
