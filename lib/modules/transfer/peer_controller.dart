import 'dart:async';
import 'dart:ui';
import 'package:rive/rive.dart';
import 'package:sonr_app/core/core.dart';
import 'package:sonr_app/core/core.dart';
import 'peer_widget.dart';

class PeerController extends GetxController {
  // Properties
  final Peer peer;
  final int index;

  // Reactive Elements
  final artboard = Rx<Artboard>();
  final difference = 0.0.obs;
  final direction = 0.0.obs;
  final offset = Offset(0, 0).obs;
  final proximity = Rx<Position_Proximity>();
  final contentAnimation = Rx<Triple<Tween<double>, Duration, Duration>>();

  // References
  final Rx<CompassEvent> userDirection = DeviceService.direction;
  final RxMap<String, Peer> peers = SonrService.peers;
  final enabledContent = Triple((0.0).tweenTo(1.0), 250.milliseconds, 250.milliseconds);
  final disabledContent = Triple((1.0).tweenTo(0.0), 250.milliseconds, 100.milliseconds);

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
    contentAnimation(enabledContent);
    difference(peer.position.antipodal);
    direction(peer.position.direction);
    offset(calculateOffset(peer.platform));
    proximity(peer.position.proximity);
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

      // Check for File
      if (Get.find<SonrService>().payload == Payload.MEDIA) {
        contentAnimation(enabledContent);
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
    Get.bottomSheet(PeerSheetView(this), barrierColor: SonrColor.dialogBackground);
    HapticFeedback.heavyImpact();
  }

  // ^ Handle Accepted ^
  playAccepted() async {
    // Update Visibility
    contentAnimation(disabledContent);

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
    // Update Visibility
    contentAnimation(disabledContent);

    // Start Animation
    _pending.instance.animation.loop = Loop.oneShot;
    _denied.isActive = _hasDenied = !_hasDenied;

    // Update After Delay
    Future.delayed(Duration(milliseconds: 1000)).then((_) {
      // Call Finish
      _reset();
    });
  }

  // ^ Handle Completed ^
  playCompleted() async {
    // Update Visibility
    contentAnimation(disabledContent);

    // Start Complete Animation
    _sending.instance.animation.loop = Loop.oneShot;
    _complete.isActive = _hasCompleted = !_hasCompleted;

    // Update After Delay
    Future.delayed(Duration(milliseconds: 2500)).then((_) {
      // Call Finish
      _reset();
    });
  }

  // ^ Handle Peer Position ^ //
  _handlePeerUpdate(Map<String, Peer> lobby) {
    // Initialize
    lobby.forEach((id, value) {
      // Update Direction
      if (id == peer.id.peer && !_isInvited) {
        difference((userDirection.value.headingForCameraMode - value.position.direction).abs());
        direction(value.position.direction);
        offset(calculateOffset(value.platform));
        proximity(value.position.proximity);
      }
    });
  }

  // ^ Temporary: Workaround to handle Bubble States ^ //
  _reset() async {
    // Call Finish
    _hasDenied = false;
    _hasCompleted = false;
    _inProgress = false;
    _isInvited = false;
    contentAnimation(enabledContent);

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

  // ^ Calculate Peer Offset from Line ^ //
  Offset calculateOffset(Platform platform) {
    if (platform == Platform.MacOS || platform == Platform.Windows || platform == Platform.Web || platform == Platform.Linux) {
      return Offset.zero;
    } else {
      return SonrOffset.fromDegrees(difference.value);
    }
  }
}
