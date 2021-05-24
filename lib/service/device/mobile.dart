import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audio_cache.dart';
import 'package:crypton/crypton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sonr_app/data/model/model_hs.dart';
import 'package:sonr_app/pages/home/share/sheet_view.dart';
import 'package:sonr_app/style/style.dart';
import 'package:motion_sensors/motion_sensors.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonr_app/service/device/device.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:bip39/bip39.dart' as bip39;

// @ Enum defines Type of Permission
const K_SENSOR_INTERVAL = Duration.microsecondsPerSecond ~/ 30;

// Storage Constants
const K_PRIVKEY_TAG = 'sonr-private-key';
const K_PREFIX_TAG = 'sonr-prefix';
const K_MNEMONIC_TAG = 'sonr-mnemonic';

class MobileService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<MobileService>();
  static MobileService get to => Get.find<MobileService>();

  // Permissions
  final _hasCamera = false.obs;
  final _hasLocation = false.obs;
  final _hasLocalNetwork = false.obs;
  final _hasMicrophone = false.obs;
  final _hasNotifications = false.obs;
  final _hasPhotos = false.obs;
  final _hasStorage = false.obs;

  // Mobile Platform Controllers/Properties
  final _audioPlayer = AudioCache(prefix: 'assets/sounds/', respectSilence: true);
  final _keyboardVisibleController = KeyboardVisibilityController();
  final _keyboardVisible = false.obs;
  final _position = Rx<Position>(Position());
  final _incomingMedia = <SharedMediaFile>[].obs;
  final _incomingText = "".obs;

  // Getters for Device/Location References
  static RxBool get keyboardVisible => to._keyboardVisible;
  static Rx<Position> get position => to._position;
  static RxBool get hasCamera => to._hasCamera;
  static RxBool get hasLocation => to._hasLocation;
  static RxBool get hasLocalNetwork => to._hasLocalNetwork;
  static RxBool get hasMicrophone => to._hasMicrophone;
  static RxBool get hasNotifications => to._hasNotifications;
  static RxBool get hasPhotos => to._hasPhotos;
  static RxBool get hasStorage => to._hasStorage;

  static RxBool get hasGallery {
    if (DeviceService.isIOS) {
      return to._hasPhotos;
    } else {
      return to._hasStorage;
    }
  }

  // Auth Properties
  final _hasKey = false.obs;
  final _hasMnemonic = false.obs;
  final _hasPrefix = false.obs;

  // Authentication
  late ECKeypair _ecKeypair;
  late String _mnemonic;
  late String _prefix;

  // Shortcuts
  String get deviceID => DeviceService.device.id;
  String get mnemonic => _mnemonic;
  Uint8List get mnemonicUTF => Uint8List.fromList(utf8.encode(_mnemonic));

  String get privateKey => _ecKeypair.privateKey.toString();
  String get publicKey => _ecKeypair.publicKey.toString();
  Uint8List get signature => _ecKeypair.privateKey.createSHA512Signature(mnemonicUTF);
  String get signatureHex => String.fromCharCodes(signature);
  bool get hasAuth => _hasKey.value && _hasMnemonic.value && _hasPrefix.value;

  /// Auth Accessors
  static User_Crypto get userCrypto => User_Crypto(prefix: to._prefix, signature: to.signatureHex, privateKey: to._ecKeypair.privateKey.toString());
  static Tuple<String, String> get mnemonicPrefix => Tuple(to._mnemonic, to._prefix);
  static String get prefix => to._prefix;

  // References
  final _secure = FlutterSecureStorage();
  late StreamSubscription _externalMediaStream;
  late StreamSubscription _externalTextStream;
  late StreamSubscription<AccelerometerEvent> _accelStream;
  late StreamSubscription<CompassEvent> _compassStream;
  late StreamSubscription<OrientationEvent> _orienStream;

  // * Device Service Initialization * //
  Future<MobileService> init() async {
    // @ 1. Set Authentication
    // Set Auth Data
    _hasKey(await _secure.containsKey(key: K_PRIVKEY_TAG));
    _hasMnemonic(await _secure.containsKey(key: K_MNEMONIC_TAG));
    _hasPrefix(await _secure.containsKey(key: K_PREFIX_TAG));

    // i. Set Key
    if (_hasKey.value) {
      final privKeyData = await _secure.read(key: K_PRIVKEY_TAG);
      _ecKeypair = ECKeypair(ECPrivateKey.fromString(privKeyData!));
    } else {
      _ecKeypair = ECKeypair.fromRandom();
      await _secure.write(key: K_PRIVKEY_TAG, value: _ecKeypair.privateKey.toString());
      _hasKey(true);
    }

    // ii. Set Mnemonic
    if (_hasMnemonic.value) {
      final data = await _secure.read(key: K_MNEMONIC_TAG);
      _mnemonic = data!;
    }

    // iii. Set Prefix
    if (_hasPrefix.value) {
      final prefixData = await _secure.read(key: K_PREFIX_TAG);
      _prefix = prefixData!;
    }

    // Handle Keyboard Visibility
    _keyboardVisible.bindStream(_keyboardVisibleController.onChange);

    // @ 3. Bind Sensors for Mobile
    // Bind Direction and Set Intervals
    motionSensors.accelerometerUpdateInterval = K_SENSOR_INTERVAL;
    motionSensors.orientationUpdateInterval = K_SENSOR_INTERVAL;

    // Bind Sensor Streams
    _accelStream = motionSensors.accelerometer.listen(_handleAccelerometer);
    _compassStream = FlutterCompass.events!.listen(_handleCompass);
    _orienStream = motionSensors.orientation.listen(_handleOrientation);

    // Audio Player
    _audioPlayer.disableLog();
    await _audioPlayer.loadAll(List<String>.generate(UISoundType.values.length, (index) => UISoundType.values[index].file));

    // Update Device Values
    await updatePermissionsStatus();

    // Set Location
    if (_hasLocation.value) {
      var result = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
      DeviceService.setGeoLocation(Location_Geo(latitude: result.latitude, longitude: result.longitude));
    }

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile>? data) {
      if (data != null) {
        _incomingMedia(data);
        _incomingMedia.refresh();
      }
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? text) {
      if (text != null) {
        _incomingText(text);
        _incomingText.refresh();
      }
    });

    // Listen to Incoming Text/File
    _externalTextStream = ReceiveSharingIntent.getTextStream().listen(_handleSharedText);
    _externalMediaStream = ReceiveSharingIntent.getMediaStream().listen(_handleSharedFiles);
    return this;
  }

  // * Close Streams * //
  @override
  void onClose() {
    _accelStream.cancel();
    _compassStream.cancel();
    _orienStream.cancel();
    _audioPlayer.clearCache();
    _externalMediaStream.cancel();
    _externalTextStream.cancel();
    super.onClose();
  }

  /// @ Checks for Initial Media/Text to Share
  static checkInitialShare() async {
    // @ Check for Media
    if (to._incomingMedia.length > 0 && !Get.isBottomSheetOpen!) {
      // Open Sheet
      await Get.bottomSheet(ShareSheet.media(to._incomingMedia), isDismissible: false);

      // Reset Incoming
      to._incomingMedia.clear();
      to._incomingMedia.refresh();
    }

    // @ Check for Text
    if (to._incomingText.value != "" && GetUtils.isURL(to._incomingText.value) && !Get.isBottomSheetOpen!) {
      var data = await SonrService.getURL(to._incomingText.value);
      // Open Sheet
      await Get.bottomSheet(ShareSheet.url(data), isDismissible: false);

      // Reset Incoming
      to._incomingText("");
      to._incomingText.refresh();
    }
  }

  /// @ Method Closes Keyboard if Active
  static void closeKeyboard({BuildContext? context}) async {
    if (to._keyboardVisible.value) {
      FocusScope.of(context ?? Get.context!).unfocus();
    }
  }

  static HSRecord getAuthRecord(String n) {
    return HSRecord.newAuth(newPrefix(n), n, to.signatureHex);
  }

  static Future<User_Crypto> newCrypto(String name) async {
    // No Prefix Data
    if (!to._hasPrefix.value) {
      to._prefix = newPrefix(name);
      await to._secure.write(key: K_PREFIX_TAG, value: to._prefix);
      to._hasPrefix(true);
    }

    // No Mnemonic Found
    if (!to._hasMnemonic.value) {
      to._mnemonic = bip39.generateMnemonic();
      await to._secure.write(key: K_MNEMONIC_TAG, value: to._mnemonic);
      to._hasMnemonic(true);
    }
    return User_Crypto(prefix: to._prefix, signature: to.signatureHex, privateKey: to._ecKeypair.privateKey.toString());
  }

  // Helper Method to Generate Prefix
  static String newPrefix(String username) {
    // Create New Prefix
    var hmacSha256 = crypto.Hmac(crypto.sha256, utf8.encode(username + to.deviceID));
    var digest = hmacSha256.convert(utf8.encode(username + to.deviceID));
    return "$digest".substring(0, 16);
  }

  static Future<String> updatePrefix(String name) async {
    // No Prefix Data
    if (!to._hasPrefix.value) {
      to._prefix = newPrefix(name);
      await to._secure.write(key: K_PREFIX_TAG, value: to._prefix);
      to._hasPrefix(true);
      return to._prefix;
    }
    return to._prefix;
  }

  /// @ Refresh User Location Position
  static Future<void> updateLocation() async {
    if (to._hasLocation.value) {
      var result = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
      DeviceService.setGeoLocation(Location_Geo(latitude: result.latitude, longitude: result.longitude));
    } else {
      print("No Location Permissions");
      return null;
    }
  }

  /// @ Method Plays a UI Sound
  static void playSound(UISoundType type) async {
    await to._audioPlayer.play(type.file);
  }

  /// @ Saves Photo to Gallery
  static Future<bool> saveCapture(String path, bool isVideo) async {
    // Validate Path
    var file = File(path);
    var exists = await file.exists();
    if (!exists) {
      SonrSnack.error("Unable to save Captured Media to your Gallery");
      return false;
    } else {
      if (isVideo) {
        // Set Video File
        File videoFile = File(path);
        var asset = await (PhotoManager.editor.saveVideo(videoFile) as FutureOr<AssetEntity>);
        var result = await asset.exists;

        // Visualize Result
        if (result) {
          SonrSnack.error("Unable to save Captured Photo to your Gallery");
        }
        return result;
      } else {
        // Save Image to Gallery
        var asset = await (PhotoManager.editor.saveImageWithPath(path) as FutureOr<AssetEntity>);
        var result = await asset.exists;
        if (!result) {
          SonrSnack.error("Unable to save Captured Video to your Gallery");
        }
        return result;
      }
    }
  }

  /// @ Saves Received Media to Gallery
  static Future<bool> saveTransfer(SonrFile_Item meta) async {
    // Initialize
    AssetEntity? asset;

    // Get Data from Media
    if (meta.mime.isImage && MobileService.hasGallery.value) {
      asset = await PhotoManager.editor.saveImageWithPath(meta.path);

      // Visualize Result
      if (asset != null) {
        meta.id = asset.id;
        return await asset.exists;
      } else {
        return false;
      }
    }

    // Save Video to Gallery
    else if (meta.mime.isVideo && MobileService.hasGallery.value) {
      // Set Video File
      asset = await PhotoManager.editor.saveVideo(meta.file);

      // Visualize Result
      if (asset != null) {
        meta.id = asset.id;
        return await asset.exists;
      } else {
        return false;
      }
    }

    // Return Status
    return false;
  }

  /// @ Verifys Given Signature with Mnemonic
  static bool verifyFingerprint(HSRecord record) {
    if (record.isAuth) {
      return to._ecKeypair.publicKey.verifySHA512Signature(
        to.mnemonicUTF,
        record.fingerprint,
      );
    }
    return false;
  }

  /// @ Update Method
  Future<void> updatePermissionsStatus() async {
    _hasCamera(await Permission.camera.isGranted);
    _hasLocation(await Permission.locationWhenInUse.isGranted);
    _hasMicrophone(await Permission.microphone.isGranted);
    _hasNotifications(await Permission.notification.isGranted);
    _hasPhotos(await Permission.photos.isGranted);
    _hasStorage(await Permission.storage.isGranted);
  }

  /// @ Request Camera optional overlay
  Future<bool> requestCamera() async {
    if (DeviceService.isMobile) {
      // Present Overlay
      if (await SonrOverlay.question(
          title: 'Requires Permission',
          description: 'Sonr Needs to Access your Camera in Order to send Pictures through the app.',
          acceptTitle: "Allow",
          declineTitle: "Decline")) {
        if (await Permission.camera.request().isGranted) {
          updatePermissionsStatus();
          SonrOverlay.back();
          SonrOverlay.back();
          return true;
        } else {
          updatePermissionsStatus();
          SonrOverlay.back();
          SonrOverlay.back();
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  /// @ Request Gallery optional overlay
  Future<bool> requestGallery({String description = 'Sonr needs your Permission to access your phones Gallery.'}) async {
    if (DeviceService.isMobile) {
      // Present Overlay
      if (await SonrOverlay.question(title: 'Photos', description: description, acceptTitle: "Allow", declineTitle: "Decline")) {
        if (DeviceService.isAndroid) {
          if (await Permission.storage.request().isGranted) {
            updatePermissionsStatus();
            SonrOverlay.back();
            return true;
          } else {
            updatePermissionsStatus();
            SonrOverlay.back();
            return false;
          }
        } else {
          if (await Permission.photos.request().isGranted) {
            updatePermissionsStatus();
            SonrOverlay.back();
            return true;
          } else {
            updatePermissionsStatus();
            SonrOverlay.back();
            return false;
          }
        }
      } else {
        updatePermissionsStatus();
        SonrOverlay.back();
        SonrOverlay.back();
        return false;
      }
    } else {
      updatePermissionsStatus();
      SonrOverlay.back();
      SonrOverlay.back();
      return false;
    }
  }

  /// @ Request Location optional overlay
  Future<bool> requestLocation() async {
    if (DeviceService.isMobile) {
      // Present Overlay
      if (await SonrOverlay.question(
          title: 'Location',
          description: 'Sonr requires location in order to find devices in your area.',
          acceptTitle: "Allow",
          declineTitle: "Decline")) {
        if (await Permission.locationWhenInUse.request().isGranted) {
          updatePermissionsStatus();
          SonrOverlay.back();
          return true;
        } else {
          updatePermissionsStatus();
          SonrOverlay.back();
          return false;
        }
      } else {
        updatePermissionsStatus();
        SonrOverlay.back();
        return false;
      }
    } else {
      updatePermissionsStatus();
      SonrOverlay.back();
      return false;
    }
  }

  /// @ Request Microphone optional overlay
  Future<bool> requestMicrophone() async {
    if (DeviceService.isMobile) {
      // Present Overlay
      if (await SonrOverlay.question(
          title: 'Microphone',
          description: 'Sonr uses your microphone in order to communicate with other devices.',
          acceptTitle: "Allow",
          declineTitle: "Decline")) {
        if (await Permission.microphone.request().isGranted) {
          updatePermissionsStatus();
          SonrOverlay.back();
          return true;
        } else {
          updatePermissionsStatus();
          SonrOverlay.back();
          return false;
        }
      } else {
        updatePermissionsStatus();
        SonrOverlay.back();
        return false;
      }
    } else {
      updatePermissionsStatus();
      SonrOverlay.back();
      return false;
    }
  }

  /// @ Request Notifications optional overlay
  Future<bool> requestNotifications() async {
    // Present Overlay
    if (DeviceService.isMobile) {
      if (await SonrOverlay.question(
          title: 'Requires Permission',
          description: 'Sonr would like to send you Notifications for Transfer Invites.',
          acceptTitle: "Allow",
          declineTitle: "Decline")) {
        if (await Permission.notification.request().isGranted) {
          updatePermissionsStatus();
          SonrOverlay.back();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  /// @ Trigger iOS Local Network with Alert
  Future triggerNetwork() async {
    if (!_hasLocalNetwork.value && DeviceService.isIOS) {
      await SonrOverlay.alert(
          title: 'Requires Permission',
          description: 'Sonr requires local network permissions in order to maximize transfer speed.',
          buttonText: "Continue",
          barrierDismissible: false);

      SonrService.requestLocalNetwork();
      updatePermissionsStatus();
      SonrOverlay.back();
    }
    return true;
  }

  // # Handle Accelerometer
  void _handleAccelerometer(AccelerometerEvent event) {
    _position.update((val) {
      val!.accelerometer = Position_Accelerometer(x: event.x, y: event.y, z: event.z);
    });
  }

  // # Handle Compass
  void _handleCompass(CompassEvent event) {
    _position.update((val) {
      val!.heading = Position_Compass(direction: event.heading);
      val.facing = Position_Compass(direction: event.headingForCameraMode);
    });
  }

  // # Handle Orientation
  void _handleOrientation(OrientationEvent event) {
    _position.update((val) {
      val!.orientation = Position_Orientation(pitch: event.pitch, roll: event.roll, yaw: event.yaw);
    });
  }

  // # Saves Received Media to Gallery
  _handleSharedFiles(List<SharedMediaFile> data) async {
    if (!Get.isBottomSheetOpen!) {
      await Get.bottomSheet(ShareSheet.media(data), isDismissible: false);
    }
  }

  // # Saves Received Media to Gallery
  _handleSharedText(String text) async {
    if (!Get.isBottomSheetOpen! && GetUtils.isURL(text)) {
      // Get Data
      var data = await SonrService.getURL(text);

      // Open Sheet
      await Get.bottomSheet(ShareSheet.url(data), isDismissible: false);
    }
  }
}
