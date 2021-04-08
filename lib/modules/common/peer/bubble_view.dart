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
                SizedBox(width: K_BUBBLE_SIZE, height: K_BUBBLE_SIZE, child: Rive(artboard: controller.board.value)),

                // Peer Info
                OpacityAnimatedWidget(
                    enabled: controller.isVisible.value,
                    values: controller.isVisible.value ? [0, 1] : [1, 0],
                    duration: Duration(milliseconds: 250),
                    delay: controller.isVisible.value ? Duration(milliseconds: 250) : Duration(milliseconds: 100),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                      controller.peer.value.initials,
                    ]))
              ])));
    });
  }
}


// ^ Reactive Controller for Peer Bubble ^ //
class BubbleController extends GetxController {
  // Reactive Elements
  final board = Rx<Artboard>(null);
  final counter = 0.0.obs;
  final isAnimated = true.obs;
  final hasCompleted = false.obs;
  final isFacing = false.obs;
  final isVisible = true.obs;
  final isWithin = false.obs;
  final offset = Offset(0, 0).obs;
  final peerVector = Rx<VectorPosition>(null);
  final userVector = Rx<VectorPosition>(null);
  final peer = Rx<Peer>(null);

  // References
  PeerStream _peerStream;
  StreamSubscription<VectorPosition> _userStream;
  Timer _timer;

  // State Machine
  StateMachineInput<bool> _isIdle;
  StateMachineInput<bool> _isPending;
  StateMachineInput<bool> _hasAccepted;
  StateMachineInput<bool> _hasDenied;
  StateMachineInput<bool> _isComplete;

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
    // Check for animated
    if (setAnimated) {
      // Create a RiveFile from the binary data
      final file = RiveFile.import(await rootBundle.load('assets/animations/peer_bubble.riv'));

      // Get Values
      final artboard = file.mainArtboard;
      var controller = StateMachineController.fromArtboard(artboard, 'State');

      // @ Set Controller
      if (controller != null) {
        // Set If Animated
        isAnimated(true);

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
      }

      // Handle Error
      else {
        print("Failed to find animation controller");
        isAnimated(false);
      }
    }
  }

  // ^ Toggle Expanded View
  void expandDetails() {
    Get.bottomSheet(PeerDetailsView(this), barrierColor: SonrColor.DialogBackground);
    HapticFeedback.heavyImpact();
  }

  // ^ Handle User Invitation ^
  void invite() {
    // Check Animated
    if (isAnimated.value) {
      // Check not already Pending
      if (!_isPending.value) {
        // Perform Invite
        SonrService.inviteWithController(this);
        Get.find<TransferController>().setFacingPeer(false);

        // Check for File
        if (Get.find<SonrService>().payload == Payload.MEDIA) {
          _isPending.value = true;
        }
        // Contact/URL
        else {
          playCompleted();
        }
      }
    }
  }

  // ^ Handle Accepted ^
  void playAccepted() async {
    // Check Animated
    if (isAnimated.value) {
      // Update Visibility
      isVisible(false);

      // Start Animation
      _hasAccepted.value = true;
    }
  }

  // ^ Handle Denied ^
  void playDenied() async {
    // Check Animated
    if (isAnimated.value) {
      // Update Visibility
      isVisible(false);

      // Start Animation
      _hasDenied.value = true;

      // Reset
      _reset();
    }
  }

  // ^ Handle Completed ^
  void playCompleted() async {
    // Check Animated
    if (isAnimated.value) {
      // Update Visibility
      isVisible(true);

      // Start Complete Animation
      _isComplete.value = true;
    }
  }

  // ^ Handle Peer Position ^ //
  void _handlePeerUpdate(Peer data) {
    if (!isClosed) {
      if (!hasCompleted.value) {
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
  }

  // ^ Handle Peer Position ^ //
  void _handleUserUpdate(VectorPosition pos) {
    if (!isClosed) {
      if (!hasCompleted.value) {
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
              _startTimer();
              isFacing(userVector.value.isPointingAt(peerVector.value));
            } else {
              _stopTimer();
            }
          }
        }
      }
    }
  }

  // ^ Handle Facing Check ^ //
  void _handleFacingUpdate() {
    if (!isClosed) {
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
            _startTimer();
            isFacing(userVector.value.isPointingAt(peerVector.value));
          } else {
            _stopTimer();
          }
        }
      }
    }
  }

  // ^ Temporary: Workaround to handle Bubble States ^ //
  void _reset() async {
    Future.delayed(1.seconds, () {
      // Call Finish
      _isComplete.value = false;
      _isPending.value = false;
      _hasAccepted.value = false;
      _hasDenied.value = false;
      _isIdle.value = true;
    });

    isVisible(true);
  }

  // ^ Begin Facing Invite Check ^ //
  void _startTimer() {
    Get.find<TransferController>().setFacingPeer(true);
    _timer = Timer.periodic(500.milliseconds, (_) {
      // Add MS to Counter
      counter(counter.value += 500);

      // Check if Facing
      if (counter.value == 2500) {
        if (isFacing.value && !hasCompleted.value && !_isPending.value) {
          invite();
          _stopTimer();
        } else {
          _stopTimer();
        }
      }
    });
  }

  // ^ Stop Timer for Facing Check ^ //
  void _stopTimer() {
    if (_timer != null) {
      Get.find<TransferController>().setFacingPeer(false);
      _timer.cancel();
      _timer = null;
      isFacing(false);
      counter(0);
    }
  }
}
