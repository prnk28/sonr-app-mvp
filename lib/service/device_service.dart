import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonar_app/data/permission_model.dart';
import 'package:sonar_app/data/user_model.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:gallery_saver/gallery_saver.dart';
import '../social/social_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DeviceService extends GetxService {
  // Properties
  final contact = Rx<Contact>();

  // References
  SharedPreferences _prefs;
  bool hasLocation;
  bool hasUser;
  Position position;
  User user;

  DeviceService() {
    // Save Contact Changes
    contact.listen((updatedContact) {
      if (hasUser) {
        // Update Contact
        user.contact = updatedContact;
        _prefs.setString("user", user.toJson());
      }
    });
  }

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
        contact(user.contact);

        if (user != null) {
          // Get Current Position
          position = await user.position;

          // Initialize Dependent Services
          await Get.putAsync(() => SocialMediaProvider().init());
          await Get.putAsync(
              () => SonrService().init(position, user.contact, user.username));
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
      user = User(contact, username);
      _prefs.setString("user", user.toJson());
      hasUser = true;

      // Get Current Position
      position = await user.position;

      // Initialize Dependent Services
      await Get.putAsync(() => SocialMediaProvider().init());
      await Get.putAsync(
          () => SonrService().init(position, user.contact, user.username));
    } else {
      throw RequiredPermissionsError("Location Permission Denied");
    }
  }

  // ^ Retreive API Keys ^ //
  Future<dynamic> getKeys() async {
    final data = await rootBundle.loadString('assets/keys.json');
    return jsonDecode(data);
  }

  // ^ Get a Social Auth ^ //
  List<String> getAuth(Contact_SocialTile_Provider provider) {
    var result = _prefs.getStringList(provider.toString());
    return result;
  }

  // ^ Save a Social Auth ^ //
  Future<bool> saveAuth(
      Contact_SocialTile_Provider provider, List<String> auth) async {
    var result = await _prefs.setStringList(provider.toString(), auth);
    return result;
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
    // Invalid Media
    else {
      print("Not Valid Media Type");
      return false;
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

  // ^ Launch a URL Event ^ //
  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
