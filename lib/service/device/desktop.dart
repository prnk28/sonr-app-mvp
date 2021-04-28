import 'package:flutter_systray/flutter_systray.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sonr_app/theme/theme.dart';

class DesktopService extends GetxService {
  // References
  MainEntry _main;
  FlutterSystray _systemTray;

  // * Initialize * //
  Future<DesktopService> init() async {
    // @ 2. Root Main Entry
    _main = MainEntry(
      title: "Sonr",
      iconPath: _getIconPath(),
    );

    // @ 3. Init SystemTray
    await FlutterSystray.initSystray(_main);
    await FlutterSystray.updateMenu([
      SystrayAction(name: "focus", label: "Open", actionType: ActionType.Focus),
      SystrayAction(name: "counterEvent", label: "Counter", actionType: ActionType.SystrayEvent),
      SystrayAction(name: "systrayEvent2", label: "Event 2", actionType: ActionType.SystrayEvent),
      SystrayAction(name: "quit", label: "Quit", actionType: ActionType.Quit)
    ]);

    // Init Tray
    _systemTray = FlutterSystray.init();
    return this;
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
  String _getIconPath() {
    if (DeviceService.isWindows) {
      return absolute('go\\assets', 'tray.ico');
    } else {
      return absolute('go/assets', 'tray.png');
    }
  }
}
