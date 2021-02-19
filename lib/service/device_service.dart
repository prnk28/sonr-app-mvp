import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonr_app/data/model_user.dart';
import 'package:sonr_app/service/sonr_service.dart' hide User, Position;
import 'package:sonr_app/theme/theme.dart';
import 'package:gallery_saver/gallery_saver.dart';
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

  // References
  StreamSubscription _intentDataStreamSubscription;
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
          // Get Current Position
          var position = await user.position;

          // Initialize Dependent Services
          Get.putAsync(() => SonrService().init(position, user));
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

      // Get Current Position
      var position = await user.position;

      // Initialize Dependent Services
      Get.putAsync(() => SonrService().init(position, user));
      Get.putAsync(() => MediaService().init());
      Get.offNamed("/home");
    } else {
      print("Location Permission Denied");
    }
  }


  // ^ Saves Received Media to Gallery ^ //
  Future<bool> saveMediaFromCard(TransferCard card) async {
    // Get Data from Media
    final path = card.metadata.path;
    if (card.hasMetadata()) {
      // Save Image to Gallery
      if (card.metadata.mime.type == MIME_Type.image) {
        var result = await GallerySaver.saveImage(path, albumName: "Sonr");

        // Visualize Result
        if (result) {
          SonrSnack.success("Saved Photo to your Device's Gallery");
        } else {
          SonrSnack.error("Unable to save Photo to your Gallery");
        }
        return result;
      }

      // Save Video to Gallery
      else if (card.metadata.mime.type == MIME_Type.video) {
        var result = await GallerySaver.saveVideo(path, albumName: "Sonr");

        // Visualize Result
        if (result) {
          SonrSnack.success("Saved Video to your Device's Gallery");
        } else {
          SonrSnack.error("Unable to save Video to your Gallery");
        }
        return result;
      }
      return false;
    } else {
      SonrSnack.success("Unable to save Media to Gallery");
      return false;
    }
  }

  // ^ Saves Photo to Gallery ^ //
  Future saveCapture(String path, bool isVideo) async {
    if (isVideo) {
      // Save Image to Gallery
      await GallerySaver.saveVideo(path, albumName: "Sonr");
    } else {
      // Save Image to Gallery
      await GallerySaver.saveImage(path, albumName: "Sonr");
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

  @override
  void onClose() {
    _intentDataStreamSubscription.cancel();
    super.onClose();
  }
}
