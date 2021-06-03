import 'package:rive/rive.dart';
import 'dart:async';
import 'package:sonr_app/style/style.dart';

/// @ Reactive Controller for Peer Bubble
class PeerController extends GetxController with SingleGetTickerProviderMixin {
  // Required Properties
  final Future<RiveFile> riveFile;

  // Reactive Elements
  final board = Rx<Artboard?>(null);
  final counter = 0.0.obs;
  final isFlipped = false.obs;
  final isReady = false.obs;
  final isVisible = true.obs;

  final peer = Rx<Peer>(Peer());
  final status = PeerStatus.Default.obs;

  // Vector Properties
  final isHitting = false.obs;
  final relative = 0.0.obs;
  final relativePosition = RelativePosition.Center.obs;
  final borderWidth = 0.0.obs;

  // References
  late final AnimationController visibilityController;
  StreamSubscription<Position>? _userStream;
  bool _handlingHit = false;
  bool get isHittingValid => peer.value.isHitFrom(MobileService.position.value) && status.value.isIdle;

  // State Machine
  SMIInput<bool>? _isIdle;
  SMIInput<bool>? _isPending;
  SMIInput<bool>? _hasAccepted;
  SMIInput<bool>? _hasDenied;
  SMIInput<bool>? _isComplete;

  PeerController(this.riveFile);

  @override
  void onInit() {
    visibilityController = AnimationController(vsync: this);
    super.onInit();
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

  /// @ Method that Initializes Peer and Streams
  void initalize(Peer data, {bool setAnimated = true}) async {
    // Set Initial
    peer(data);
    isVisible(true);

    // Add Stream Handlers
    LobbyService.registerPeerCallback(peer.value, _handlePeerUpdate);

    // Check for Mobile
    if (DeviceService.isMobile) {
      _userStream = MobileService.position.listen(_handlePosition);
    }

    // Set If Animated
    if (setAnimated) {
      // Get Values
      final file = await riveFile;
      final artboard = file.mainArtboard;
      var controller = StateMachineController.fromArtboard(artboard, 'State');

      // @ Set Controller
      if (controller != null) {
        // Import State Machine
        artboard.addController(controller);
        _isIdle = controller.findInput('IsIdle');
        _isPending = controller.findInput('IsPending');
        _hasAccepted = controller.findInput('HasAccepted');
        _hasDenied = controller.findInput('HasDenied');
        _isComplete = controller.findInput('IsComplete');

        // Set Defaults
        _isComplete!.value = false;
        _isPending!.value = false;
        _hasAccepted!.value = false;
        _hasDenied!.value = false;
        _isIdle!.value = true;

        // Observable Artboard
        board(artboard);
        isReady(true);
      }

      // Handle Error
      else {
        Logger.error("Failed to find animation controller");
        isReady(false);
      }
    }
  }

  /// @ Toggle Expanded View
  void flipView(bool value) {
    isFlipped(value);
    isFlipped.refresh();
    HapticFeedback.heavyImpact();
  }

  /// @ Handle User Invitation
  void invite() {
    // Check Animated
    if (isReady.value && DeviceService.isMobile) {
      // Check not already Pending
      if (!_isPending!.value) {
        // Perform Invite
        var session = TransferService.sendInviteToPeer(this.peer.value);

        // Listen to Session
        if (session != null) {
          session.status.listen(_handleTransferStatus);
        }

        // Check for File
        if (TransferService.payload.value.isTransfer) {
          updateStatus(PeerStatus.Pending);
        }
        // Contact/URL
        else {
          updateStatus(PeerStatus.Complete);
        }
      }
    }
  }

  /// @ Handle Updated Bubble Status
  void updateStatus(PeerStatus newStatus, {Duration delay = const Duration(milliseconds: 0)}) {
    // @ Update Status
    status(newStatus);

    // @ Check Animated
    if (isReady.value) {
      // Handle Delay
      Future.delayed(delay, () {
        // Set Animation
        switch (status.value) {
          case PeerStatus.Default:
            isVisible(true);
            _isComplete!.value = false;
            _isPending!.value = false;
            _hasAccepted!.value = false;
            _hasDenied!.value = false;
            _isIdle!.value = true;
            break;
          case PeerStatus.Pending:
            isVisible(true);
            _isPending!.value = true;
            break;
          case PeerStatus.Accepted:
            isVisible(false);
            _hasAccepted!.value = true;
            break;
          case PeerStatus.Declined:
            isVisible(false);
            _hasDenied!.value = true;
            break;
          case PeerStatus.Complete:
            isVisible(false);
            _isComplete!.value = true;

            // Reset Status
            updateStatus(PeerStatus.Default, delay: 1200.milliseconds);
            break;
        }
      });
    }
  }

  /// @ Handle Peer Position
  void _handlePeerUpdate(Peer data) {
    if (!isClosed && !status.value.isComplete) {
      // Update Direction
      if (data.id.peer == peer.value.id.peer && !_isPending!.value) {
        peer(data);
      }
    }
  }

  // @ Handle Peer Response
  _handleTransferStatus(SessionStatus data) {
    if (data == SessionStatus.Accepted) {
      updateStatus(PeerStatus.Accepted);
    } else if (data == SessionStatus.Denied) {
      updateStatus(PeerStatus.Declined);
    } else {
      updateStatus(PeerStatus.Complete);
    }
  }

  // @ Handle User Position
  void _handlePosition(Position data) async {
    if (!isClosed && !status.value.isComplete) {
      // Find Offset
      if (peer.value.platform.isMobile) {
        isHitting(data.hasHitSphere(peer.value.position));
        relative(data.difference(peer.value.position));
        relativePosition(data.differenceRelative(peer.value.position));
      }

      // Feedback
      if (status.value.isIdle) {
        // Vibration
        if (isHitting.value) {
          HapticFeedback.lightImpact();
        }

        // Border
        borderWidth(relative.value.clamp(0, 5));
      }

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
