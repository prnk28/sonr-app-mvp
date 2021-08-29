import 'package:sonr_app/data/services/services.dart';
import 'dart:async';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_app/pages/transfer/transfer.dart';

/// #### Reactive Controller for Peer Bubble
class PeerController extends GetxController with StateMixin<Session> {
  // Reactive Elements
  final counter = 0.0.obs;
  final isComplete = false.obs;
  final opacity = 0.85.obs;
  final peer = Rx<Peer>(Peer());

  // Vector Properties
  final isHitting = false.obs;
  final relative = 0.0.obs;
  final relativePosition = RelativePosition.Center.obs;
  final borderWidth = 0.0.obs;
  final buttonData = DynamicSolidButtonData.invite().obs;
  final Rx<SessionStatus?> sessionStatus = SessionStatus.Default.obs;

  // References
  late final Session session;
  late final Member member;
  StreamSubscription<Position>? _userStream;
  bool _handlingHit = false;
  bool _hasInvited = false;
  bool get isHittingValid => peer.value.isHitFrom(DeviceService.position.value);

  // State Machine
  PeerController();

  @override
  void onInit() {
    change(Session(), status: RxStatus.empty());
    super.onInit();
  }

  /// #### Method that Initializes Peer and Streams
  void initalize(Member data, {bool setAnimated = true}) async {
    // Set Initial
    peer(data.active);
    member = data;

    // Add Stream Handlers
    LobbyService.registerPeerCallback(peer.value, _handlePeerUpdate);

    // Check for Mobile
    if (DeviceService.isMobile) {
      _userStream = DeviceService.position.listen(_handlePosition);
    }
  }

  /// ** Dispose on Close ** //
  @override
  void onClose() {
    LobbyService.unregisterPeerCallback(peer.value);
    if (_userStream != null) {
      _userStream!.cancel();
    }
    super.onClose();
  }

  /// #### Handle User Invitation
  void invite() {
    // Check Animated
    // Handle Mobile Invite - Payload Set
    if (SenderService.hasSelected.value) {
      // Check not already Pending
      if (!_hasInvited) {
        // Perform Invite
        var invite = InviteRequestUtils.copy(
          TransferController.inviteRequest,
          member: this.member,
        );

        // Create Session
        var newSession = SenderService.invite(invite);
        if (newSession != null) {
          // Set Session
          session = newSession;
          sessionStatus.bindStream(session.status.stream);
          change(session, status: RxStatus.loading());
          _hasInvited = true;
          sessionStatus.listen(_handleTransferStatus);
        }
      }
    }
    // Handle Other Invite - Payload NOT Set
    else {
      // Choose File then Set Session
      SenderService.choose(ChooseOption.File).then((value) {
        if (value != null) {
          // Set Peer for Invite
          value.setMember(this.member);

          // Create Session
          var newSession = SenderService.invite(value);
          if (newSession != null) {
            // Set Session
            session = newSession;
            sessionStatus.bindStream(session.status.stream);
            change(session, status: RxStatus.loading());

            // Listen to Session
            session.status.listen(_handleTransferStatus);
            _hasInvited = true;
            sessionStatus.listen(_handleTransferStatus);
          }
        }
      });
    }
  }

  /// #### Handle Peer Position
  void _handlePeerUpdate(Peer data) {
    if (!isClosed && !isComplete.value) {
      // Update Direction
      if (data.id.peer == peer.value.id.peer && status != RxStatus.loading() || status != RxStatus.loadingMore() || status != RxStatus.success()) {
        peer(data);
      }
    }
  }

  // @ Handle Peer Response
  void _handleTransferStatus(SessionStatus? data) {
    if (data != null) {
      // Update Opacity
      opacity(data.opacity());

      // Set Animation
      switch (data) {
        case SessionStatus.Pending:
          change(session, status: RxStatus.loading());
          buttonData(DynamicSolidButtonData.pending());
          buttonData.refresh();
          break;
        case SessionStatus.Accepted:
          change(session, status: RxStatus.success());
          buttonData(DynamicSolidButtonData.inProgress());
          buttonData.refresh();
          break;
        case SessionStatus.Denied:
          change(session, status: RxStatus.error());
          break;
        case SessionStatus.InProgress:
          change(session, status: RxStatus.success());
          break;
        case SessionStatus.Completed:
          change(session, status: RxStatus.success());
          buttonData(DynamicSolidButtonData.complete());
          buttonData.refresh();
          // Reset Status
          Future.delayed(1200.milliseconds, () {
            isComplete(true);
            change(session, status: RxStatus.empty());
            _hasInvited = false;
          });
          break;
        default:
          change(session, status: RxStatus.empty());
          buttonData(DynamicSolidButtonData.invite());
          break;
      }
    }
  }

  // @ Handle User Position
  void _handlePosition(Position data) async {
    if (!isClosed && !isComplete.value) {
      // Find Offset
      if (peer.value.platform.isMobile) {
        isHitting(data.hasHitSphere(peer.value.position));
        relative(data.difference(peer.value.position));
        relativePosition(data.differenceRelative(peer.value.position));
      }

      // Feedback
      // Vibration
      if (isHitting.value) {
        HapticFeedback.lightImpact();
      }

      // Border
      borderWidth(relative.value.clamp(0, 5));

      // Check if Facing
      if (!_handlingHit) {
        await _handleHitting();
      }
    }
  }

  Future<void> _handleHitting({int milliseconds = 2750}) async {
    _handlingHit = true;
    if (isHitting.value) {
      await Future.delayed(Duration(milliseconds: milliseconds));

      if (isHittingValid) {
        invite();
      }
    }
    _handlingHit = false;
  }
}

extension SessionStatusOpacityUtil on SessionStatus {
  /// Returns Opacity Value By Peer Status
  double opacity() {
    switch (this) {
      case SessionStatus.Default:
        return 0.85;
      case SessionStatus.Pending:
        return 0.55;
      case SessionStatus.Invited:
        return 0.85;
      case SessionStatus.Accepted:
        return 0.35;
      case SessionStatus.Denied:
        return 0.0;
      case SessionStatus.InProgress:
        return 0.15;
      case SessionStatus.Completed:
        return 0.0;
    }
  }
}
