import 'package:sonr_app/theme/theme.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:sonr_app/data/data.dart';

enum RemoteViewStatus { NotJoined, Created, Joined, Invited, InProgress, Done }

extension RemoteViewStatusUtil on RemoteViewStatus {
  EdgeInsets get currentMargin {
    switch (this) {
      case RemoteViewStatus.NotJoined:
        return EdgeInsets.only(bottom: Get.height * 0.1, left: Get.width * 0.05, right: Get.width * 0.05);
      case RemoteViewStatus.Joined:
        return EdgeInsets.only(bottom: Get.height * 0.1, left: Get.width * 0.05, right: Get.width * 0.05);
      case RemoteViewStatus.Invited:
        return EdgeInsets.only(bottom: Get.height * 0.1, left: Get.width * 0.05, right: Get.width * 0.05);
      case RemoteViewStatus.InProgress:
        return EdgeInsets.only(bottom: Get.height * 0.1, left: Get.width * 0.05, right: Get.width * 0.05);
      case RemoteViewStatus.Done:
        return EdgeInsets.only(bottom: Get.height * 0.1, left: Get.width * 0.05, right: Get.width * 0.05);
      default:
        return EdgeInsets.only(bottom: Get.height * 0.1, left: Get.width * 0.05, right: Get.width * 0.05);
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
  // Form Properties
  final firstWord = "".obs;
  final secondWord = "".obs;
  final thirdWord = "".obs;

  // Information Properties
  final remoteInfo = Rx<RemoteInfo>(null);
  final currentInvite = Rx<AuthInvite>(null);
  final receivedCard = Rx<TransferCard>(null);

  // Status Properties
  final status = Rx<RemoteViewStatus>(RemoteViewStatus.NotJoined);
  final isJoinFieldTapped = false.obs;
  final isRemoteActive = false.obs;

  // References
  LobbyStream _lobbyStream;
  final _keyboardVisible = KeyboardVisibilityController();

  // ** Initializer ** //
  void onInit() {
    Get.find<SonrService>().registerRemoteInvite(_handleRemoteInvite);
    super.onInit();
    _keyboardVisible.onChange.listen(_handleKeyboardVisibility);
  }

  // ** Disposer ** //
  void onClose() {
    if (_lobbyStream != null) {
      _lobbyStream.close();
    }
    super.onClose();
  }

  // ^ Handle Initial Join Tap
  void handleJoinTap() {
    isJoinFieldTapped(true);
  }

  // ^ Method to Create Remote Lobby ^ //
  void create() async {
    // Start Remote
    remoteInfo(await SonrService.createRemote());
    isRemoteActive(true);
  }

  // ^ Method to End Created Remote Lobby ^ //
  void stop() async {
    // Start Remote
    SonrService.leaveRemote(remoteInfo.value);
    remoteInfo(RemoteInfo());
    isRemoteActive(false);
  }

  // ^ Method to Join New Remote Lobby ^ //
  void join() async {
    isJoinFieldTapped(false);
    remoteInfo(await SonrService.joinRemote([firstWord.value, secondWord.value, thirdWord.value]));
    status(RemoteViewStatus.Joined);
  }

  // ^ Method to Leave Current Remote Lobby ^ //
  void leave() async {
    if (remoteInfo.value != null) {
      SonrService.leaveRemote(remoteInfo.value);
      remoteInfo(null);
      currentInvite(null);
      status(RemoteViewStatus.NotJoined);
    }
  }

  // ^ Method to Respond to Invite ^ //
  void respond(bool decision) {
    if (remoteInfo.value != null && currentInvite != null) {
      // Respond Decision
      SonrService.respond(decision, info: remoteInfo.value);

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

  // @ Handle A remote Invite
  void _handleRemoteInvite(AuthInvite invite) {
    currentInvite(invite);
    status(RemoteViewStatus.Invited);
  }
}
