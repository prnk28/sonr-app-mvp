import 'package:sonr_app/theme/theme.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:sonr_app/data/data.dart';

enum RemoteViewStatus { NotJoined, Joined, Invited, InProgress, Done }

extension RemoteViewStatusUtil on RemoteViewStatus {
  EdgeInsets get currentMargin {
    switch (this) {
      case RemoteViewStatus.NotJoined:
        return EdgeInsets.symmetric(vertical: Get.height * 0.15, horizontal: Get.width * 0.05);
      case RemoteViewStatus.Joined:
        return EdgeInsets.symmetric(vertical: Get.height * 0.15, horizontal: Get.width * 0.05);
      case RemoteViewStatus.Invited:
        return EdgeInsets.symmetric(vertical: Get.height * 0.15, horizontal: Get.width * 0.05);
      case RemoteViewStatus.InProgress:
        return EdgeInsets.symmetric(vertical: Get.height * 0.15, horizontal: Get.width * 0.05);
      case RemoteViewStatus.Done:
        return EdgeInsets.symmetric(vertical: Get.height * 0.15, horizontal: Get.width * 0.05);
      default:
        return EdgeInsets.symmetric(vertical: Get.height * 0.15, horizontal: Get.width * 0.05);
    }
  }

  Size get currentSize {
    switch (this) {
      case RemoteViewStatus.NotJoined:
        return Size(Get.width * 0.95, Get.height * 0.85);
      case RemoteViewStatus.Joined:
        return Size(Get.width * 0.95, Get.height * 0.85);
      case RemoteViewStatus.Invited:
        return Size(Get.width * 0.95, Get.height * 0.85);
      case RemoteViewStatus.InProgress:
        return Size(Get.width * 0.95, Get.height * 0.85);
      case RemoteViewStatus.Done:
        return Size(Get.width * 0.95, Get.height * 0.85);
      default:
        return Size(Get.width * 0.95, Get.height * 0.85);
    }
  }
}

class RemoteController extends GetxController {
  final firstWord = "".obs;
  final secondWord = "".obs;
  final thirdWord = "".obs;
  final currentRemote = Rx<RemoteInfo>(null);
  final currentLobby = Rx<LobbyModel>(null);
  final currentInvite = Rx<AuthInvite>(null);
  final receivedCard = Rx<TransferCard>(null);
  final status = Rx<RemoteViewStatus>(RemoteViewStatus.NotJoined);
  final isJoinFieldTapped = false.obs;

  // References
  LobbyStream _lobbyStream;
  final _keyboardVisible = KeyboardVisibilityController();

  // ** Initializer ** //
  onInit() {
    Get.find<SonrService>().registerRemoteInvite(_handleRemoteInvite);
    super.onInit();
    _keyboardVisible.onChange.listen(_handleKeyboardVisibility);
  }

  // ** Disposer ** //
  onClose() {
    if (_lobbyStream != null) {
      _lobbyStream.close();
    }
    super.onClose();
  }

  // ^ Handle Initial Join Tap
  handleJoinTap() {
    isJoinFieldTapped(true);
  }

  // ^ Method to Join New Remote Lobby ^ //
  join() async {
    isJoinFieldTapped(false);
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

  // @ Handle Keyboard Visibility
  _handleKeyboardVisibility(bool visible) {
    if (!visible && status.value == RemoteViewStatus.NotJoined) {
      isJoinFieldTapped(false);
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
