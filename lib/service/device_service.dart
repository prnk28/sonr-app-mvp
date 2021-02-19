import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonr_app/data/model_user.dart';
import 'package:sonr_app/service/sonr_service.dart' hide User, Position;
import 'package:url_launcher/url_launcher.dart';
import 'media_service.dart';

// @ Enum defines Type of Permission
enum PermissionType { Camera, Gallery, Location, Notifications, Sound }
enum StartStatus { Success, NoUser, NoLocation }

class DeviceService extends GetxService {
  // Properties
  final hasUser = false.obs;
  final hasLocation = false.obs;
  final contact = Rx<Contact>();
  final startStatus = Rx<StartStatus>();
  Future<Position> get location => Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  // References
  SharedPreferences _prefs;
  User user;

  DeviceService() {
    // @ Save Contact Changes
    contact.listen((updatedContact) {
      if (hasUser.value) {
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
    hasLocation(await Permission.locationWhenInUse.serviceStatus == ServiceStatus.enabled);

    // Check User Status
    hasUser(_prefs.containsKey("user"));
    start();
    return this;
  }

  // ^ Method to Connect User Event ^
  void start() async {
    // @ 1. Check for Location
    hasLocation(await Permission.locationWhenInUse.request().isGranted);
    if (hasLocation.value) {
      if (hasUser.value) {
        // Get Json Value
        var profileJson = _prefs.getString("user");

        // Get Profile object
        user = User.fromJson(profileJson);
        contact(user.contact);

        if (user != null) {
          // Get Current Location
          var location = await this.location;

          // Initialize Dependent Services
          Get.putAsync(() => SonrService().init(location, user));
          Get.putAsync(() => MediaService().init());
          startStatus(StartStatus.Success);
        } else {
          startStatus(StartStatus.NoUser);
        }
      } else {
        startStatus(StartStatus.NoUser);
      }
    } else {
      startStatus(StartStatus.NoLocation);
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
      hasUser(true);

// Get Current Location
      var location = await this.location;

      // Initialize Dependent Services
      Get.putAsync(() => SonrService().init(location, user));
      Get.putAsync(() => MediaService().init());
      Get.offNamed("/home");
    } else {
      print("Location Permission Denied");
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
