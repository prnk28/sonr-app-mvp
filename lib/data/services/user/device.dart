import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path/path.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sonr_app/env.dart';
import 'package:sonr_app/style.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:sonr_app/data/services/services.dart';
import 'package:systray/systray.dart';

class DeviceService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<DeviceService>();
  static DeviceService get to => Get.find<DeviceService>();

  // Properties
  final _device = Device().obs;
  final _location = Location().obs;
  final _connectivity = ConnectivityResult.none.obs;

  // Mobile Platform Controllers/Properties
  final _audioPlayer = AudioCache(prefix: 'assets/sounds/', respectSilence: true);
  final _position = RxPosition();

  // Platform Checkers
  static bool get hasInternet => to._connectivity.value != ConnectivityResult.none;
  static bool get isDesktop => to._device.value.platform.isDesktop;
  static bool get isMobile => to._device.value.platform.isMobile;
  static bool get isAndroid => to._device.value.platform.isAndroid;
  static bool get isIOS => to._device.value.platform.isIOS;
  static bool get isLinux => to._device.value.platform.isLinux;
  static bool get isMacOS => to._device.value.platform.isMacOS;
  static bool get isWindows => to._device.value.platform.isWindows;

  // Property Accessors
  static Rx<ConnectivityResult> get connectivity => to._connectivity;
  static Device get device => to._device.value;
  static Location get location => to._location.value;
  static Platform get platform => to._device.value.platform;
  static RxPosition get position => to._position;

  // References
  late MainEntry _main;
  late Systray _systemTray;

  DeviceService() {
    Timer.periodic(250.milliseconds, (timer) {
      if (AppServices.areServicesRegistered && isRegistered && NodeService.isRegistered) {
        NodeService.update(_position.value);
      }
    });
  }

  // * Device Service Initialization * //
  Future<DeviceService> init() async {
    // Set Properties
    var platform = PlatformUtils.find();
    var directories = await Request.getDirectories(platform);
    _connectivity.bindStream(Connectivity().onConnectivityChanged);

    // Initialize Device
    _device.update((val) async {
      if (val != null) {
        // Set Platform
        val.platform = platform;
        val.fileSystem = directories;

        // Set ID
        if (platform.isDesktop) {
          var deviceId = await PlatformDeviceId.getDeviceId;
          if (deviceId != null) {
            val.id = deviceId;
          }
        }
      }
    });

    // @ Setup Mobile
    if (platform.isMobile) {
      // @ Bind Sensors for Mobile
      // Audio Player
      await _audioPlayer.loadAll(List<String>.generate(Sounds.values.length, (index) => Sounds.values[index].file));
    }

    // @ Setup Desktop
    else {
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
    }
    return this;
  }

  // * Close Streams * //
  @override
  void onClose() {
    _position.cancel();
    super.onClose();
  }

  /// @ Retreive Location by IP Address
  static Future<Location> findLocation(Platform platform) async {
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
        return Location(longitude: pos.longitude, latitude: pos.latitude);
      }
    }

    // # IP Based Location for ALL Devices
    var url = Uri.parse("https://find-any-ip-address-or-domain-location-world-wide.p.rapidapi.com/iplocation?apikey=${Env.ip_key}");

    final response = await http.get(url, headers: {'x-rapidapi-key': Env.rapid_key, 'x-rapidapi-host': Env.rapid_host});

    if (response.statusCode == 200) {
      // Analytics
      Logger.event(
        controller: 'DeviceService',
        name: '[DeviceService]: Find-Location',
        parameters: {
          'createdAt': DateTime.now().toString(),
          'platform': platform.toString(),
          'isMobile': platform.isMobile,
          'type': 'IP-Location',
        },
      );

      // Decode Json
      var json = jsonDecode(response.body);
      return Location(
        state: json["state"],
        continent: json["continent"],
        country: json["country"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );
    } else {
      throw Exception('Failed to Fetch Geolocation IP');
    }
  }

  /// @ Method Hides Keyboard
  static void keyboardHide() => isMobile ? SystemChannels.textInput.invokeMethod('TextInput.hide') : print("");

  /// @ Method Shows Keyboard
  static void keyboardShow() => isMobile ? SystemChannels.textInput.invokeMethod('TextInput.show') : print("");

  /// @ Method Plays a UI Sound
  static void playSound({required Sounds type}) async {
    if (isMobile) {}
  }

  /// @ Add Event Handler to Tray Action
  void registerEventHandler(String handlerKey, Function handler) {
    _systemTray.registerEventHandler(handlerKey, handler);
  }

  /// @ Method Updates Tray Items
  void updateSystray(List<SystrayAction> actions) async {
    await Systray.updateMenu(actions);
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

  // # Returns Icon Path
  Future<String> _getIconPath() async {
    // Set Temporary Directory
    Directory directory = await getApplicationDocumentsDirectory();
    String name = "";

    // Get File Name
    if (DeviceService.isWindows) {
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
