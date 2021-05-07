import 'dart:async';

import 'package:get/get.dart';
import 'package:sonr_app/style/style.dart';
import 'package:warble/warble.dart';

class DesktopService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<DesktopService>();
  static DesktopService get to => Get.find<DesktopService>();

  // Properties
  final _isWindowOpen = true.obs;

  // Property Accessors
  static RxBool get isWindowOpen => to._isWindowOpen;

  // // References
  // MainEntry _main;
  // FlutterSystray _systemTray;

  // * Initialize * //
  Future<DesktopService> init() async {
    // // @ 1. Root Main Entry
    // _main = MainEntry(
    //   title: "Sonr",
    //   iconPath: await _getIconPath(),
    // );

    // // @ 2. Init SystemTray
    // await FlutterSystray.initSystray(_main);
    // await FlutterSystray.updateMenu([
    //   SystrayAction(name: "focus", label: "Open Window", actionType: ActionType.SystrayEvent),
    //   SystrayAction(name: "quit", label: "Quit", actionType: ActionType.Quit)
    // ]);

    // // Init Tray
    // _systemTray = FlutterSystray.init();
    return this;
  }

  /// ^ Method Plays a UI Sound ^
  static void playSound(UISoundType type) async {
    WarbleStream stream = (await (Warble.wrapAsset(rootBundle, "assets/${type.file}", buffered: true) as FutureOr<WarbleStream>));
    await stream.play();
    await stream.close();
  }

  // /// @ Add Event Handler to Tray Action
  // void registerEventHandler(String handlerKey, Function handler) {
  //   assert(_systemTray != null);
  //   _systemTray.registerEventHandler(handlerKey, handler);
  // }

  // /// @ Method Updates Tray Items
  // void update(List<SystrayAction> actions) async {
  //   await FlutterSystray.updateMenu(actions);
  // }

  // // # Helper: Returns Icon Path
  // Future<String> _getIconPath() async {
  //   // Set Temporary Directory
  //   Directory directory = await getApplicationDocumentsDirectory();
  //   String name = "";

  //   // Get File Name
  //   if (DeviceService.isWindows) {
  //     name = "tray.ico";
  //   } else {
  //     name = "tray.png";
  //   }

  //   // Load into DB
  //   var dbPath = join(directory.path, name);
  //   ByteData data = await rootBundle.load("assets/images/$name");

  //   // Write File
  //   List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  //   var file = await File(dbPath).writeAsBytes(bytes);

  //   // Return Path
  //   return file.path;
  // }
}
