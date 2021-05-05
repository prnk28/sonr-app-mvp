import 'package:rive/rive.dart';
import 'dart:async';
import 'dart:ui';
import 'package:sonr_app/pages/transfer/transfer_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/data/data.dart';

// ^ Peer Controller Status ^ //
enum PeerStatus { Default, Pending, Accepted, Declined, Complete }

extension PeerStatusUtils on PeerStatus {
  bool get isIdle => this == PeerStatus.Default;
  bool get isPending => this == PeerStatus.Pending;
  bool get isAccepted => this == PeerStatus.Accepted;
  bool get isDeclined => this == PeerStatus.Declined;
  bool get isComplete => this == PeerStatus.Complete;
}

// ^ Reactive Controller for Peer Bubble ^ //
class PeerController extends GetxController {
  // Required Properties
  final Future<RiveFile> riveFile;

  // Reactive Elements
  final board = Rx<Artboard>(null);
  final counter = 0.0.obs;
  final isFlipped = false.obs;
  final isReady = false.obs;
  final isFacing = false.obs;
  final isVisible = true.obs;
  final isWithin = false.obs;
  final peer = Rx<Peer>(null);
  final status = Rx<PeerStatus>(PeerStatus.Default);

  // Vector Properties
  final offset = Offset(0, 0).obs;
  final peerVector = Rx<Position>(null);
  final userVector = Rx<Position>(null);

  // References
  StreamSubscription<Position> _userStream;
  FunctionTimer _timer = FunctionTimer(deadline: 2500.milliseconds, interval: 500.milliseconds);

  // State Machine
  StateMachineInput<bool> _isIdle;
  StateMachineInput<bool> _isPending;
  StateMachineInput<bool> _hasAccepted;
  StateMachineInput<bool> _hasDenied;
  StateMachineInput<bool> _isComplete;

  PeerController(this.riveFile);

  @override
  void onInit() {
    super.onInit();
  }

  // ** Dispose on Close ** //
  @override
  void onClose() {
    LobbyService.unregisterPeerCallback(peer.value);
    if (_userStream != null) {
      _userStream.cancel();
    }
    super.onClose();
  }

  // ^ Method that Initializes Peer and Streams ^ //
  void initalize(Peer data, {bool setAnimated = true}) async {
    // Set Initial
    peer(data);
    isVisible(true);
    peerVector(peer.value.position);
    userVector(LobbyService.userPosition.value);

    if (peer.value.platform.isDesktop) {
      offset(Offset.zero);
    } else {
      offset(peerVector.value.offsetAgainstVector(userVector.value));
    }

    // Add Stream Handlers
    LobbyService.registerPeerCallback(peer.value, _handlePeerUpdate);

    // Check for Mobile
    if (DeviceService.isMobile) {
      _userStream = LobbyService.userPosition.listen(_handleUserUpdate);
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
        _isComplete.value = false;
        _isPending.value = false;
        _hasAccepted.value = false;
        _hasDenied.value = false;
        _isIdle.value = true;

        // Observable Artboard
        board(artboard);
        isReady(true);
      }

      // Handle Error
      else {
        print("Failed to find animation controller");
        isReady(false);
      }
    }
  }

  // ^ Toggle Expanded View
  void flipView(bool value) {
    isFlipped(value);
    isFlipped.refresh();
    HapticFeedback.heavyImpact();
  }

  // ^ Handle User Invitation ^
  void invite() {
    // Check Animated
    if (isReady.value) {
      // Check not already Pending
      if (!_isPending.value) {
        // Register Callback
        Get.find<SonrService>().registerTransferUpdates(_handleTransferStatus);

        // Perform Invite
        Get.find<TransferController>().invitePeer(this.peer.value);

        // Check for File
        if (Get.find<TransferController>().currentPayload.isTransfer) {
          _isPending.value = true;
        }
        // Contact/URL
        else {
          updateStatus(PeerStatus.Complete);
        }
      }
    }
  }

  // ^ Handle Updated Bubble Status ^ //
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
            _isComplete.value = false;
            _isPending.value = false;
            _hasAccepted.value = false;
            _hasDenied.value = false;
            _isIdle.value = true;
            break;
          case PeerStatus.Pending:
            isVisible(true);
            _isPending.value = true;
            break;
          case PeerStatus.Accepted:
            isVisible(false);
            _hasAccepted.value = true;
            break;
          case PeerStatus.Declined:
            isVisible(false);
            _hasDenied.value = true;
            break;
          case PeerStatus.Complete:
            isVisible(false);
            _isComplete.value = true;

            // Reset Status
            updateStatus(PeerStatus.Default, delay: 1200.milliseconds);
            break;
        }
      });
    }
  }

  // ^ Handle Peer Position ^ //
  void _handlePeerUpdate(Peer data) {
    if (!isClosed && !status.value.isComplete) {
      // Update Direction
      if (data.id.peer == peer.value.id.peer && !_isPending.value) {
        peer(data);
        peerVector(data.position);

        // Handle Changes
        if (Get.find<TransferController>().isShiftingEnabled.value) {
          _handleFacingUpdate();
        }
      }
    }
  }

  // @ Handle Peer Response ^ //
  _handleTransferStatus(TransferStatus data) {
    if (data == TransferStatus.Accepted) {
      updateStatus(PeerStatus.Accepted);
    } else if (data == TransferStatus.Denied) {
      updateStatus(PeerStatus.Declined);
    } else {
      updateStatus(PeerStatus.Complete);
    }
  }

  // @ Handle Peer Position ^ //
  void _handleUserUpdate(Position pos) {
    if (!isClosed && !status.value.isComplete) {
      // Initialize
      userVector(pos);

      // Find Offset
      if (Get.find<TransferController>().isShiftingEnabled.value) {
        if (peer.value.platform.isDesktop) {
          offset(Offset.zero);
        } else {
          offset(peerVector.value.offsetAgainstVector(userVector.value));
        }
      }

      // Check if Facing
      var newIsFacing = userVector.value.isPointingAt(peerVector.value);
      if (isFacing.value != newIsFacing) {
        // Check if Device Permits PointToShare
        if (UserService.pointShareEnabled) {
          // Check New Result
          if (newIsFacing) {
            Get.find<TransferController>().setFacingPeer(true);
            _timer.start(isValid: _checkFacingValid, onComplete: invite);
            isFacing(userVector.value.isPointingAt(peerVector.value));
          } else {
            _timer.stop();
          }
        }
      }
    }
  }

  // @ Handle Facing Check ^ //
  void _handleFacingUpdate() {
    if (!isClosed && !status.value.isComplete) {
      // Find Offset
      if (peer.value.platform.isDesktop) {
        offset(Offset.zero);
      } else {
        offset(peerVector.value.offsetAgainstVector(userVector.value));
      }

      // Check if Facing
      var newIsFacing = userVector.value.isPointingAt(peerVector.value);
      if (isFacing.value != newIsFacing) {
        // Check if Device Permits PointToShare
        if (UserService.pointShareEnabled) {
          // Check New Result
          if (newIsFacing) {
            Get.find<TransferController>().setFacingPeer(true);
            _timer.start(isValid: _checkFacingValid, onComplete: invite);
            isFacing(userVector.value.isPointingAt(peerVector.value));
          } else {
            _timer.stop();
          }
        }
      }
    }
  }

  bool _checkFacingValid() {
    return isFacing.value && !status.value.isComplete && !status.value.isPending;
  }
}
