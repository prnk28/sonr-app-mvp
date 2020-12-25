import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonar_app/widgets/painter.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonr_core/sonr_core.dart';

class PeerController extends GetxController {
  // Properties
  final isContentVisible = false.obs;
  final offset = Offset(0, 0).obs;
  final artboard = Rx<Artboard>();
  final proximity = Rx<Peer_Proximity>();

  // References
  var peer = Peer();

  // Checkers
  var _isInvited = false;
  var _hasDenied = false;
  var _hasAccepted = false;
  var _inProgress = false;
  var _hasCompleted = false;

  // Animations
  SimpleAnimation _idle, _pending, _denied, _accepted, _sending, _complete;

  PeerController() {
    // Listen to this peers updates
    Get.find<SonrService>().lobby.listen((lob) {
      lob.forEach((key, value) {
        if (key == peer.id) {
          offset(calculateOffset(value.difference));
          proximity(value.proximity);
        }
      });
    });
  }

  @override
  void onInit() async {
    // Load your Rive data
    final data = await rootBundle.load('assets/animations/peerbubble.riv');

    // Create a RiveFile from the binary data
    final file = RiveFile();
    if (file.import(data)) {
      final artboard = file.mainArtboard;

      // Add Animation Controllers
      artboard.addController(_idle = SimpleAnimation('Idle'));
      artboard.addController(_pending = SimpleAnimation('Pending'));
      artboard.addController(_denied = SimpleAnimation('Denied'));
      artboard.addController(_accepted = SimpleAnimation('Accepted'));
      artboard.addController(_sending = SimpleAnimation('Sending'));
      artboard.addController(_complete = SimpleAnimation('Complete'));

      // Set Default States
      _idle.isActive = !_isInvited && !_hasCompleted;
      _pending.isActive = _isInvited;
      _denied.isActive = _hasDenied;
      _accepted.isActive = _hasAccepted;
      _sending.isActive = _inProgress;
      _complete.isActive = _hasCompleted;

      // Observable Artboard
      this.artboard(artboard);
    }
    super.onInit();
  }

  // ^ Sets Peer for this Widget ^
  initialize(Peer peer) {
    this.peer = peer;
    offset(calculateOffset(peer.difference));
    proximity(peer.proximity);
  }

  // ^ Handle User Invitation ^
  invite() {
    if (!_isInvited) {
      Get.find<SonrService>().invite(this.peer);
      isContentVisible(true);
      _pending.instance.animation.loop = Loop.pingPong;
      _pending.isActive = _isInvited = !_isInvited;
    }
  }

  // ^ Handle Accepted ^
  playAccepted(Peer peer) async {
    if (peer.id == this.peer.id) {
      // Update Visibility
      isContentVisible(false);

      // Start Animation
      _pending.instance.animation.loop = Loop.oneShot;
      _accepted.isActive = _hasAccepted = !_hasAccepted;

      // Update After Delay
      Future.delayed(Duration(seconds: 1)).then((_) {
        _hasAccepted = !_hasAccepted;
        _accepted.instance.time = 0.0;
        _sending.isActive = _inProgress = !_inProgress;
      });
    }
  }

  // ^ Handle Denied ^
  playDenied(Peer peer) async {
    if (peer.id == this.peer.id) {
      // Update Visibility
      isContentVisible(false);

      // Start Animation
      _pending.instance.animation.loop = Loop.oneShot;
      _denied.isActive = _hasDenied = !_hasDenied;

      // Update After Delay
      Future.delayed(Duration(seconds: 1)).then((_) {
        // Call Finish
        _isInvited = false;
        isContentVisible(true);
      });
    }
  }

  // ^ Handle Completed ^
  playCompleted(Peer peer) async {
    if (peer.id == this.peer.id) {
      // Update Visibility
      isContentVisible(false);

      // Start Complete Animation
      _sending.instance.animation.loop = Loop.oneShot;
      _complete.isActive = _hasCompleted = !_hasCompleted;

      // Update After Delay
      Future.delayed(Duration(seconds: 1)).then((_) {
        // Call Finish
        _isInvited = false;
        isContentVisible(true);
      });
    }
  }

  // ^ Calculate Peer Offset from Line ^ //
  Offset calculateOffset(double value,
      {Peer_Proximity proximity = Peer_Proximity.NEAR}) {
    Path path = ZonePainter.getBubblePath(1 / value, proximity);
    PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(0.5); // TODO
    return pos.position;
  }
}
