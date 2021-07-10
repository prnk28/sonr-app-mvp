import 'dart:async';
import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/pages/transfer/transfer.dart';
import 'package:sonr_app/style/style.dart';

class ComposeController extends GetxController with StateMixin<Session> {
  // Properties
  final composeStatus = ComposeStatus.Initial.obs;

  // API Managers
  final _records = RxList<HSRecord>();
  final _nbClient = NamebaseApi(keys: AppServices.apiKeys);
  final _query = "".obs;
  final shouldUpdate = false.obs;

  @override
  void onInit() {
    _refreshRecords();
    change(Session(), status: RxStatus.empty());
    super.onInit();
  }

  /// @ Check if Name Value is Value
  Future<HSRecord?> checkName(String sName, {bool withShare = false}) async {
    _query(sName);
    if (withShare) {
      await shareRemote();
    }
    return null;
  }

  /// @ User Sends A Remote Transfer Name Request
  Future<bool> shareRemote() async {
    // Search Record
    await _refreshRecords();
    final record = _records.firstWhere(
      (e) => e.equalsName(_query.value),
      orElse: () => HSRecord.blank(),
    );

    if (record.toPeer() != null) {
      print("Valid Peer");

      // Find Peer
      final peer = record.toPeer()!;
      print(peer.toString());

      // Change Session for Status Success
      var newSession = SenderService.invite(InviteRequestUtils.copy(TransferController.invite, peer: peer, type: InviteRequest_Type.Remote));
      composeStatus(ComposeStatus.Existing);
      change(newSession, status: RxStatus.success());
      return true;
    }
    // Change Session for Status Error
    else {
      change(Session(), status: RxStatus.error());
      composeStatus(ComposeStatus.NonExisting);
      return false;
    }
  }

  Future<void> _refreshRecords() async {
    if (DeviceService.hasInternet) {
      final result = await _nbClient.refresh();
      _records(result.records);
      _records.refresh();
    }
  }
}
