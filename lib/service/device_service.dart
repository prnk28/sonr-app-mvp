import 'dart:async';

import 'package:geolocator/geolocator.dart' as Pkg;
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart' as intent;
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonr_app/data/model_user.dart';
import 'package:sonr_app/service/sonr_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart' hide User;
import 'package:gallery_saver/gallery_saver.dart';
import 'package:url_launcher/url_launcher.dart';

// @ Enum defines Type of Permission
enum PermissionType { Camera, Gallery, Location, Notifications, Sound }

class DeviceService extends GetxService {
  // Properties
  final contact = Rx<Contact>();
  final started = false.obs;
  final incomingMedia = <SharedMediaFile>[].obs;
  final incomingText = "".obs;

  // References
  StreamSubscription _intentDataStreamSubscription;
  SharedPreferences _prefs;
  bool hasLocation;
  bool hasUser;
  Pkg.Position position;
  User user;

  DeviceService() {
    // @ Save Contact Changes
    contact.listen((updatedContact) {
      if (hasUser) {
        user.contact = updatedContact;
        _prefs.setString("user", user.toJson());
      }
    });

    // @ Listen to Incoming File
    _intentDataStreamSubscription = intent.ReceiveSharingIntent.getMediaStream().listen((List<intent.SharedMediaFile> data) {
      if (!Get.isBottomSheetOpen && hasUser) {
        Get.bottomSheet(ShareSheet.media(data), barrierColor: K_DIALOG_COLOR, isDismissible: false);
      }
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // @ Listen to Incoming Text
    _intentDataStreamSubscription = intent.ReceiveSharingIntent.getTextStream().listen((String text) {
      if (!Get.isBottomSheetOpen && GetUtils.isURL(text) && hasUser) {
        Get.bottomSheet(ShareSheet.url(text), barrierColor: K_DIALOG_COLOR, isDismissible: false);
      }
    }, onError: (err) {
      print("getLinkStream error: $err");
    });
  }

  @override
  void onInit() {
    // @ For sharing images coming from outside the app while the app is closed
    intent.ReceiveSharingIntent.getInitialMedia().then((List<intent.SharedMediaFile> data) {
      if (data != null) {
        incomingMedia(data);
        incomingMedia.refresh();
      }
    });

    // @ For sharing or opening urls/text coming from outside the app while the app is closed
    intent.ReceiveSharingIntent.getInitialText().then((String text) {
      if (text != null) {
        incomingText(text);
        incomingText.refresh();
      }
    });
    super.onInit();
  }

  // ^ Open SharedPreferences on Init ^ //
  Future<DeviceService> init() async {
    // Init Shared Preferences
    _prefs = await SharedPreferences.getInstance();

    // Check Location Status
    hasLocation = await Permission.locationWhenInUse.serviceStatus == ServiceStatus.enabled;

    // Check User Status
    hasUser = _prefs.containsKey("user");
    start();
    return this;
  }

  // ^ Method to Connect User Event ^
  void start() async {
    // @ 1. Check for Location
    if (hasLocation = await Permission.locationWhenInUse.request().isGranted) {
      // @ 2. Get Profile
      if (hasUser) {
        // Get Json Value
        var profileJson = _prefs.getString("user");

        // Get Profile object
        user = User.fromJson(profileJson);
        contact(user.contact);

        if (user != null) {
          // Get Current Position
          position = await user.position;

          // Initialize Dependent Services
          Get.putAsync(() => SonrService().init(position, user));
          started(true);
        }
      } else {
        // Push to Register Screen
        Get.offNamed("/register");
      }
    } else {
      print("Location Permission Denied");
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
      hasUser = true;

      // Get Current Position
      position = await user.position;

      // Initialize Dependent Services
      Get.putAsync(() => SonrService().init(position, user));
      started(true);
    } else {
      print("Location Permission Denied");
    }
  }

  // ^ Checks for Initial Media/Text to Share ^ //
  void checkInitialShare() {
    // @ Check for Media
    if (incomingMedia.isNotEmpty && !Get.isBottomSheetOpen) {
      // Open Sheet
      Get.bottomSheet(ShareSheet.media(incomingMedia), barrierColor: K_DIALOG_COLOR, isDismissible: false);

      // Reset Incoming
      incomingMedia.clear();
      incomingMedia.refresh();
    }

    // @ Check for Text
    if (incomingText.value != "" && GetUtils.isURL(incomingText.value) && !Get.isBottomSheetOpen) {
      // Open Sheet
      Get.bottomSheet(ShareSheet.url(incomingText.value), barrierColor: K_DIALOG_COLOR, isDismissible: false);

      // Reset Incoming
      incomingText("");
      incomingText.refresh();
    }
  }

  // ^ Saves Received Media to Gallery ^ //
  Future saveMediaFromCard(TransferCard card) async {
    // Get Data from Media
    final path = card.metadata.path;

    // Save Image to Gallery
    await GallerySaver.saveImage(path, albumName: "Sonr");
  }

  // ^ Saves Photo to Gallery ^ //
  Future savePhoto(String path) async {
    // Save Image to Gallery
    await GallerySaver.saveImage(path, albumName: "Sonr");
  }

  // ^ RequestPermission Event ^ //
  Future<bool> requestPermission(PermissionType type) async {
    switch (type) {
      case PermissionType.Location:
        return await Permission.locationWhenInUse.request().isGranted;
        break;

      case PermissionType.Camera:
        return await Permission.camera.request().isGranted;
        break;

      case PermissionType.Gallery:
        return await Permission.photos.request().isGranted;
        break;

      case PermissionType.Notifications:
        return await Permission.notification.request().isGranted;
        break;

      case PermissionType.Sound:
        return await Permission.microphone.request().isGranted;
        break;

      default:
        return false;
        break;
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
