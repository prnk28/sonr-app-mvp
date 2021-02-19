import 'dart:async';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:sonr_app/service/sonr_service.dart' hide Position;
import 'package:sonr_app/service/user_service.dart';
import 'package:url_launcher/url_launcher.dart';

// @ Enum defines Type of Permission
enum PermissionType { Camera, Gallery, Location, Notifications, Sound }
enum DeviceStatus { Success, NoUser, NoLocation }

class DeviceService extends GetxService {
  // Status/Sensor Properties
  final _direction = 0.0.obs;
  final _position = Rx<Position>();
  final _status = Rx<DeviceStatus>();

  static RxDouble get direction => Get.find<DeviceService>()._direction;
  static Rx<Position> get position => Get.find<DeviceService>()._position;
  static Rx<DeviceStatus> get status => Get.find<DeviceService>()._status;

  // Permission Properties
  final cameraPermitted = false.obs;
  final galleryPermitted = false.obs;
  final locationPermitted = false.obs;
  final microphonePermitted = false.obs;
  final notificationPermitted = false.obs;

  DeviceService() {
    FlutterCompass.events.listen((dir) {
      direction(dir.headingForCameraMode);
    });
  }

  // ^ Open SharedPreferences on Init ^ //
  Future<DeviceService> init() async {
    await setPermissionStatus();
    await refreshLocation();

    // @ 1. Check for Location
    if (locationPermitted.value) {
      if (UserService.exists.value) {
        _status(DeviceStatus.Success);
      } else {
        _status(DeviceStatus.NoUser);
      }
    } else {
      _status(DeviceStatus.NoLocation);
    }
    return this;
  }

  // ^ CreateUser Event ^
  void createUser(Contact contact, String username) async {
    // Set Sonr Controller
    locationPermitted(await Permission.locationWhenInUse.request().isGranted);
    // @ 1. Check for Location
    if (locationPermitted.value) {
      // Save Current Contact
      await UserService.saveChanges(providedContact: contact);
      SonrService.connect();
      Get.offNamed("/home");
    } else {
      print("Location Permission Denied");
    }
  }

  // ^ Launch a URL Event ^ //
  Future launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // ^ Refresh User Location Position ^ //
  Future<Position> refreshLocation() async {
    if (locationPermitted.value) {
      position(await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high));
      return position.value;
    }
    return null;
  }

  // ^ Sets Permission Status from Service ^ //
  Future setPermissionStatus() async {
    cameraPermitted(await Permission.camera.isGranted);
    galleryPermitted(await Permission.mediaLibrary.isGranted);
    locationPermitted(await Permission.locationWhenInUse.isGranted);
    microphonePermitted(await Permission.microphone.isGranted);
    notificationPermitted(await Permission.notification.isGranted);
  }

  // ************************* //
  // ** Permission Requests ** //
  // ************************* //
  static Future<bool> requestCamera() async {
    var result = await Permission.camera.request();
    Get.find<DeviceService>().cameraPermitted(result == PermissionStatus.granted);
    return result == PermissionStatus.granted;
  }

  static Future<bool> requestGallery() async {
    var result = await Permission.mediaLibrary.request();
    Get.find<DeviceService>().galleryPermitted(result == PermissionStatus.granted);
    return result == PermissionStatus.granted;
  }

  static Future<bool> requestLocation() async {
    var result = await Permission.locationWhenInUse.request();
    Get.find<DeviceService>().locationPermitted(result == PermissionStatus.granted);
    return result == PermissionStatus.granted;
  }

  static Future<bool> requestMicrophone() async {
    var result = await Permission.microphone.request();
    Get.find<DeviceService>().microphonePermitted(result == PermissionStatus.granted);
    return result == PermissionStatus.granted;
  }

  static Future<bool> requestNotifications() async {
    var result = await Permission.notification.request();
    Get.find<DeviceService>().notificationPermitted(result == PermissionStatus.granted);
    return result == PermissionStatus.granted;
  }
}
