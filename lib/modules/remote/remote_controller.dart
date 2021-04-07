import 'package:sonr_app/theme/theme.dart';

enum RemoteViewStatus { NotJoined, Joined, Invited, InProgress, Done }

class RemoteController extends GetxController {
  final firstWord = "".obs;
  final secondWord = "".obs;
  final thirdWord = "".obs;
  final currentRemote = Rx<RemoteInfo>();
  final currentLobby = Rx<LobbyModel>();
  final currentInvite = Rx<AuthInvite>();
  final receivedCard = Rx<TransferCard>();
  final status = Rx<RemoteViewStatus>(RemoteViewStatus.NotJoined);

  // References
  LobbyStream _lobbyStream;

  // ** Initializer ** //
  onInit() {
    Get.find<SonrService>().registerRemoteInvite(_handleRemoteInvite);
    super.onInit();
  }

  // ** Disposer ** //
  onClose() {
    if (_lobbyStream != null) {
      _lobbyStream.close();
    }
    super.onClose();
  }

  // ^ Method to Join New Remote Lobby ^ //
  join() async {
    currentRemote(await SonrService.joinRemote([firstWord.value, secondWord.value, thirdWord.value]));
    _lobbyStream = LobbyService.listenToLobby(currentRemote.value);
    _lobbyStream.listen(_handleLobby);
    status(RemoteViewStatus.Joined);
  }

  // ^ Method to Leave Current Remote Lobby ^ //
  leave() async {
    if (currentRemote.value != null) {
      SonrService.leaveRemote(currentRemote.value);
      currentRemote(null);
      currentInvite(null);
      status(RemoteViewStatus.NotJoined);
    }
  }

  // ^ Method to Respond to Invite ^ //
  respond(bool decision) {
    if (currentRemote.value != null && currentInvite != null) {
      // Respond Decision
      SonrService.respond(decision, info: currentRemote.value);

      // Wait for Complete if Accepted
      if (decision) {
        // Set Status
        status(RemoteViewStatus.InProgress);

        // Wait for Completion
        SonrService.completed().then((value) {
          receivedCard(value);
          status(RemoteViewStatus.Done);
        });
      }

      // Reset if Declined
      else {
        status(RemoteViewStatus.Joined);
        currentInvite(null);
        return;
      }
    }
  }

  // @ Handle Lobby Info
  _handleLobby(LobbyModel lobby) {
    currentLobby(lobby);
    currentLobby.refresh();
  }

  // @ Handle A remote Invite
  _handleRemoteInvite(AuthInvite invite) {
    currentInvite(invite);
    status(RemoteViewStatus.Invited);
  }
}
