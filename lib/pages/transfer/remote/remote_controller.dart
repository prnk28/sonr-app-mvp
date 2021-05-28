import 'package:sonr_app/service/device/auth.dart';
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
  final receivedCard = Rx<Transfer?>(null);

  // Status Properties
  final status = Rx<RemoteViewStatus>(RemoteViewStatus.NotJoined);
  final isJoinFieldTapped = false.obs;
  final isRemoteActive = false.obs;
  final topicLink = "".obs;
  final remoteLobby = Rx<Lobby>(Lobby());

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
    // Check if Transfer Exists
    if (TransferService.hasPayload.value) {
      // Sign Mnemonic
      var data = await AuthService.signRemoteFingerprint();

      // Start Remote
      var resp = await SonrService.createRemote(file: TransferService.file.value, fingerprint: data.item1, words: data.item2);

      if (resp != null) {
        isRemoteActive(resp.success);
        topicLink(resp.topic);
      }
    }
  }

  // @ Handle Keyboard Visibility
  void _handleKeyboardVisibility(bool visible) {
    if (!visible && status.value == RemoteViewStatus.NotJoined) {
      isJoinFieldTapped(false);
    }
  }
}
