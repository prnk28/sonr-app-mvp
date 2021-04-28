import 'dart:io';
import 'package:flutter_systray/flutter_systray.dart';
import 'package:get/get.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sonr_app/theme/theme.dart';

class DesktopService extends GetxService {
  MainEntry _main;
  FlutterSystray _systemTray;

  final _platform = Rx<Platform>(null);

  // Platform Checkers
  static bool get isLinux => Get.find<DesktopService>()._platform.value == Platform.Linux;
  static bool get isMacOS => Get.find<DesktopService>()._platform.value == Platform.MacOS;
  static bool get isWindows => Get.find<DesktopService>()._platform.value == Platform.Windows;

  Future<DesktopService> init() async {
    // @ 1. Set Platform
    if (io.Platform.isAndroid) {
      _platform(Platform.Android);
    } else if (io.Platform.isIOS) {
      _platform(Platform.IOS);
    } else if (io.Platform.isLinux) {
      _platform(Platform.Linux);
    } else if (io.Platform.isMacOS) {
      _platform(Platform.MacOS);
    } else if (io.Platform.isWindows) {
      _platform(Platform.Windows);
    }

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
    if (isWindows) {
      return absolute('go\\assets', 'tray.ico');
    } else {
      return absolute('go/assets', 'tray.png');
    }
  }
}
