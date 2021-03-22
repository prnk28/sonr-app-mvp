import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:rive/rive.dart';
import 'package:sonr_app/theme/theme.dart';
import 'peer_widget.dart';
import 'transfer_controller.dart';

class PeerController extends GetxController {
  // Properties
  final Peer peer;
  final int index;

  // Reactive Elements
  final RxMap<String, Peer> peers = SonrService.peers;
  final artboard = Rx<Artboard>();
  final counter = 0.0.obs;
  final diffDesg = Rx<Position_Designation>();
  final diffRad = 0.0.obs;

  final hasCompleted = false.obs;
  final isFacing = false.obs;
  final isVisible = true.obs;
  final isWithin = false.obs;
  final offset = Offset(0, 0).obs;
  final position = Rx<Position>();
  final userPos = Rx<CompassEvent>(DeviceService.direction.value);

  // References
  Timer _timer;

  // Checkers
  var _isInvited = false;
  var _hasDenied = false;
  var _hasAccepted = false;
  var _inProgress = false;
  var _hasCompleted = false;

  // References
  SimpleAnimation _pending, _denied, _accepted, _sending, _complete;
  StreamSubscription<Map<String, Peer>> peerStream;
  PeerController(this.peer, this.index) {
    isVisible(true);
    position(peer.position);
    offset(_calculateOffset());

    // Update Peer Periodically
    Timer.periodic(250.milliseconds, (timer) {
      _handleCompassUpdate(DeviceService.direction.value);
    });
  }

  @override
  void onInit() async {
    // Load your Rive data
    final data = await rootBundle.load('assets/animations/peer_bubble.riv');

    // Create a RiveFile from the binary data
    final file = RiveFile();
    if (file.import(data)) {
      final artboard = file.mainArtboard;

      // Add Animation Controllers
      artboard.addController(SimpleAnimation('Idle'));
      artboard.addController(_pending = SimpleAnimation('Pending'));
      artboard.addController(_denied = SimpleAnimation('Denied'));
      artboard.addController(_accepted = SimpleAnimation('Accepted'));
      artboard.addController(_sending = SimpleAnimation('Sending'));
      artboard.addController(_complete = SimpleAnimation('Complete'));

      // Set Default States
      _pending.isActive = _isInvited;
      _denied.isActive = _hasDenied;
      _accepted.isActive = _hasAccepted;
      _sending.isActive = _inProgress;
      _complete.isActive = _hasCompleted;

      // Observable Artboard
      this.artboard(artboard);
    }
    // Set Initial Values
    _handlePeerUpdate(SonrService.peers);

    // Add Stream Handlers
    peerStream = SonrService.peers.listen(_handlePeerUpdate);
    super.onInit();
  }

  void onDispose() {
    peerStream.cancel();
  }

  // ^ Handle User Invitation ^
  invite() {
    if (!_isInvited) {
      // Perform Invite
      SonrService.invite(this);
      Get.find<TransferController>().setFacingPeer(false);

      // Check for File
      if (Get.find<SonrService>().payload == Payload.MEDIA) {
        _pending.instance.animation.loop = Loop.pingPong;
        _pending.isActive = _isInvited = !_isInvited;
      }
      // Contact/URL
      else {
        playCompleted();
      }
    }
  }

  // ^ Toggle Expanded View
  expandDetails() {
    Get.bottomSheet(PeerSheetView(this), barrierColor: SonrColor.DialogBackground);
    HapticFeedback.heavyImpact();
  }

  // ^ Handle Accepted ^
  playAccepted() async {
    // Update Visibility
    isVisible(false);

    // Start Animation
    _pending.instance.animation.loop = Loop.oneShot;
    _accepted.isActive = _hasAccepted = !_hasAccepted;

    // Update After Delay
    Future.delayed(Duration(milliseconds: 900)).then((_) {
      _accepted.instance.time = 0.0;
      _sending.isActive = _inProgress = !_inProgress;
    });
  }

  // ^ Handle Denied ^
  playDenied() async {
    // Start Animation
    _pending.instance.animation.loop = Loop.oneShot;
    _denied.isActive = _hasDenied = !_hasDenied;

    // Update After Delay
    Future.delayed(Duration(milliseconds: 1000)).then((_) {
      hasCompleted(true);
      _reset();
    });
  }

