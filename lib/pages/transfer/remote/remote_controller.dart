import 'package:sonr_app/service/device/auth.dart';
import 'package:sonr_app/style/style.dart';

enum RemoteViewStatus { NotJoined, Created, Invited, InProgress, Done }

extension RemoteViewStatusUtil on RemoteViewStatus {
  bool get isDefault => this == RemoteViewStatus.NotJoined;
  bool get isCreated => this == RemoteViewStatus.Created;
  bool get isInRemote => this == RemoteViewStatus.Created;
}

class RemoteController extends GetxController {
  // Status Properties
  final status = Rx<RemoteViewStatus>(RemoteViewStatus.NotJoined);
  final topicLink = "".obs;
  final remoteLobby = Rx<Lobby>(Lobby());
  final remotePeerCount = 0.obs;

  // ** Initializer ** //
  void onInit() {
    super.onInit();
  }

  // ** Disposer ** //
  void onClose() {
    super.onClose();
  }
}
