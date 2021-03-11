import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart' hide Position, Platform;
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

  // Getters for Global References
  static Rx<Brightness> get brightness => Get.find<DeviceService>()._brightness;
  static Rx<CompassEvent> get direction => Get.find<DeviceService>()._direction;
  static RxBool get isDarkMode => Get.find<DeviceService>()._isDarkMode;
  static RxBool get hasPointToShare => Get.find<DeviceService>()._hasPointToShare;

  // Camera Permissions
  bool get cameraPermitted => _box.read("cameraPermitted") ?? false;
  _cameraPermittedToBox(bool val) {
    _box.write("cameraPermitted", val);
    _box.save();
  }

  // Gallery Permissions
  bool get galleryPermitted => _box.read("galleryPermitted") ?? false;
  _galleryPermittedToBox(bool val) {
    _box.write("galleryPermitted", val);
    _box.save();
  }

// Location Permissions
  bool get locationPermitted => _box.read("locationPermitted") ?? false;
  _locationPermittedToBox(bool val) {
    _box.write("locationPermitted", val);
    _box.save();
  }

  // Microphone Permissions
  bool get microphonePermitted => _box.read("microphonePermitted") ?? false;
  _microphonePermittedToBox(bool val) {
    _box.write("microphonePermitted", val);
    _box.save();
  }

  // Network Triggered
  bool get networkTriggered => _box.read("networkTriggered") ?? false;
  _networkTriggeredToBox(bool val) {
    _box.write("networkTriggered", val);
    _box.save();
  }

  // Network Triggered
  bool get notificationPermitted => _box.read("notificationPermitted") ?? false;
  _notificationPermittedToBox(bool val) {
    _box.write("notificationPermitted", val);
    _box.save();
  }

  // References
  final _box = GetStorage();

  // ^ Open SharedPreferences on Init ^ //
  Future<DeviceService> init() async {
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
      if (Get.find<DeviceService>().locationPermitted) {
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
  Future<Position> currentLocation() async {
    if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } else {
      print("No Location Permissions");
      return null;
    }
  }

  // ************************* //
  // ** Permission Requests ** //
  // ************************* //
  // ^ Request Camera optional overlay ^ //
  Future<bool> requestCamera() async {
    // Present Overlay
    if (await SonrOverlay.question(
        title: 'Requires Permission',
        description: 'Sonr Needs to Access your Camera in Order to send Pictures through the app.',
        acceptTitle: "Allow",
        declineTitle: "Decline")) {
      if (await Permission.camera.request().isGranted) {
        _cameraPermittedToBox(true);
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  // ^ Request Gallery optional overlay ^ //
  Future<bool> requestGallery({String description = 'Sonr needs your Permission to access your phones Gallery.'}) async {
    // Present Overlay
    if (await SonrOverlay.question(title: 'Photos', description: description, acceptTitle: "Allow", declineTitle: "Decline")) {
      if (Platform.isAndroid) {
        if (await Permission.storage.request().isGranted && await Permission.photos.request().isGranted) {
          _galleryPermittedToBox(true);
          return true;
        } else {
          return false;
        }
      } else {
        if (await Permission.photos.request().isGranted) {
          _galleryPermittedToBox(true);
          return true;
        } else {
          return false;
        }
      }
    } else {
      return false;
    }
  }

  // ^ Request Location optional overlay ^ //
  Future<bool> requestLocation() async {
    // Present Overlay
    if (await SonrOverlay.question(
        title: 'Location',
        description: 'Sonr requires location in order to find devices in your area.',
        acceptTitle: "Allow",
        declineTitle: "Decline")) {
      if (await Permission.locationWhenInUse.request().isGranted) {
        _locationPermittedToBox(true);
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  // ^ Request Microphone optional overlay ^ //
  Future<bool> requestMicrophone() async {
    // Present Overlay
    if (await SonrOverlay.question(
        title: 'Microphone',
        description: 'Sonr uses your microphone in order to communicate with other devices.',
        acceptTitle: "Allow",
        declineTitle: "Decline")) {
      if (await Permission.microphone.request().isGranted) {
        _microphonePermittedToBox(true);
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  // ^ Request Notifications optional overlay ^ //
  Future<bool> requestNotifications() async {
    // Present Overlay
    if (await SonrOverlay.question(
        title: 'Requires Permission',
        description: 'Sonr would like to send you Notifications for Transfer Invites.',
        acceptTitle: "Allow",
        declineTitle: "Decline")) {
      if (await Permission.notification.request().isGranted) {
        _notificationPermittedToBox(true);
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  // ^ Trigger iOS Local Network with Alert ^ //
  Future triggerNetwork() async {
    if (!networkTriggered && Platform.isIOS) {
      await SonrOverlay.alert(
          title: 'Requires Permission',
          description: 'Sonr requires local network permissions in order to maximize transfer speed.',
          buttonText: "Continue",
          barrierDismissible: false);

      await SonrCore.requestLocalNetwork();
      _networkTriggeredToBox(true);
    }
    return true;
  }

  // ^ BoxStorage Theme Mode Helper ^ //
  bool _loadThemeFromBox() => _box.read("isDarkMode") ?? false;
  _saveThemeToBox(bool isDarkMode) {
    _box.write("isDarkMode", isDarkMode);
    _box.save();
  }

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

  // ^ BoxStorage Point to Share Mode Helper ^ //
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
