import 'dart:async';
import 'dart:ui';
import 'package:rive/rive.dart';
import 'package:sonr_app/pages/transfer/transfer_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/data/data.dart';
import 'peer.dart';

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

  // References
  Timer _timer;
  Peer peer;

  // Checkers
  StateMachineInput<bool> _isIdle;
  StateMachineInput<bool> _isPending;
  StateMachineInput<bool> _hasAccepted;
  StateMachineInput<bool> _hasDenied;
  StateMachineInput<bool> _isComplete;

  // References
  PeerStream peerStream;
  StreamSubscription<VectorPosition> userStream;
  initalize(Peer peer, {bool setAnimated = true}) {
    // Set Initial
    isVisible(true);
    peerVector(VectorPosition(peer.position));
    userVector(LobbyService.userPosition.value);

    if (peer.isOnDesktop) {
      offset(Offset.zero);
    } else {
      offset(peerVector.value.offsetAgainstVector(userVector.value));
    }

    // Add Stream Handlers
    peerStream = LobbyService.listenToPeer(peer).listen(_handlePeerUpdate);
    userStream = LobbyService.userPosition.listen(_handleUserUpdate);

    // Set If Animated
    isAnimated(setAnimated);
  }

  @override
  void onInit() {
    loadAnimations();
    super.onInit();
  }

  void loadAnimations() async {
    // Check for animated
    if (isAnimated.value) {
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

  @override
  void onClose() {
    if (peerStream != null) {
      peerStream.close();
    }
    if (userStream != null) {
      userStream.cancel();
    }
    super.onClose();
  }

  // ^ Handle User Invitation ^
  void invite() {
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

  // ^ Toggle Expanded View
  void expandDetails() {
    Get.bottomSheet(PeerDetailsView(this), barrierColor: SonrColor.DialogBackground);
    HapticFeedback.heavyImpact();
  }

  // ^ Handle Accepted ^
  void playAccepted() async {
    // Update Visibility
    isVisible(false);

    // Start Animation
    _hasAccepted.value = true;
  }

  // ^ Handle Denied ^
  void playDenied() async {
    // Update Visibility
    isVisible(false);

    // Start Animation
    _hasDenied.value = true;

    // Update After Delay
    Future.delayed(Duration(milliseconds: 1000)).then((_) {
      _reset();
    });
  }

  // ^ Handle Completed ^
  void playCompleted() async {
    // Update Visibility
    isVisible(true);

    // Start Complete Animation
    _isComplete.value = true;
  }

  // ^ Handle Peer Position ^ //
  void _handlePeerUpdate(Peer peer) {
    if (!isClosed) {
      if (!hasCompleted.value) {
        // Update Direction
        if (peer.id.peer == peer.id.peer && !_isPending.value) {
          peerVector(VectorPosition(peer.position));

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
          if (peer.isOnDesktop) {
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
    // Find Offset
    if (peer.isOnDesktop) {
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
