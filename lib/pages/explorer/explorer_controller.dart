import 'package:sonr_app/style.dart';

class ExplorerController extends GetxController {
  // @ Accessors
  Payload get currentPayload => inviteRequest.value.payload;

  // @ Properties
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
