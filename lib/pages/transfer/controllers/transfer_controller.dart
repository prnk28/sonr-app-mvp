import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/pages/transfer/transfer.dart';
import 'package:sonr_app/pages/transfer/views/composer_view.dart';
import 'package:sonr_app/style/style.dart';

class TransferController extends GetxController {
  // @ Global Property Accessor
  static InviteRequest get invite => Get.find<TransferController>().inviteRequest;

  // @ Properties
  final title = "Nobody Here".obs;
  final isFacingPeer = false.obs;
  final composeStatus = ComposeStatus.Initial.obs;

  // @ API Managers
  final findQuery = "".obs;
  final shouldUpdate = false.obs;

  // @ Direction Properties
  final desktopsEnabled = true.obs;
  final hasInvite = false.obs;
  final phonesEnabled = true.obs;

  // References
  final localArrowButtonKey = GlobalKey();
  final scrollController = ScrollController();
  late InviteRequest inviteRequest;

  /// #### First Method Called
  void initialize({InviteRequest? request}) {
    // Manual Injection
    if (request != null) {
      inviteRequest = request;
      hasInvite(true);
    } else {
      // Fetch from Arguments
      final args = Get.arguments;
      if (args is TransferArguments) {
        inviteRequest = args.request;
        hasInvite(true);
      } else {
        hasInvite(false);
      }
    }
  }

  /// #### Closes Window for Transfer Page
  void onLocalArrowPressed() {
    AppRoute.positioned(
      Checklist(
          options: [
            ChecklistOption("Phones", phonesEnabled),
            ChecklistOption("Desktops", desktopsEnabled),
          ],
          onSelectedOption: (index) {
            print(index);
          }),
      offset: Offset(-80, -10),
      parentKey: localArrowButtonKey,
    );
  }

  void onRemotePressed() {
    AppRoute.popup(InviteComposer());
  }

  void onQueryUpdated(String query) {
    findQuery(query);
    findQuery.refresh();
  }

  /// #### User is Facing or No longer Facing a Peer
  void setFacingPeer(bool value) {
    isFacingPeer(value);
    isFacingPeer.refresh();
  }

  /// #### User Sends A Remote Transfer Name Request
  Future<bool> shareRemote() async {
    // Search Record
    final peer = await NamebaseClient.findPeerRecord(findQuery.value);

    // Validate Peer
    if (peer != null) {
      print(peer.toString());
      // Change Session for Status Success
      SenderService.invite(InviteRequestUtils.copy(TransferController.invite, peer: peer, type: InviteRequest_Type.Remote));
      composeStatus(ComposeStatus.Existing);
      shouldUpdate(true);
      return true;
    } else {
      // Print Records
      await NamebaseClient.printRecords();

      // Change Session for Status Error
      composeStatus(ComposeStatus.NonExisting);
      shouldUpdate(false);
      return false;
    }
  }
}
