import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sonr_app/style/style.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:sonr_app/data/services/services.dart';

class DeviceService extends GetxService {
  // Accessors
  static bool get hasInternet => to._connectivity.value.hasInternet;
  static bool get isRegistered => Get.isRegistered<DeviceService>();
  static DeviceService get to => Get.find<DeviceService>();
  static String pushKeyPath = "";

  // Fetch Platform for Device
  static Platform get platform {
    if (isRegistered) {
      return to._device.platform;
    } else {
      return PlatformUtils.find();
    }
  }

  // Platform Utilities
  static bool get isDesktop => platform.isDesktop;
  static bool get isMobile => platform.isMobile;
  static bool get isAndroid => platform.isAndroid;
  static bool get isIOS => platform.isIOS;
  static bool get isLinux => platform.isLinux;
  static bool get isMacOS => platform.isMacOS;
  static bool get isWindows => platform.isWindows;

  // Properties
  static Device get device => to._device;
  static RxPosition get position => to._position;
  static Rx<ConnectivityResult> get connectivity => to._connectivity;

  // Properties
  late final Device _device;
  final _connectivity = ConnectivityResult.none.obs;
  final _position = RxPosition();

  // References
  final _locationApi = LocationApi(keys: AppServices.apiKeys);

  // ^ Initialization ^ //
  DeviceService() {
    Timer.periodic(250.milliseconds, (timer) {
      // Check if Stream has closed
      if (isClosed) {
        timer.cancel();
      }

      // Update Position
      if (AppServices.isReadyToCommunicate) {
        NodeService.update(_position.value);
      }
    });
  }

  // ^ Constructer ^ //
  Future<DeviceService> init() async {
    // Find Properties
    _device = await DeviceUtils.create();

    _connectivity(await Connectivity().checkConnectivity());
    _connectivity.bindStream(Connectivity().onConnectivityChanged);
    await Sounds.init();
    // Analytics
    if (_connectivity.value.hasInternet) {
      // Initialize Firebase
      await Firebase.initializeApp();
    }

    // Set Push Key Path
    return this;
  }

  // ^ Dispose Closer ^ //
  @override
  void onClose() {
    _position.cancel();
    super.onClose();
  }

// * ------------------- Methods ----------------------------
  /// #### Retreive Location by IP Address
  static Future<Location> get location async {
    // Check for Mobile Data
    if (to._connectivity.value == ConnectivityResult.mobile) {
      // Geolocater Position
      var pos = await Geolocator.getCurrentPosition();
      // Return Location
      return pos.toSonrLocation()..initPlacemark();
    }
    return to._locationApi.fetchIP();
  }

  /// #### Method Hides Keyboard
  static void keyboardHide() => isMobile ? SystemChannels.textInput.invokeMethod('TextInput.hide') : print("");

  /// #### Method Shows Keyboard
  static void keyboardShow() => isMobile ? SystemChannels.textInput.invokeMethod('TextInput.show') : print("");

  /// #### Saves Photo to Gallery
  static Future<bool> saveCapture(String path, bool isVideo) async {
    if (DeviceService.isMobile && isRegistered) {
      // Validate Path
      var file = File(path);
      var exists = await file.exists();
      if (!exists) {
        AppRoute.snack(SnackArgs.error("Unable to save Captured Media to your Gallery"));
        return false;
      } else {
        if (isVideo) {
          // Set Video File
          File videoFile = File(path);
          var asset = await (PhotoManager.editor.saveVideo(videoFile) as FutureOr<AssetEntity>);
          var result = await asset.exists;

          // Visualize Result
          if (result) {
            AppRoute.snack(SnackArgs.error("Unable to save Captured Photo to your Gallery"));
          }
          return result;
        } else {
          // Save Image to Gallery
          var asset = await (PhotoManager.editor.saveImageWithPath(path) as FutureOr<AssetEntity>);
          var result = await asset.exists;
          if (!result) {
            AppRoute.snack(SnackArgs.error("Unable to save Captured Video to your Gallery"));
          }
          return result;
        }
      }
    }
    return false;
  }

  /// #### Method saves file to disk
  static Future<Uint8List?> readFile(String name) async {
    // Fetch Directory, Create Path, Create File
    final dir = await getApplicationDocumentsDirectory();
    final path = dir.path + "/" + name;
    final file = File(path);

    // Return File
    var exists = await file.exists();
    if (exists) {
      return await file.readAsBytes();
    }
    return null;
  }

  /// #### Method saves file to disk
  static Future<File> writeFile(String name, Uint8List data) async {
    // Fetch Directory, Create Path, Create File
    final dir = await getApplicationDocumentsDirectory();
    final file = File(dir.path + "/" + name);
    // Write Data
    if (file.existsSync()) {
      try {
        await file.delete();
      } catch (e) {
        Logger.error(e.toString());
      }
    }

    // Return File
    return await file.writeAsBytes(data.toList());
  }
}
