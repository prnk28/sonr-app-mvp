import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sonr_app/modules/share/external_sheet.dart';
import 'package:sonr_app/pages/transfer/remote/sheet_view.dart';
import 'package:sonr_app/style.dart';
import 'package:motion_sensors/motion_sensors.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonr_app/service/device/device.dart';
import 'package:uni_links/uni_links.dart';

// @ Enum defines Type of Permission
const K_SENSOR_INTERVAL = Duration.microsecondsPerSecond ~/ 30;

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
  final _incomingRemote = "".obs;
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

  // References
  late StreamSubscription _remoteLinkStream;
  late StreamSubscription _externalMediaStream;
  late StreamSubscription _externalTextStream;
  late StreamSubscription<AccelerometerEvent> _accelStream;
  late StreamSubscription<CompassEvent> _compassStream;
  late StreamSubscription<OrientationEvent> _orienStream;

  MobileService() {
    Timer.periodic(250.milliseconds, (timer) {
      if (SonrServices.areServicesRegistered && isRegistered && SonrService.isRegistered) {
        SonrService.update(position.value);
      }
    });
  }

  // * Device Service Initialization * //
  Future<MobileService> init() async {
    // Handle Keyboard Visibility
    _keyboardVisible.bindStream(_keyboardVisibleController.onChange);

    // @ Bind Sensors for Mobile
    // Bind Direction and Set Intervals
    motionSensors.accelerometerUpdateInterval = K_SENSOR_INTERVAL;
    motionSensors.orientationUpdateInterval = K_SENSOR_INTERVAL;

    // Bind Sensor Streams
    _accelStream = motionSensors.accelerometer.listen(_handleAccelerometer);
    _compassStream = FlutterCompass.events!.listen(_handleCompass);
    _orienStream = motionSensors.orientation.listen(_handleOrientation);

    // Audio Player
    await _audioPlayer.loadAll(List<String>.generate(UISoundType.values.length, (index) => UISoundType.values[index].file));

    // Update Device Values
    await updatePermissionsStatus();

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
    _remoteLinkStream = linkStream.listen(_handleSharedRemote);
    return this;
  }

  // * Close Streams * //
  @override
  void onClose() {
    _accelStream.cancel();
    _compassStream.cancel();
    _orienStream.cancel();
    _externalMediaStream.cancel();
    _externalTextStream.cancel();
    _remoteLinkStream.cancel();
    super.onClose();
  }

  /// @ Checks for Initial Media/Text to Share
  static checkInitialShare() async {
    if (isRegistered) {
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

      // @ Check for Remote
      if (to._incomingRemote.value.isNotEmpty) {
        RemoteSheet.open(to._incomingRemote.value);
      }
    }
  }

  /// @ Method Closes Keyboard if Active
  static void closeKeyboard({BuildContext? context}) async {
    if (isRegistered) {
      if (to._keyboardVisible.value) {
        FocusScope.of(context ?? Get.context!).unfocus();
      }
    }
  }

  /// @ Method Plays a UI Sound
  static void playSound(UISoundType type) async {
    if (isRegistered) {
      // await to._audioPlayer.play(type.file);
    }
  }

  /// @ Saves Photo to Gallery
  static Future<bool> saveCapture(String path, bool isVideo) async {
    if (isRegistered) {
      // Validate Path
      var file = File(path);
      var exists = await file.exists();
      if (!exists) {
        Snack.error("Unable to save Captured Media to your Gallery");
        return false;
      } else {
        if (isVideo) {
          // Set Video File
          File videoFile = File(path);
          var asset = await (PhotoManager.editor.saveVideo(videoFile) as FutureOr<AssetEntity>);
          var result = await asset.exists;

          // Visualize Result
          if (result) {
            Snack.error("Unable to save Captured Photo to your Gallery");
          }
          return result;
        } else {
          // Save Image to Gallery
          var asset = await (PhotoManager.editor.saveImageWithPath(path) as FutureOr<AssetEntity>);
          var result = await asset.exists;
          if (!result) {
            Snack.error("Unable to save Captured Video to your Gallery");
          }
          return result;
        }
      }
    }
    return false;
  }

  /// @ Saves Received Media to Gallery
  static Future<bool> saveTransfer(SonrFile_Item meta) async {
    if (isRegistered) {
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
    }

    // Return Status
    return false;
  }

  /// @ Update Method
  Future<void> updatePermissionsStatus() async {
    _hasCamera(await Permission.camera.isGranted);
    _hasLocation(await Permission.location.isGranted);
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
        if (await Permission.location.request().isGranted) {
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

  // # Handle Incoming Remote Link
  _handleSharedRemote(String? link) async {
    if (link != null) {
      Logger.info('Shared Remote Link: ' + link);
      if (link.contains(".remote.")) {
        _incomingRemote(link);
        RemoteSheet.open(to._incomingRemote.value.substring(7));
      }
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

// import 'dart:async';

// // import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
// import 'package:sonr_app/style/style.dart';
// import 'package:flutter_blue/flutter_blue.dart';

// class BLEService extends GetxService {
//   // Static Analyzers
//   static bool get isRegistered => Get.isRegistered<LobbyService>();
//   static BLEService get to => Get.find<BLEService>();

//   // @ Properties
//   final _devices = RxList<BLEDevice>();
//   final _selfUdid = BLESonrUdid("").obs;
//   final _status = BLEStatus.None.obs;

//   // @ References
//   final FlutterBlue _reader = FlutterBlue.instance;
//   // final FlutterBlePeripheral _writer = FlutterBlePeripheral();
//   late StreamSubscription _deviceStream;

//   /// * Initializes Service for Mobile Devices *
//   Future<BLEService> init() async {
//     // Set Status from Availibility
//     _status(BLEStatusUtils.fromData(Tuple(await _reader.isAvailable, await _reader.isOn)));

//     // Bind Status Stream
//     return this;
//   }

//   /// #### Inititalize MultiAddr from Connected SonrService
//   static Future<void> initMultiAddr(String maddr) async {
//     // Check if Platform is Mobile
//     if (DeviceService.isMobile) {
//       // Set Udid
//       to._selfUdid(BLESonrUdid.fromData(DeviceService.platform, maddr));

//       print("MultiAddr: " + maddr);
//       // Begin Scanning
//       // to._startAdvertise();
//     }
//   }

//   /// #### Begin Discovery of Peers
//   static Future<void> discover(String maddr) async {
//     if (DeviceService.isMobile) {
//       // Scan Devices
//       if (to._status.value.isReady) {
//         // Start scanning
//         to._status(to._status.value.setIsScanning(true));
//         to._refreshScan();
//         to._status(to._status.value.setIsScanning(false));
//       }
//     }
//   }

//   // Helper: Refreshes Scan
//   void _refreshScan() async {
//     // Start Scan with 4s Timeout
//     _reader.startScan(timeout: 4.seconds);

//     // Listen to scan results
//     _deviceStream = _reader.scanResults.listen(_handleScanResults);

//     // Stop scanning
//     _reader.stopScan();
//   }

//   // // Helper: Starts Advertising
//   // void _startAdvertise() async {
//   //   // Check for Not Advertising
//   //   if (!await _writer.isAdvertising()) {
//   //     // Validate Self Udid
//   //     if (_selfUdid.value.isValid) {
//   //       // Start Broadcast
//   //       await _writer.start(_selfUdid.value.toAdvertiseData());
//   //       to._status(to._status.value.setIsAdvertising(true));
//   //     }
//   //   }
//   // }

//   // // Helper: Stops Advertising
//   // void _stopAdvertise() async {
//   //   if (await _writer.isAdvertising()) {
//   //     await _writer.stop();
//   //     to._status(to._status.value.setIsAdvertising(false));
//   //   }
//   // }

//   // Helper: Handles Scan Results
//   void _handleScanResults(List<ScanResult> results) {
//     // Add Devices from Results
//     _devices.addAllScanResults(results);
//     _devices.refresh();
//     _devices.printCount();
//   }

//   // * Handle Close for Service * //
//   @override
//   void onClose() {
//     // _stopAdvertise();
//     _deviceStream.cancel();
//     super.onClose();
//   }
// }
