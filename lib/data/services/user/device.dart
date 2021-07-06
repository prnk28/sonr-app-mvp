import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path/path.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sonr_app/style/style.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:sonr_app/data/services/services.dart';
import 'package:systray/systray.dart';

class DeviceService extends GetxService {
  // Accessors
  static bool get hasInternet => to._connectivity.value.hasInternet;
  static bool get isRegistered => Get.isRegistered<DeviceService>();
  static DeviceService get to => Get.find<DeviceService>();

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
  late MainEntry _main;
  late Systray _systemTray;
  final _locationApi = LocationApi(keys: AppServices.apiKeys);

  // ^ Initialization ^ //
  DeviceService() {
    Timer.periodic(250.milliseconds, (timer) {
      if (AppServices.isReadyToCommunicate) {
        NodeService.update(_position.value);
      }
    });
  }

  // ^ Constructer ^ //
  Future<DeviceService> init() async {
    // Find Properties
    _device = await DeviceUtils.create();

    // Initialize Device
    _connectivity(await Connectivity().checkConnectivity());
    _connectivity.bindStream(Connectivity().onConnectivityChanged);

    // @ Setup Desktop
    if (platform.isDesktop) {
      // @ 1. Root Main Entry
      _main = MainEntry(
        title: "Sonr",
        iconPath: await _getIconPath(),
      );

      // @ 2. Init SystemTray
      await Systray.initSystray(_main);
      await Systray.updateMenu([
        SystrayAction(name: "focus", label: "Open Window", actionType: ActionType.SystrayEvent),
        SystrayAction(name: "quit", label: "Quit", actionType: ActionType.Quit)
      ]);

      // Init Tray
      _systemTray = Systray.init();
    } else {
      if (_connectivity.value.hasInternet) {
        // Initialize Firebase
        await Firebase.initializeApp();
      }
    }
    await Sounds.init();
    return this;
  }

  // ^ Dispose Closer ^ //
  @override
  void onClose() {
    _position.cancel();
    super.onClose();
  }

// * ------------------- Methods ----------------------------
  /// @ Retreive Location by IP Address
  static Future<Location> get location async {
    // # Check Platform
    if (platform.isMobile) {
      // Check for Mobile Data
      if (to._connectivity.value == ConnectivityResult.mobile) {
        // Geolocater Position
        var pos = await Geolocator.getCurrentPosition();

        // Analytics
        Logger.event(
          name: 'findLocation',
          controller: 'DeviceService',
          parameters: {
            'createdAt': DateTime.now().toString(),
            'platform': platform.toString(),
            'isMobile': platform.isMobile,
            'type': 'GPS-Location',
          },
        );

        // Return Location
        return pos.toSonrLocation();
      }
    }
    // Analytics
    Logger.event(
      name: 'findLocation',
      controller: 'DeviceService',
      parameters: {
        'createdAt': DateTime.now().toString(),
        'platform': platform.toString(),
        'isMobile': platform.isMobile,
        'type': 'IP-Location',
      },
    );

    return to._locationApi.fetchIP();
  }

  /// @ Method Hides Keyboard
  static void keyboardHide() => isMobile ? SystemChannels.textInput.invokeMethod('TextInput.hide') : print("");

  /// @ Method Shows Keyboard
  static void keyboardShow() => isMobile ? SystemChannels.textInput.invokeMethod('TextInput.show') : print("");

  /// @ Add Event Handler to Tray Action
  void registerEventHandler(String handlerKey, Function handler) {
    _systemTray.registerEventHandler(handlerKey, handler);
  }

  /// @ Saves Photo to Gallery
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

  /// @ Method Updates Tray Items
  void updateSystray(List<SystrayAction> actions) async {
    await Systray.updateMenu(actions);
  }

// * ------------------- Helpers ----------------------------
  // # Returns Icon Path
  Future<String> _getIconPath() async {
    // Set Temporary Directory
    Directory directory = await getApplicationDocumentsDirectory();
    String name = "";

    // Get File Name
    if (platform.isWindows) {
      name = "tray.ico";
    } else {
      name = "tray.png";
    }

    // Load into DB
    var dbPath = join(directory.path, name);
    ByteData data = await rootBundle.load("assets/images/$name");

    // Write File
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var file = await File(dbPath).writeAsBytes(bytes);

    // Return Path
    return file.path;
  }
}
