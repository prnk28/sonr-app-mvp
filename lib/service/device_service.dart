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
  final direction = 0.0.obs;
  final position = Rx<Position>();
  final startStatus = Rx<DeviceStatus>();

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
    start();
    return this;
  }

  // ^ Method to Connect User Event ^
  void start() async {
    // @ 1. Check for Location
    locationPermitted(await Permission.locationWhenInUse.request().isGranted);
    if (locationPermitted.value) {
      if (UserService.exists.value) {
        // Initialize Dependent Services
        Get.putAsync(() => SonrService().init(position.value, UserService.current));
        startStatus(DeviceStatus.Success);
      } else {
        startStatus(DeviceStatus.NoUser);
      }
    } else {
      startStatus(DeviceStatus.NoLocation);
    }
  }

  // ^ CreateUser Event ^
  void createUser(Contact contact, String username) async {
    // Set Sonr Controller
    // @ 1. Check for Location
    if (locationPermitted.value) {
      // Save Current Contact
      var user = await UserService.saveChanges(providedContact: contact);

      // Get Current Location
      var location = await refreshLocation();

      // Initialize Dependent Services
      Get.putAsync(() => SonrService().init(location, user));
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

  Future<bool> requestCamera() async {
    var result = await Permission.camera.request();
    return result == PermissionStatus.granted;
  }

  Future<bool> requestGallery() async {
    var result = await Permission.mediaLibrary.request();
    return result == PermissionStatus.granted;
  }

  Future<bool> requestLocation() async {
    var result = await Permission.locationWhenInUse.request();
    return result == PermissionStatus.granted;
  }

  Future<bool> requestMicrophone() async {
    var result = await Permission.microphone.request();
    return result == PermissionStatus.granted;
  }

  Future<bool> requestNotifications() async {
    var result = await Permission.notification.request();
    return result == PermissionStatus.granted;
  }
}
