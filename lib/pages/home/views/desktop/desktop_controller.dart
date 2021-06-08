import 'package:sonr_app/style.dart';

class DesktopController extends GetxController {
  // @ Accessors
  Payload get currentPayload => inviteRequest.value.payload;

  // @ Properties
  final isNotEmpty = false.obs;
  final inviteRequest = AuthInvite().obs;
  final scrollController = ScrollController();

  /// Choose File
  Future<void> chooseFile(Peer peer) async {
    bool selected = await TransferService.chooseFile();
    if (selected) {
      TransferService.sendInviteToPeer(peer);
    }
  }
}
