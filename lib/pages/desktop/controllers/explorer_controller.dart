import 'dart:async';
import 'package:sonr_app/style/style.dart';

class ExplorerController extends GetxController {
  // @ Accessors
  Payload get currentPayload => inviteRequest.value.payload;

  // @ Properties
  final isNotEmpty = false.obs;
  final inviteRequest = AuthInvite().obs;
  final fileItem = Rx<SonrFile?>(null);

  // References
  late StreamSubscription<Lobby?> _lobbySizeStream;
  ScrollController scrollController = ScrollController();

  /// @ Controller Constructer
  void onInit() async {
    // Set Initial Value
    _handleLobbySizeUpdate(LobbyService.local.value);

    // Add Stream Handlers
    _lobbySizeStream = LobbyService.local.listen(_handleLobbySizeUpdate);
    super.onInit();
  }

  /// @ On Dispose
  @override
  void onClose() {
    _lobbySizeStream.cancel();
    super.onClose();
  }

  // # Handle Lobby Size Update
  _handleLobbySizeUpdate(Lobby? lobby) {
    if (lobby != null) {
      isNotEmpty(lobby.isNotEmpty);
    }
  }
}
