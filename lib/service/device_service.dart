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
  Future<bool> requestCamera() async {
    // Create Future Completer
    var completer = new Completer<bool>();

    // Check
    if (Get.find<DeviceService>().cameraPermitted.value) {
      completer.complete(true);
    }

    // Present Overlay
    SonrOverlay.question(
            title: 'Requires Permission',
            description: 'Sonr Needs to Access your Camera in Order to send Pictures through the app.',
            acceptTitle: "Allow",
            declineTitle: "Decline")
        .then((decision) {
      // Check Overlay Decision
      if (decision) {
        Permission.camera.request().then((value) {
          setPermissionStatus();
          completer.complete(value == PermissionStatus.granted);
        });
      } else {
        completer.complete(false);
      }
    });
    return completer.future;
  }

  // ^ Request Gallery optional overlay ^ //
  Future<bool> requestGallery() async {
    // Create Future Completer
    var completer = new Completer<bool>();

    // Check If Exists
    if (Get.find<DeviceService>().galleryPermitted.value) {
      completer.complete(true);
    }

    // Present Overlay
    SonrOverlay.question(
            title: 'Requires Permission',
            description: 'Sonr needs your Permission to access your phones Gallery.',
            acceptTitle: "Allow",
            declineTitle: "Decline")
        .then((decision) {
      // Check Overlay Decision
      if (decision) {
        Permission.mediaLibrary.request().then((value) {
          setPermissionStatus();
          completer.complete(value == PermissionStatus.granted);
        });
      } else {
        completer.complete(false);
      }
    });
    return completer.future;
  }

  // ^ Request Location optional overlay ^ //
  Future<bool> requestLocation() async {
    // Create Future Completer
    var completer = new Completer<bool>();

    // Check If Exists
    if (Get.find<DeviceService>().locationPermitted.value) {
      completer.complete(true);
    }

    // Present Overlay
    SonrOverlay.question(
            title: 'Requires Permission',
            description: 'Sonr requires location in order to find devices in your area.',
            acceptTitle: "Allow",
            declineTitle: "Decline")
        .then((decision) {
      // Check Overlay Decision
      if (decision) {
        // Request
        Permission.locationWhenInUse.request().then((value) {
          setPermissionStatus();
          completer.complete(value == PermissionStatus.granted);
        });
      } else {
        completer.complete(false);
      }
    });
    return completer.future;
  }

  // ^ Request Microphone optional overlay ^ //
  Future<bool> requestMicrophone() async {
    // Create Future Completer
    var completer = new Completer<bool>();

    // Check If Exists
    if (Get.find<DeviceService>().microphonePermitted.value) {
      completer.complete(true);
    }

    // Present Overlay
    SonrOverlay.question(
            title: 'Requires Permission',
            description: 'Sonr uses your microphone in order to communicate with other devices.',
            acceptTitle: "Allow",
            declineTitle: "Decline")
        .then((decision) {
      // Check Overlay Decision
      if (decision) {
        Permission.microphone.request().then((value) {
          setPermissionStatus();
          completer.complete(value == PermissionStatus.granted);
        });
      } else {
        completer.complete(false);
      }
    });
    return completer.future;
  }

  // ^ Request Notifications optional overlay ^ //
  Future<bool> requestNotifications() async {
    // Create Future Completer
    var completer = new Completer<bool>();

    // Check If Exists
    if (notificationPermitted.value) {
      completer.complete(true);
    }

    // Present Overlay
    SonrOverlay.question(
            title: 'Requires Permission',
            description: 'Sonr would like to send you Notifications for Transfer Invites.',
            acceptTitle: "Allow",
            declineTitle: "Decline")
        .then((decision) {
      // Check Overlay Decision
      if (decision) {
        Permission.notification.request().then((value) {
          setPermissionStatus();
          completer.complete(value == PermissionStatus.granted);
        });
      } else {
        completer.complete(false);
      }
    });
    return completer.future;
  }

  // ^ Trigger iOS Local Network with Alert ^ //
  Future triggerNetwork() async {
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
