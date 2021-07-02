import 'dart:async';
import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/env.dart';
import 'package:sonr_app/pages/transfer/transfer.dart';
import 'package:sonr_app/style/style.dart';

class ComposeController extends GetxController with StateMixin<Session> {
  // Properties
  final composeStatus = ComposeStatus.Initial.obs;

  // API Managers
  final _records = RxList<HSRecord>();
  final _nbClient = NamebaseApi(
    hsKey: Env.hs_key,
    hsSecret: Env.hs_secret,
  );

  // References
  Peer? _peerRef;

  @override
  void onInit() {
    _refreshRecords();
    change(Session(), status: RxStatus.empty());
    super.onInit();
  }

  /// @ Check if Name Value is Value
  Future<void> checkName(String sName) async {
    // Refresh Records
    await _refreshRecords();

    // Search Record
    final record = _records.firstWhere(
      (e) => e.equalsName(sName) && e.isName,
      orElse: () => HSRecord.blank(),
    );

    // Validate Record
    if (record.isName) {
      _peerRef = record.toPeer();
      if (_peerRef != null) {
        composeStatus(ComposeStatus.Existing);
      }
    }
    composeStatus(ComposeStatus.NonExisting);
  }

  /// @ User Sends A Remote Transfer Name Request
  Future<void> shareRemote() async {
    // Create Session
    if (_peerRef != null) {
      // Create New Session
      var newSession = SenderService.invite(InviteRequestUtils.copyWithPeer(TransferController.invite, _peerRef!));

      // Change Session for Status
      change(newSession, status: RxStatus.success());
    }
  }

  Future<void> _refreshRecords() async {
    if (DeviceService.hasInterent) {
      final result = await _nbClient.refresh();
      _records(result.records);
      _records.refresh();
    }
  }
}
