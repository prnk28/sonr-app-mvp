import 'package:sonr_app/style/style.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

enum RemoteViewStatus { NotJoined, Created, Joined, Invited, InProgress, Done }

extension RemoteViewStatusUtil on RemoteViewStatus {
  bool get isDefault => this == RemoteViewStatus.NotJoined;
  bool get isCreated => this == RemoteViewStatus.Created;
  bool get isJoined => this == RemoteViewStatus.Joined;
  bool get isInRemote => this == RemoteViewStatus.Created || this == RemoteViewStatus.Joined;
}

class RemoteController extends GetxController {
  // Form Properties
  final firstWord = "".obs;
  final secondWord = "".obs;
  final thirdWord = "".obs;

  // Information Properties
  final remoteResponse = Rx<RemoteResponse?>(null);
  final currentInvite = Rx<AuthInvite?>(null);
  final receivedCard = Rx<Transfer?>(null);

  // Status Properties
  final status = Rx<RemoteViewStatus>(RemoteViewStatus.NotJoined);
  final isJoinFieldTapped = false.obs;
  final isRemoteActive = false.obs;

  final remoteLobby = Rx<Lobby?>(null);

  // References
  final _keyboardVisible = KeyboardVisibilityController();

  // ** Initializer ** //
  void onInit() {
    super.onInit();
    _keyboardVisible.onChange.listen(_handleKeyboardVisibility);
  }

  // ** Disposer ** //
  void onClose() {
    super.onClose();
  }

  /// @ Handle Initial Join Tap
  void handleJoinTap() {
    isJoinFieldTapped(true);
  }

  /// @ Method to Create Remote Lobby
  void create() async {
    // Start Remote
    remoteResponse(await SonrService.createRemote());
    isRemoteActive(true);
    LobbyService.registerRemoteCallback(remoteResponse.value, _handleRemoteLobby);
  }

  /// @ Method to End Created Remote Lobby
  void stop() async {
    if (remoteResponse.value != null) {
      // Start Remote
      SonrService.leaveRemote(remoteResponse.value!);
      remoteResponse(RemoteResponse());
      isRemoteActive(false);
    }

    if (remoteLobby.value != null) {
      LobbyService.unregisterRemoteCallback(remoteLobby.value!);
    }
  }

  /// @ Method to Join New Remote Lobby
  void join() async {
    isJoinFieldTapped(false);
    remoteResponse(await SonrService.joinRemote([firstWord.value, secondWord.value, thirdWord.value]));
    status(RemoteViewStatus.Joined);
  }

  /// @ Method to Leave Current Remote Lobby
  void leave() async {
    if (remoteResponse.value != null) {
      SonrService.leaveRemote(remoteResponse.value!);
      remoteResponse(null);
      currentInvite(null);
      status(RemoteViewStatus.NotJoined);
    }

    if (remoteLobby.value != null) {
      LobbyService.unregisterRemoteCallback(remoteLobby.value!);
    }
  }

  /// @ Method to Respond to Invite
  void respond(bool decision, Peer peer) {
    if (remoteResponse.value != null && currentInvite.value != null) {
      // Respond Decision
      SonrService.respond(Request.newReplyRemote(to: peer, decision: decision));

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
  void _handleKeyboardVisibility(bool visible) {
    if (!visible && status.value == RemoteViewStatus.NotJoined) {
      isJoinFieldTapped(false);
    }
  }

  void _handleRemoteLobby(Lobby lobby) {
    remoteLobby(lobby);
  }
}
