import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonar_app/data/permission_model.dart';
import 'package:sonar_app/data/user_model.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'social_service.dart';

class DeviceService extends GetxService {
  SharedPreferences _prefs;
  bool hasLocation;
  bool hasUser;

  Position position;
  User user;

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

          // Initialize Dependent Services
          await Get.putAsync(() => SocialMediaService().init(user));
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

      // Initialize Dependent Services
      await Get.putAsync(() => SocialMediaService().init(user));
      await Get.putAsync(() => SonrService().init(position, user));
    } else {
      throw RequiredPermissionsError("Location Permission Denied");
    }
  }

  // ^ Saves Media to Gallery ^ //
  Future<bool> saveMedia(Metadata media) async {
    // Get Data from Media
    final imgAlbum = "Sonr Images";
    final vidAlbum = "Sonr Videos";
    final path = media.path;

    // Save Image to Gallery
    if (media.mime.type == MIME_Type.image) {
      bool result = await GallerySaver.saveImage(path, albumName: imgAlbum);
      return result;
    }
    // Save Video to Gallery
    else if (media.mime.type == MIME_Type.video) {
      bool result = await GallerySaver.saveVideo(path, albumName: vidAlbum);
      return result;
    }
    print("Not Valid Media Type");
    return false;
  }

  // ^ UpdateContact Event ^
  void updateContact(Contact newContact) async {
    // @ Validate
    if (hasUser && !user.isNullOrBlank) {
      // Update Contact
      user.contact = newContact;
      _prefs.setString("user", user.toJson());
    }
  }

  // ^ UpdateContact Event ^
  void updateSettings(SettingsItem item) async {
    // @ Validate
    if (hasUser && !user.isNullOrBlank) {
      // Update Item
      if (user.settings.contains(item)) {
        int idx = user.settings.indexOf(item);
        user.settings[idx] = item;
      } else {
        user.settings.add(item);
      }
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
