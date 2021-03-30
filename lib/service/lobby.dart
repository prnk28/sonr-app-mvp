import 'dart:async';
import 'package:get/get.dart' hide Node;
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

class LobbyService extends GetxService {
  // @ Set Properties
  final _isReady = false.obs;
  final _lobbies = RxMap<String, Lobby>();
  final _local = Rx<Lobby>();

  // @ Static Accessors
  static RxBool get isReady => Get.find<LobbyService>()._isReady;
  static RxMap<String, Lobby> get lobbies => Get.find<LobbyService>()._lobbies;
  static Rx<Lobby> get local => Get.find<LobbyService>()._local;

  // ^ Initialize Service Method ^ //
  Future<LobbyService> init() async {
    return this;
  }

  // ^ Handle Lobby Update ^ //
  void handleRefresh(Lobby data) {
    if (data.isLocal) {
      _local(data);
      _local.refresh();
    } else {
      _lobbies[data.name] = data;
      _lobbies.refresh();
    }
  }
}
