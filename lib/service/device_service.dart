import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonr_app/theme/theme.dart' hide Position;
import 'package:url_launcher/url_launcher.dart';

// @ Enum defines Type of Permission
enum PermissionType { Camera, Gallery, Location, Notifications, Sound }
enum LaunchPage { Home, Register, PermissionNetwork, PermissionLocation }

class DeviceService extends GetxService {
  // Status/Sensor Properties
  final _brightness = Rx<Brightness>();
  final _direction = Rx<CompassEvent>();
  final _isDarkMode = true.obs;
  final _hasPointToShare = false.obs;
  final _position = Rx<Position>();

  // Getters for Global References
  static Rx<Brightness> get brightness => Get.find<DeviceService>()._brightness;
  static Rx<CompassEvent> get direction => Get.find<DeviceService>()._direction;
  static RxBool get isDarkMode => Get.find<DeviceService>()._isDarkMode;
  static RxBool get hasPointToShare => Get.find<DeviceService>()._hasPointToShare;

  // Permission Properties
  final cameraPermitted = false.obs;
  final galleryPermitted = false.obs;
  final locationPermitted = false.obs;
  final microphonePermitted = false.obs;
  final networkTriggered = false.obs;
  final notificationPermitted = false.obs;

  // References
  final _box = GetStorage();
  SharedPreferences _prefs;

