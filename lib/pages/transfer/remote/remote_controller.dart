import 'package:sonr_app/style/style.dart';

class RemoteLobbyController extends GetxController {
  // Register Checks
  static bool get isRegistered => Get.isRegistered<RemoteLobbyController>();
  static bool get isNotRegistered => !isRegistered;

  // Remote Properties
  final topicLink = "".obs;
  final remoteLobby = Rx<Lobby>(Lobby());
  final remotePeerCount = 0.obs;

  // Join Remote Properties
  final joinStatus = RemoteJoinResponse_Status.None.obs;

  // # Initializes New Remote
  void initRemote(RemoteCreateResponse resp) {
    LobbyService.registerRemoteCallback(resp.topic, onRefresh);
    topicLink(resp.topic);
  }

  // @ Joins New Remote
  Future<bool> joinRemote(String link) async {
    // Attempt to Join
    RemoteJoinResponse? result = await SonrService.joinRemote(link);

    // Check Result
    if (result != null) {
      LobbyService.registerRemoteCallback(result.lobby.remote.topic, onRefresh);
      joinStatus(result.status);
      return true;
    }
    return false;
  }

  // # Handler for Remote Lobby Updates
  void onRefresh(Lobby data) {
    remotePeerCount(data.count);
    remoteLobby(data);
    remoteLobby.refresh();
  }
}
