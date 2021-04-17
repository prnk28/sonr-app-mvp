import 'package:rive/rive.dart';
import 'dart:async';
import 'dart:ui';
import 'package:sonr_app/pages/transfer/transfer_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/data/data.dart';
import 'peer.dart';

const double K_BUBBLE_SIZE = 80;

// ^ PeerBubble Utilizes Controller and Lottie Files ^ //
class PeerBubble extends GetWidget<BubbleController> {
  final Peer peer;
  PeerBubble(this.peer);

  @override
  Widget build(BuildContext context) {
    controller.initalize(peer);
    return Obx(() {
      return AnimatedPositioned(
        width: K_BUBBLE_SIZE,
        height: K_BUBBLE_SIZE,
        top: controller.offset.value.dy - (ZonePathProvider.size / 2),
        left: controller.offset.value.dx - (ZonePathProvider.size / 2),
        duration: 150.milliseconds,
        child: GestureDetector(
          onTap: controller.invite,
          onLongPress: controller.expandDetails,
          child: Stack(alignment: Alignment.center, children: [
            // Rive Board
            controller.isReady.value
                ? SizedBox(width: K_BUBBLE_SIZE, height: K_BUBBLE_SIZE, child: Rive(artboard: controller.board.value))
                : Container(),

            // Peer Info
            OpacityAnimatedWidget(
                enabled: controller.isVisible.value,
                values: controller.isVisible.value ? [0, 1] : [1, 0],
                duration: Duration(milliseconds: 250),
                delay: controller.isVisible.value ? Duration(milliseconds: 250) : Duration(milliseconds: 100),
                child: Center(child: controller.peer.value.initials))
          ]),
        ),
      );
    });
  }
}

// ^ Bubble Controller Status ^ //
enum BubbleStatus { Default, Pending, Accepted, Declined, Complete }

extension BubbleStatusUtils on BubbleStatus {
  bool get isIdle => this == BubbleStatus.Default;
  bool get isPending => this == BubbleStatus.Pending;
  bool get isAccepted => this == BubbleStatus.Accepted;
  bool get isDeclined => this == BubbleStatus.Declined;
  bool get isComplete => this == BubbleStatus.Complete;
}

// ^ Reactive Controller for Peer Bubble ^ //
class BubbleController extends GetxController {
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
  final status = Rx<BubbleStatus>(BubbleStatus.Default);

  // Vector Properties
  final offset = Offset(0, 0).obs;
  final peerVector = Rx<VectorPosition>(null);
  final userVector = Rx<VectorPosition>(null);

  // References
  PeerStream _peerStream;
  StreamSubscription<VectorPosition> _userStream;
  FunctionTimer _timer = FunctionTimer(deadline: 2500.milliseconds, interval: 500.milliseconds);

  // State Machine
  StateMachineInput<bool> _isIdle;
  StateMachineInput<bool> _isPending;
  StateMachineInput<bool> _hasAccepted;
  StateMachineInput<bool> _hasDenied;
  StateMachineInput<bool> _isComplete;

  BubbleController(this.riveFile);

  @override
  void onInit() {
    super.onInit();
  }

  // ** Dispose on Close ** //
  @override
  void onClose() {
    if (_peerStream != null) {
      _peerStream.close();
    }
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
    peerVector(VectorPosition(peer.value.position));
    userVector(LobbyService.userPosition.value);

    if (peer.value.isOnDesktop) {
      offset(Offset.zero);
    } else {
      offset(peerVector.value.offsetAgainstVector(userVector.value));
    }

    // Add Stream Handlers
    _peerStream = LobbyService.listenToPeer(peer.value).listen(_handlePeerUpdate);
    _userStream = LobbyService.userPosition.listen(_handleUserUpdate);

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
  void expandDetails() {
    Get.bottomSheet(PeerDetailsView(this), barrierColor: SonrColor.DialogBackground);
    HapticFeedback.heavyImpact();
  }

  // ^ Toggle Expanded View
  void flipView() {
    isFlipped(!isFlipped.value);
    HapticFeedback.heavyImpact();
  }

  // ^ Handle User Invitation ^
  void invite() {
    // Check Animated
    if (isReady.value) {
      // Check not already Pending
      if (!_isPending.value) {
        // Perform Invite
        Get.find<TransferController>().inviteWithBubble(this);

        // Check for File
        if (Get.find<TransferController>().currentPayload.isTransfer) {
          _isPending.value = true;
        }
        // Contact/URL
        else {
          updateStatus(BubbleStatus.Complete);
        }
      }
    }
  }

  // ^ Handle Updated Bubble Status ^ //
  void updateStatus(BubbleStatus newStatus, {Duration delay = const Duration(milliseconds: 0)}) {
    // @ Update Status
    status(newStatus);

    // @ Check Animated
    if (isReady.value) {
      // Handle Delay
      Future.delayed(delay, () {
        // Set Animation
        switch (status.value) {
          case BubbleStatus.Default:
            isVisible(true);
            _isComplete.value = false;
            _isPending.value = false;
            _hasAccepted.value = false;
            _hasDenied.value = false;
            _isIdle.value = true;
            break;
          case BubbleStatus.Pending:
            _isPending.value = true;
            break;
          case BubbleStatus.Accepted:
            isVisible(false);
            _hasAccepted.value = true;
            break;
          case BubbleStatus.Declined:
            isVisible(false);
            _hasDenied.value = true;
            break;
          case BubbleStatus.Complete:
            isVisible(false);
            _isComplete.value = true;
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
        peerVector(VectorPosition(data.position));

        // Handle Changes
        if (Get.find<TransferController>().isShiftingEnabled.value) {
          _handleFacingUpdate();
        }
      }
    }
  }

  // ^ Handle Peer Position ^ //
  void _handleUserUpdate(VectorPosition pos) {
    if (!isClosed && !status.value.isComplete) {
      // Initialize
      userVector(pos);

      // Find Offset
      if (Get.find<TransferController>().isShiftingEnabled.value) {
        if (peer.value.isOnDesktop) {
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

  // ^ Handle Facing Check ^ //
  void _handleFacingUpdate() {
    if (!isClosed && !status.value.isComplete) {
      // Find Offset
      if (peer.value.isOnDesktop) {
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
