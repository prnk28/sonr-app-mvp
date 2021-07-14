import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sonr_app/style/style.dart';

class Preferences extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<Preferences>();
  static Preferences get to => Get.find<Preferences>();

  // Preferences
  final _properties = Peer_Properties().obs;
  final _isDarkMode = false.val('isDarkMode', getBox: () => GetStorage('Preferences'));
  final _hasFlatMode = true.val('flatModeEnabled', getBox: () => GetStorage('Preferences'));
  final _hasPointToShare = true.val('pointToShareEnabled', getBox: () => GetStorage('Preferences'));

  static bool get isDarkMode => to._isDarkMode.val;
  static bool get flatModeEnabled => to._hasFlatMode.val;
  static bool get pointShareEnabled => to._hasPointToShare.val;
  static Rx<Peer_Properties> get properties => to._properties;

  Future<Preferences> init() async {
    await GetStorage.init('Preferences');
    _properties(Peer_Properties(
      enabledPointShare: _hasPointToShare.val,
    ));
    // Set Theme
    AppTheme.setDarkMode(isDark: _isDarkMode.val);
    return this;
  }

  /// #### Sets Properties for Node
  static void setFlatMode(bool isFlatMode) async {
    if (NodeService.isReady) {
      if (to._properties.value.isFlatMode != isFlatMode) {
        to._properties(Peer_Properties(enabledPointShare: Preferences.pointShareEnabled, isFlatMode: isFlatMode));
        NodeService.instance.update(
          API.newUpdateProperties(to._properties.value),
        );
      }
    }
  }

  /// #### Trigger iOS Local Network with Alert
  static toggleDarkMode() => AppTheme.setDarkMode(isDark: to._isDarkMode.val = !to._isDarkMode.val);

  /// #### Trigger iOS Local Network with Alert
  static toggleFlatMode() => to._hasFlatMode.val = !to._hasFlatMode.val;

  /// #### Trigger iOS Local Network with Alert
  static togglePointToShare() => to._hasPointToShare.val = !to._hasPointToShare.val;
}
