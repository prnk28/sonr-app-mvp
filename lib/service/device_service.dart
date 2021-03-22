import 'dart:async';
import 'dart:io' as io;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:sonr_app/modules/home/home_binding.dart';
import 'package:sonr_app/theme/theme.dart' hide Position;
import 'package:url_launcher/url_launcher.dart';

// @ Enum defines Type of Permission
enum PermissionType { Camera, Gallery, Location, Notifications, Sound }

class DeviceService extends GetxService {
  // Status/Sensor Properties
  final _brightness = Rx<Brightness>();
  final _direction = Rx<CompassEvent>();
  final _isDarkMode = true.obs;
  final _hasPointToShare = false.obs;
  final _platform = Rx<Platform>();

  // Getters for Global References
  static Rx<Brightness> get brightness => Get.find<DeviceService>()._brightness;
  static Rx<CompassEvent> get direction => Get.find<DeviceService>()._direction;
  static RxBool get isDarkMode => Get.find<DeviceService>()._isDarkMode;
  static RxBool get hasPointToShare => Get.find<DeviceService>()._hasPointToShare;

  // Platform Properties
  static bool get isDesktop =>
      Get.find<DeviceService>()._platform.value == Platform.Linux ||
      Get.find<DeviceService>()._platform.value == Platform.MacOS ||
      Get.find<DeviceService>()._platform.value == Platform.Windows;
  static bool get isMobile =>
      Get.find<DeviceService>()._platform.value == Platform.iOS || Get.find<DeviceService>()._platform.value == Platform.Android;
  static bool get isAndroid => Get.find<DeviceService>()._platform.value == Platform.Android;
  static bool get isIOS => Get.find<DeviceService>()._platform.value == Platform.iOS;
  static bool get isLinux => Get.find<DeviceService>()._platform.value == Platform.Linux;
  static bool get isMacOS => Get.find<DeviceService>()._platform.value == Platform.MacOS;
  static bool get isWindows => Get.find<DeviceService>()._platform.value == Platform.Windows;
  static Rx<Platform> get platform => Get.find<DeviceService>()._platform;

  // References
  final _box = GetStorage();

  // Permissions Values
  final cameraPermitted = false.val('cameraPermitted');
  final galleryPermitted = false.val('galleryPermitted');
  final locationPermitted = false.val('locationPermitted');
  final microphonePermitted = false.val('microphonePermitted');
  final networkTriggered = false.val('networkTriggered');
  final notificationPermitted = false.val('notificationPermitted');

  // ^ Open SharedPreferences on Init ^ //
  Future<DeviceService> init() async {
    // Initialize Storage
    await GetStorage.init();

    // Set Platform
    if (io.Platform.isAndroid) {
      _platform(Platform.Android);
    } else if (io.Platform.isIOS) {
      _platform(Platform.iOS);
    } else if (io.Platform.isLinux) {
      _platform(Platform.Linux);
    } else if (io.Platform.isMacOS) {
      _platform(Platform.MacOS);
    } else if (io.Platform.isWindows) {
      _platform(Platform.Windows);
    }

    // Bind Direction Stream
    if (_platform.value == Platform.iOS || _platform.value == Platform.Android) {
      _direction.bindStream(FlutterCompass.events);
    }

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

  // ^ Method Determins LaunchPage and Changes Screen ^
  static void shiftPage({@required Duration delay}) async {
    Future.delayed(delay, () {
      // Check for User
      if (!UserService.exists.value) {
        Get.offNamed("/register");
      } else {
        // All Valid
        if (Get.find<DeviceService>().locationPermitted.val) {
          Get.offNamed("/home", arguments: HomeArguments(isFirstLoad: true));
        }

        // No Location
        else {
          Get.find<DeviceService>().requestLocation().then((value) {
            if (value) {
              Get.offNamed("/home", arguments: HomeArguments(isFirstLoad: true));
            }
          });
        }
      }
    });
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
        cameraPermitted.val = true;
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
      if (io.Platform.isAndroid) {
        if (await Permission.storage.request().isGranted && await Permission.photos.request().isGranted) {
          galleryPermitted.val = true;
          return true;
        } else {
          return false;
        }
      } else {
        if (await Permission.photos.request().isGranted) {
          galleryPermitted.val = true;
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
        locationPermitted.val = true;
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
        microphonePermitted.val = true;
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
        notificationPermitted.val = true;
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
    if (!networkTriggered.val && io.Platform.isIOS) {
      await SonrOverlay.alert(
          title: 'Requires Permission',
          description: 'Sonr requires local network permissions in order to maximize transfer speed.',
          buttonText: "Continue",
          barrierDismissible: false);

      await SonrCore.requestLocalNetwork();
      networkTriggered.val = true;
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
