import 'package:sonr_core/sonr_core.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonar_app/controller/sonr/conn_controller.dart';

class LobbyController extends GetxController {
  final code = "".obs;
  final size = 0.obs;
  final peers = Rx<Map<String, Peer>>();

  // ^ Assign Callbacks ^ //
  void assign() {
    sonrNode.assignCallback(CallbackEvent.Refreshed, handleRefresh);
  }

  void handleRefresh(dynamic data) {
    // Check Type
    if (data is Lobby) {
      code(data.code);
      size(data.size);
      peers(data.peers);
    } else {
      print("handleRefreshed() - " + "Invalid Return type");
    }
  }
}
