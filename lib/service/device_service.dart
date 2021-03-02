import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonr_app/core/core.dart' hide Position;
import 'package:url_launcher/url_launcher.dart';

// @ Enum defines Type of Permission
enum PermissionType { Camera, Gallery, Location, Notifications, Sound }
enum LaunchPage { Home, Register, PermissionNetwork, PermissionLocation }

class DeviceService extends GetxService {
  // Status/Sensor Properties
  final _direction = Rx<CompassEvent>();
  final _isDarkMode = false.obs;
  final _position = Rx<Position>();

  // Getters for Global References
  static Rx<CompassEvent> get direction => Get.find<DeviceService>()._direction;
  static RxBool get isDarkMode => Get.find<DeviceService>()._isDarkMode;
  static double get lat => Get.find<DeviceService>()._position.value.latitude;
  static double get lon => Get.find<DeviceService>()._position.value.longitude;
  static bool get hasPosition => Get.find<DeviceService>()._position.value != null;

  // Permission Properties
  final cameraPermitted = false.obs;
  final galleryPermitted = false.obs;
  final locationPermitted = false.obs;
  final microphonePermitted = false.obs;
  final networkTriggered = false.obs;
  final notificationPermitted = false.obs;

  // References
  SharedPreferences _prefs;

  // ^ Open SharedPreferences on Init ^ //
  Future<DeviceService> init() async {
    // Get Preferences and Set Status
    _prefs = await SharedPreferences.getInstance();
    await setPermissionStatus();
    await refreshLocation();

    // Bind Direction Stream
    _direction.bindStream(FlutterCompass.events);

    // Set Android Status Bar by Dark Mode
    _isDarkMode.value
        ? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light))
        : SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark));
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
    networkTriggered(_prefs.containsKey("location-triggered"));
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
    var decision = await SonrOverlay.question(
        title: 'Requires Permission',
        description: 'Sonr Needs to Access your Camera in Order to send Pictures through the app.',
        acceptTitle: "Allow",
        declineTitle: "Decline");

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
    var decision = await SonrOverlay.question(
        title: 'Requires Permission',
        description: 'Sonr needs your Permission to access your phones Gallery.',
        acceptTitle: "Allow",
        declineTitle: "Decline");

    if (decision) {
    } else {
      return false;
    }

    var result = await Permission.mediaLibrary.request();
    Get.find<DeviceService>().galleryPermitted(result == PermissionStatus.granted);
    return result == PermissionStatus.granted;
  }

  // ^ Request Location optional overlay ^ //
  static Future<bool> requestLocation() async {
    var decision = await SonrOverlay.question(
        title: 'Requires Permission',
        description: 'Sonr requires location in order to find devices in your area.',
        acceptTitle: "Allow",
        declineTitle: "Decline");

    if (decision) {
      // Request
      var result = await Permission.locationWhenInUse.request();
      Get.find<DeviceService>().locationPermitted(result == PermissionStatus.granted);
      return result == PermissionStatus.granted;
    } else {
      return false;
    }
  }

  // ^ Request Microphone optional overlay ^ //
  static Future<bool> requestMicrophone() async {
    var decision = await SonrOverlay.question(
        title: 'Requires Permission',
        description: 'Sonr uses your microphone in order to communicate with other devices.',
        acceptTitle: "Allow",
        declineTitle: "Decline");

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
    var decision = await SonrOverlay.question(
        title: 'Requires Permission',
        description: 'Sonr would like to send you Notifications for Transfer Invites.',
        acceptTitle: "Allow",
        declineTitle: "Decline");

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
    Get.find<DeviceService>()._prefs.setBool("location-triggered", true);
    Get.find<DeviceService>().networkTriggered(true);
    return true;
  }
}