  // ^ Open SharedPreferences on Init ^ //
  Future<DeviceService> init() async {
    // Get Preferences and Set Status
    _prefs = await SharedPreferences.getInstance();
    await setPermissionStatus();
    await refreshLocation();

    // Bind Direction Stream
    _direction.bindStream(FlutterCompass.events);

    // Set Preferences
    _isDarkMode(_box.read("isDarkMode") ?? false);
    _hasPointToShare(_box.read("hasPointToShare") ?? false);
    _brightness(_isDarkMode.value ? Brightness.dark : Brightness.light);

    // Update Android and iOS Status Bar
    _isDarkMode.value
        ? SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light))
        : SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark));
    return this;
  }

  // ^ Method Determins LaunchPage ^
  static LaunchPage getLaunchPage() {
    if (!UserService.exists.value) {
      return LaunchPage.Register;
    } else {
      if (Get.find<DeviceService>().locationPermitted.value) {
        return LaunchPage.Home;
      } else {
        return LaunchPage.PermissionLocation;
      }
    }
  }

  // ^ Launch a URL Event ^ //
  Future launchURL(String url) async {
    if (await canLaunch(url)) {
      SonrOverlay.back();
      await launch(url);
    } else {
      SonrSnack.error("Could not launch the URL.");
    }
  }

  // ^ Refresh User Location Position ^ //
  Future<Position> refreshLocation() async {
    if (locationPermitted.value) {
      _position(await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high));
      return _position.value;
    }
    return null;
  }

  // ^ Sets Permission Status from Service ^ //
  Future setPermissionStatus() async {
    networkTriggered(_prefs.containsKey("network-triggered"));
    cameraPermitted(await Permission.camera.isGranted);
    galleryPermitted(await Permission.mediaLibrary.isGranted);
    locationPermitted(await Permission.locationWhenInUse.isGranted);
    microphonePermitted(await Permission.microphone.isGranted);
    notificationPermitted(await Permission.notification.isGranted);
  }

  // ************************* //
  // ** Permission Requests ** //
  // ************************* //
  // ^ Request Camera optional overlay ^ //
  static Future<bool> requestCamera() async {
    // Check If Exists
    if (Get.find<DeviceService>().cameraPermitted.value) {
      return true;
    }

    // Present Overlay
    var decision = await SonrOverlay.question(
        title: 'Requires Permission',
        description: 'Sonr Needs to Access your Camera in Order to send Pictures through the app.',
        acceptTitle: "Allow",
        declineTitle: "Decline");

    // Check Overlay Decision
    if (decision) {
      var result = await Permission.camera.request();
      Get.find<DeviceService>().cameraPermitted(result == PermissionStatus.granted);
      return result == PermissionStatus.granted;
    } else {
      return false;
    }
  }

  // ^ Request Gallery optional overlay ^ //
  static Future<bool> requestGallery() async {
    // Check If Exists
    if (Get.find<DeviceService>().galleryPermitted.value) {
      return true;
    }

    // Present Overlay
    var decision = await SonrOverlay.question(
        title: 'Requires Permission',
        description: 'Sonr needs your Permission to access your phones Gallery.',
        acceptTitle: "Allow",
        declineTitle: "Decline");

    // Check Overlay Decision
    if (decision) {
      var result = await Permission.mediaLibrary.request();
      Get.find<DeviceService>().galleryPermitted(result == PermissionStatus.granted);
      MediaService.refreshGallery();
      return result == PermissionStatus.granted;
    } else {
      return false;
    }
  }

  // ^ Request Location optional overlay ^ //
  static Future<bool> requestLocation() async {
    // Check If Exists
    if (Get.find<DeviceService>().locationPermitted.value) {
      return true;
    }

    // Present Overlay
    var decision = await SonrOverlay.question(
        title: 'Requires Permission',
        description: 'Sonr requires location in order to find devices in your area.',
        acceptTitle: "Allow",
        declineTitle: "Decline");

    // Check Overlay Decision
    if (decision) {
      // Request
      var result = await Permission.locationWhenInUse.request();
      Get.find<DeviceService>().locationPermitted(result == PermissionStatus.granted);
      await Get.find<DeviceService>().refreshLocation();
      return result == PermissionStatus.granted;
    } else {
      return false;
    }
  }

  // ^ Request Microphone optional overlay ^ //
  static Future<bool> requestMicrophone() async {
    // Check If Exists
    if (Get.find<DeviceService>().microphonePermitted.value) {
      return true;
    }

    // Present Overlay
    var decision = await SonrOverlay.question(
        title: 'Requires Permission',
        description: 'Sonr uses your microphone in order to communicate with other devices.',
        acceptTitle: "Allow",
        declineTitle: "Decline");

    // Check Overlay Decision
    if (decision) {
      var result = await Permission.microphone.request();
      Get.find<DeviceService>().microphonePermitted(result == PermissionStatus.granted);
      return result == PermissionStatus.granted;
    } else {
      return false;
    }
  }

  // ^ Request Notifications optional overlay ^ //
  static Future<bool> requestNotifications() async {
    // Check If Exists
    if (Get.find<DeviceService>().notificationPermitted.value) {
      return true;
    }

    // Present Overlay
    var decision = await SonrOverlay.question(
        title: 'Requires Permission',
        description: 'Sonr would like to send you Notifications for Transfer Invites.',
        acceptTitle: "Allow",
        declineTitle: "Decline");

    // Check Overlay Decision
    if (decision) {
      var result = await Permission.notification.request();
      Get.find<DeviceService>().notificationPermitted(result == PermissionStatus.granted);
      return result == PermissionStatus.granted;
    } else {
      return false;
    }
  }

  // ^ Trigger iOS Local Network with Alert ^ //
  static Future triggerNetwork() async {
    await SonrOverlay.alert(
        title: 'Requires Permission',
        description: 'Sonr uses your microphone in order to communicate with other devices.',
        buttonText: "Continue",
        barrierDismissible: false);

    await SonrCore.requestLocalNetwork();
    Get.find<DeviceService>()._prefs.setBool("network-triggered", true);
    Get.find<DeviceService>().networkTriggered(true);
    return true;
  }

  // ^ BoxStorage Theme Mode Helper ^ //
  bool _loadThemeFromBox() => _box.read("isDarkMode") ?? false;
  _saveThemeToBox(bool isDarkMode) => _box.write("isDarkMode", isDarkMode);

  // ^ Trigger iOS Local Network with Alert ^ //
  static toggleDarkMode() async {
    // Update Value
    Get.find<DeviceService>()._isDarkMode(!Get.find<DeviceService>()._isDarkMode.value);
    Get.find<DeviceService>()._isDarkMode.refresh();

    // Update Android and iOS Status Bar
    Get.find<DeviceService>()._isDarkMode.value
        ? SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light))
        : SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark));

    // Update Theme
    Get.changeThemeMode(Get.find<DeviceService>()._loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);

    // Save Preference
    Get.find<DeviceService>()._saveThemeToBox(!Get.find<DeviceService>()._loadThemeFromBox());
    return true;
  }

  // ^ BoxStorage Theme Mode Helper ^ //
  bool _loadPointToShareFromBox() => _box.read("hasPointToShare") ?? false;
  _savePointToShareToBox(bool hasPointToShare) => _box.write("hasPointToShare", hasPointToShare);

  // ^ Trigger iOS Local Network with Alert ^ //
  static togglePointToShare() async {
    // Update Value
    Get.find<DeviceService>()._hasPointToShare(!Get.find<DeviceService>()._hasPointToShare.value);
    Get.find<DeviceService>()._hasPointToShare.refresh();

    // Save Preference
    Get.find<DeviceService>()._savePointToShareToBox(!Get.find<DeviceService>()._loadPointToShareFromBox());
    return true;
  }
}
