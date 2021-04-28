import 'dart:io';
import 'package:flutter_systray/flutter_systray.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

class DesktopService extends GetxService {
  MainEntry _main;
  FlutterSystray _systemTray;

  Future<DesktopService> init() async {
    // root Systray entry
    _main = MainEntry(
      title: "Sonr",
      iconPath: _getIconPath(),
    );

    // We first init the systray menu and then add the menu entries
    await FlutterSystray.initSystray(_main);
    await FlutterSystray.updateMenu([
      SystrayAction(name: "focus", label: "Focus", actionType: ActionType.Focus),
      SystrayAction(name: "counterEvent", label: "Counter event", actionType: ActionType.SystrayEvent),
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
    if (Platform.isWindows) {
      return absolute('go\\assets', 'tray.ico');
    } else {
      return absolute('go/assets', 'tray.png');
    }
  }
}
