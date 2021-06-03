import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sonr_app/style/style.dart';

class DesktopService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<DesktopService>();
  static DesktopService get to => Get.find<DesktopService>();

  final _storageBox = GetStorage();
  final _hasContact = false.obs;

  DesktopService() {
    Timer.periodic(1.seconds, (timer) {
      if (SonrServices.areServicesRegistered && isRegistered && SonrService.isRegistered) {
        SonrService.update(Position.create());
      }
    });
  }

  // // References
  // MainEntry _main;
  // FlutterSystray _systemTray;

  // * Initialize * //
  Future<DesktopService> init() async {
    // Load Box
    await GetStorage.init();

    if (_storageBox.hasData('contact')) {
      _hasContact(true);
    } else {
      _hasContact(false);
    }
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

  /// @ Method Saves this Device Info
  Future<void> saveContact(Contact contact) async {}

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