  // ^ Handle Completed ^
  playCompleted() async {
    // Update Visibility
    isVisible(true);
    hasCompleted(true);

    // Start Complete Animation
    _sending.instance.animation.loop = Loop.oneShot;
    _complete.isActive = _hasCompleted = !_hasCompleted;

    // Update After Delay
    Future.delayed(Duration(milliseconds: 2500)).then((_) {
      // Call Finish
      _reset();
    });
  }

  // ^ Calculate Peer Offset from Line ^ //
  Offset _calculateOffset() {
    if (_isInvited) {
      return offset.value;
    } else {
      if (peer.platform == Platform.MacOS || peer.platform == Platform.Windows || peer.platform == Platform.Web || peer.platform == Platform.Linux) {
        return Offset.zero;
      } else {
        return SonrOffset.fromPosition(position.value, diffDesg.value, diffRad.value);
      }
    }
  }

  // ^ Handle Compass Update ^ //
  _handleCompassUpdate(CompassEvent newDir) {
    if (newDir != null && !hasCompleted.value && !isClosed) {
      // Update Direction
      userPos(newDir);

      // Set Diff Radians from Heading Vals
      diffRad(((userPos.value.heading - position.value.facingAntipodal).abs() * pi) / 180.0);

      // Set Designation with Facing Vals
      var adjustedDesignation = (((userPos.value.headingForCameraMode - position.value.facing).abs() / 11.25) + 0.25).toInt();
      diffDesg(Position_Designation.values[(adjustedDesignation % 32)]);

      // Handle Changes
      _handleFacingUpdate();
    }
  }

  // ^ Handle Peer Position ^ //
  _handlePeerUpdate(Map<String, Peer> lobby) {
    if (!hasCompleted.value) {
      // Initialize
      lobby.forEach((id, value) {
        // Update Direction
        if (id == peer.id.peer && !_isInvited) {
          position(value.position);

          // Set Diff Radians from Heading Vals
          diffRad(((userPos.value.heading - position.value.headingAntipodal).abs() * pi) / 180.0);

          // Set Designation with Facing Vals
          var adjustedDesignation = (((userPos.value.headingForCameraMode - position.value.facing).abs() / 11.25) + 0.25).toInt();
          diffDesg(Position_Designation.values[(adjustedDesignation % 32)]);

          // Handle Changes
          _handleFacingUpdate();
        }
      });
    }
  }

  // ^ Handle Facing Check ^ //
  _handleFacingUpdate() {
    // Find Offset
    offset(_calculateOffset());

    // Check if Facing
    var newIsFacing = diffDesg.value.isFacing(position.value.proximity);
    if (isFacing.value != newIsFacing) {
      // Check if Device Permits PointToShare
      if (DeviceService.hasPointToShare.value) {
        // Check New Result
        if (newIsFacing) {
          _startTimer();
          isFacing(diffDesg.value.isFacing(position.value.proximity));
        } else {
          _stopTimer();
        }
      }
    }
  }

  // ^ Temporary: Workaround to handle Bubble States ^ //
  _reset() async {
    // Call Finish
    _hasDenied = false;
    _hasCompleted = false;
    _inProgress = false;
    _isInvited = false;
    isVisible(true);

    // Remove Sending/Complete
    artboard.value.removeController(_sending);
    artboard.value.removeController(_complete);

    // Add Animation Controllers
    artboard.value.addController(_sending = SimpleAnimation('Sending'));
    artboard.value.addController(_complete = SimpleAnimation('Complete'));

    // Set Default States
    _denied.isActive = _hasDenied;
    _sending.isActive = _inProgress;
    _complete.isActive = _hasCompleted;
  }

  // ^ Begin Facing Invite Check ^ //
  void _startTimer() {
    Get.find<TransferController>().setFacingPeer(true);
    _timer = Timer.periodic(500.milliseconds, (_) {
      // Add MS to Counter
      counter(counter.value += 500);

      // Check if Facing
      if (counter.value == 2500) {
        if (isFacing.value && !hasCompleted.value && !_inProgress) {
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
