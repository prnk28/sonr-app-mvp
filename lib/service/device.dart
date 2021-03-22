import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:sonr_app/modules/home/home_binding.dart';
import 'package:sonr_app/service/permission.dart';
import 'package:sonr_app/theme/theme.dart' hide Position;
import 'package:url_launcher/url_launcher.dart';

// @ Enum defines Type of Permission
enum PermissionType { Camera, Gallery, Location, Notifications, Sound }

class DeviceService extends GetxService {
  // Status/Sensor Properties
  final _direction = Rx<CompassEvent>();
  final _platform = Rx<Platform>();

  // Getters for Global References
  static Rx<CompassEvent> get direction => Get.find<DeviceService>()._direction;
  static Rx<Platform> get platform => Get.find<DeviceService>()._platform;

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

  // ^ Open SharedPreferences on Init ^ //
  Future<DeviceService> init() async {
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
    return this;
  }

  // ^ Method Determins LaunchPage and Changes Screen ^
  static void shiftPage({@required Duration delay}) async {
    Future.delayed(delay, () {
      // Check for User
      if (!UserService.isExisting.value) {
        Get.offNamed("/register");
      } else {
        if (isMobile) {
          // All Valid
          if (Get.find<PermissionService>().locationPermitted.val) {
            Get.offNamed("/home", arguments: HomeArguments(isFirstLoad: true));
          }

          // No Location
          else {
            Get.find<PermissionService>().requestLocation().then((value) {
              if (value) {
                Get.offNamed("/home", arguments: HomeArguments(isFirstLoad: true));
              }
            });
          }
        } else {
          Get.offNamed("/home", arguments: HomeArguments(isFirstLoad: true));
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
}
