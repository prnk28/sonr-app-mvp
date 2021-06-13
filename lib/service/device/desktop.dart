import 'dart:async';
import 'dart:io';

import 'package:systray/systray.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:sonr_app/style.dart';

class DesktopService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<DesktopService>();
  static DesktopService get to => Get.find<DesktopService>();

  // References
  final Position _position = Position(
      proximity: Position_Proximity.Near,
      accelerometer: Position_Accelerometer(x: 0, y: 0, z: 0),
      facing: Position_Compass(
        antiCardinal: Cardinal.S,
        cardinal: Cardinal.N,
        direction: 0,
        antipodal: 180,
      ),
      heading: Position_Compass(
        antiCardinal: Cardinal.S,
        cardinal: Cardinal.N,
        direction: 0,
        antipodal: 180,
      ),
      orientation: Position_Orientation(pitch: 0, roll: 0, yaw: 0));

  // Properties
  static Position get position => to._position;

  // Constructer
  DesktopService() {
    Timer.periodic(1.seconds, (timer) {
      if (AppServices.areServicesRegistered && isRegistered && SonrService.isRegistered) {
        SonrService.update(_position);
      }
    });
  }

  // References
  late MainEntry _main;
  late Systray _systemTray;

  // * Initialize * //
  Future<DesktopService> init() async {
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
    return this;
  }

  /// @ Add Event Handler to Tray Action
  void registerEventHandler(String handlerKey, Function handler) {
    _systemTray.registerEventHandler(handlerKey, handler);
  }

  /// @ Method Updates Tray Items
  void update(List<SystrayAction> actions) async {
    await Systray.updateMenu(actions);
  }

  // # Helper: Returns Icon Path
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
