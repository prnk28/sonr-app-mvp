import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:rive/rive.dart';
import 'package:sonr_app/theme/theme.dart';
import 'peer_widget.dart';

class PeerController extends GetxController {
  // Properties
  final Peer peer;
  final int index;

  // Reactive Elements
  final RxMap<String, Peer> peers = SonrService.peers;
  final artboard = Rx<Artboard>();
  final peerDir = 0.0.obs;
  final userDir = 0.0.obs;
  final offset = Offset(0, 0).obs;
  final proximity = Rx<Position_Proximity>();
  final heading = Rx<Position_Heading>();
  final isFacing = false.obs;
  final isVisible = true.obs;

  // References
  StreamSubscription<CompassEvent> compassStream;
  StreamSubscription<int> stopwatchStream;

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
    peerDir(peer.position.direction);
    offset(calculateOffset());
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
    // Set Initial Values
    _handleCompassUpdate(DeviceService.direction.value);
    _handlePeerUpdate(SonrService.peers);

    // Add Stream Handlers
    isFacing.listen(_handleFacing);
    compassStream = DeviceService.direction.stream.listen(_handleCompassUpdate);
    peerStream = SonrService.peers.listen(_handlePeerUpdate);
    super.onInit();
  }

  void onDispose() {
    compassStream.cancel();
    peerStream.cancel();
    stopwatchStream.cancel();
  }

  // ^ Handle User Invitation ^
  invite() {
    if (!_isInvited) {
      // Perform Invite
      SonrService.invite(this);

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
    Get.bottomSheet(PeerSheetView(this), barrierColor: SonrColor.dialogBackground);
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
      // Call Finish
      _reset();
    });
  }

  // ^ Handle Completed ^
  playCompleted() async {
    // Update Visibility
    isVisible(true);

    // Start Complete Animation
    _sending.instance.animation.loop = Loop.oneShot;
    _complete.isActive = _hasCompleted = !_hasCompleted;

    // Update After Delay
    Future.delayed(Duration(milliseconds: 2500)).then((_) {
      // Call Finish
      _reset();
    });
  }

  // ^ Handle Compass Update ^ //
  _handleCompassUpdate(CompassEvent newDir) {
    if (newDir != null) {
      userDir(newDir.headingForCameraMode);
      offset(calculateOffset());
    }
  }

  // ^ Handle Facing Update ^ //
  _handleFacing(bool facing) {
    if (facing != isFacing.value) {
      print("Facing Update: $facing");
      if (facing) {
        stopwatchStream = stopWatchStream().listen((newTick) {
          print("stopwatchStream Update: ${(newTick % 60).floor()}");
          if ((newTick % 60).floor() == 3 && isFacing.value) {
            invite();
          }
        });
      } else {
        stopwatchStream.cancel();
      }
    }
  }

  // ^ Handle Peer Position ^ //
  _handlePeerUpdate(Map<String, Peer> lobby) {
    // Initialize
    lobby.forEach((id, value) {
      // Update Direction
      if (id == peer.id.peer && !_isInvited) {
        peerDir(value.position.direction);
        heading(value.position.heading);
        proximity(value.position.proximity);
        offset(calculateOffset());
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

  // ^ Calculate Peer Offset from Line ^ //
  Offset calculateOffset() {
    Platform platform = peer.platform;
    if (platform == Platform.MacOS || platform == Platform.Windows || platform == Platform.Web || platform == Platform.Linux) {
      return Offset.zero;
    } else {
      // Get Differential Data
      var diffRad = ((userDir.value - peerDir.value).abs() * pi) / 180.0;
      return SonrOffset.fromProximity(proximity.value, heading.value, diffRad);
    }
  }
}

Stream<int> stopWatchStream() {
  StreamController<int> streamController;
  Timer timer;
  Duration timerInterval = Duration(seconds: 1);
  int counter = 0;

  void stopTimer() {
    if (timer != null) {
      timer.cancel();
      timer = null;
      counter = 0;
      streamController.close();
    }
  }

  void tick(_) {
    counter++;
    streamController.add(counter);
  }

  void startTimer() {
    timer = Timer.periodic(timerInterval, tick);
  }

  streamController = StreamController<int>(
    onListen: startTimer,
    onCancel: stopTimer,
    onResume: startTimer,
    onPause: stopTimer,
  );

  return streamController.stream;
}
