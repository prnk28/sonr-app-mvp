import 'dart:io';
import 'package:flutter_systray/flutter_systray.dart';
import 'package:path/path.dart';

class SonrTray {
  MainEntry _main;
  FlutterSystray _systemTray;

  // ^ Initialize System Tray ^ //
  static Future<SonrTray> init() async {
    var tray = SonrTray();
    // root Systray entry
    tray._main = MainEntry(
      title: "Sonr",
      iconPath: tray._getIconPath(),
    );

    // We first init the systray menu and then add the menu entries
    await FlutterSystray.initSystray(tray._main);
    await FlutterSystray.updateMenu([
      SystrayAction(name: "focus", label: "Focus", actionType: ActionType.Focus),
      SystrayAction(name: "counterEvent", label: "Counter event", actionType: ActionType.SystrayEvent),
      SystrayAction(name: "systrayEvent2", label: "Event 2", actionType: ActionType.SystrayEvent),
      SystrayAction(name: "quit", label: "Quit", actionType: ActionType.Quit)
    ]);

    // Init Tray
    tray._systemTray = FlutterSystray.init();
    return tray;
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
      return absolute('go\\assets', 'icon.ico');
    } else {
      return absolute('go/assets', 'icon.png');
    }
  }
}
