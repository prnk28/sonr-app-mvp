import 'dart:io';
import 'package:flutter_systray/flutter_systray.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sonr_app/data/model/model_location.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:http/http.dart' as http;

class DesktopService extends GetxService {
  // References
  MainEntry _main;
  FlutterSystray _systemTray;

  // * Initialize * //
  Future<DesktopService> init() async {
    // @ 1. Root Main Entry
    _main = MainEntry(
      title: "Sonr",
      iconPath: await _getIconPath(),
    );

    // @ 2. Init SystemTray
    await FlutterSystray.initSystray(_main);
    await FlutterSystray.updateMenu([
      SystrayAction(name: "focus", label: "Open", actionType: ActionType.Focus),
      SystrayAction(name: "counterEvent", label: "Counter", actionType: ActionType.SystrayEvent),
      SystrayAction(name: "quit", label: "Quit", actionType: ActionType.Quit)
    ]);

    // Init Tray
    _systemTray = FlutterSystray.init();
    return this;
  }

  static Future<Location> currentLocation() async {
    var url = Uri.parse('http://api.ipstack.com/check?access_key=28da32809f3bcd2edc418d62802d1fc6');
    var response = await http.get(url);
    var geoIp = GeoIP.fromResponse(response.body);
    return Location(latitude: geoIp.latitude, longitude: geoIp.longitude);
  }

  /// @ Add Event Handler to Tray Action
  void registerEventHandler(String handlerKey, Function handler) {
    assert(_systemTray != null);
    _systemTray.registerEventHandler(handlerKey, handler);
  }

  /// @ Method Updates Tray Items
  void update(List<SystrayAction> actions) async {
    await FlutterSystray.updateMenu(actions);
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
