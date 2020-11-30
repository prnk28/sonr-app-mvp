import 'package:sonr_core/sonr_core.dart';
import 'package:get/get.dart' hide Node;

class LobbyController extends GetxController {
  final code = "".obs;
  final size = 0.obs;
  final peers = Rx<Map<String, Peer>>();

  void refreshLobby(Lobby lobby) {
    // Validate Code
    if (code.value != lobby.code) {
      code(lobby.code);
    }

    // Validate Size
    if (size.value != lobby.size) {
      size(lobby.size);
    }

    // Update Peers
    peers(lobby.peers);
  }
}
