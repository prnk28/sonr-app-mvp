import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonar_app/data/permission_model.dart';
import 'package:sonar_app/data/settings_model.dart';
import 'package:sonar_app/data/user_model.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonr_core/sonr_core.dart';

class DeviceService extends GetxService {
  SharedPreferences _prefs;
  bool hasLocation;
  bool hasUser;

  Position position;
  User user;
  Settings settings;

  // ^ Open SharedPreferences on Init ^ //
  Future<DeviceService> init() async {
    // Init Shared Preferences
    _prefs = await SharedPreferences.getInstance();

    // Check Location Status
    hasLocation = await Permission.locationWhenInUse.serviceStatus ==
        ServiceStatus.enabled;

    // Check User Status
    hasUser = _prefs.containsKey("user");
    return this;
  }

  // ^ Method to Connect User Event ^
  void start() async {
    // @ 1. Check for Location
    if (hasLocation = await Permission.locationWhenInUse.request().isGranted) {
      // @ 2. Get Profile
      if (hasUser) {
        // Get Json Value
        var profileJson = _prefs.getString("user");

        // Get Profile object
        user = User.fromJson(profileJson);

        if (user != null) {
          // Get Current Position
          position = await user.position;

          // Initialize Sonr Node
          await Get.putAsync(() => SonrService().init(position, user));
        }
      } else {
        // Push to Register Screen
        Get.offNamed("/register");
      }
    } else {
      throw RequiredPermissionsError("Location Permission Denied");
    }
  }

  // ^ CreateUser Event ^
  void createUser(Contact contact, String username) async {
    // Set Sonr Controller
    // @ 1. Check for Location
    if (await Permission.locationWhenInUse.request().isGranted) {
      // Get Data and Save in SharedPrefs
      user = new User(contact, username);
      _prefs.setString("user", user.toJson());

      // Get Current Position
      position = await user.position;

      // Initialize Sonr Node
      Get.putAsync(() => SonrService().init(position, user));
    } else {
      throw RequiredPermissionsError("Location Permission Denied");
    }
  }

  // ^ UpdateContact Event ^
  void updateContact(Contact newContact) async {
    // @ Validate
    if (hasUser) {
      // Update Contact
      user = new User(newContact, user.username);
      _prefs.setString("user", user.toJson());
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
