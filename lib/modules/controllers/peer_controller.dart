import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:sonar_app/modules/widgets/painter/zones.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonr_core/sonr_core.dart';

// ^ PeerStatus Enum ^ //
enum PeerStatus {
  Idle,
  Invited,
  Accepted,
  Denied,
  Completed,
}

class PeerController extends GetxController {
  SonrService _sonr = Get.find();
  final Peer peer;
  final artboard = Rx<Artboard>();
  var offest = Offset(0, 0);

  bool _isInvited = false;
  bool _hasDenied = false;
  bool _hasAccepted = false;
  bool _inProgress = false;
  bool _hasCompleted = false;
  bool shouldChangeVisibility = false;
  SimpleAnimation _idle, _pending, _denied, _accepted, _sending, _complete;

  PeerController(this.peer) {
    // Set Offset Value
    offest = _calculateOffset(peer.difference);

    // Listen to User Status
    _sonr.status.listen((status) {
      // * Check if Invited * //
      if (_isInvited) {
        // @ Pending -> Busy = Peer Accepted File
        if (status == Status.Busy) {
          updateStatus(PeerStatus.Accepted);
        }

        // @ Pending -> Searching = Peer Denied File
        if (status == Status.Searching) {
          updateStatus(PeerStatus.Denied);
        }

        // @ Pending -> Searching = Peer Completed File
        if (status == Status.Complete) {
          updateStatus(PeerStatus.Completed);
        }
      }
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

      // Add One Shot Listeners
      _accepted.isActiveChanged.addListener(_handleAcceptToSend);
      _complete.isActiveChanged.addListener(_handleReset);

      // Observable Artboard
      this.artboard(artboard);
    }
    super.onInit();
  }

  // ^ Handle Update Status ^
  updateStatus(PeerStatus status) {
    switch (status) {
      case PeerStatus.Idle:
        shouldChangeVisibility = false;
        break;
      case PeerStatus.Invited:
        if (!_isInvited) {
          _sonr.invitePeer(peer);
          shouldChangeVisibility = false;
          _pending.isActive = _isInvited = !_isInvited;
        }
        break;
      case PeerStatus.Accepted:
        shouldChangeVisibility = true;
        _pending.instance.animation.loop = Loop.oneShot;
        _accepted.instance.animation.loop = Loop.oneShot;
        _accepted.isActive = _hasAccepted = !_hasAccepted;
        break;
      case PeerStatus.Denied:
        shouldChangeVisibility = true;
        _pending.instance.animation.loop = Loop.oneShot;
        _denied.instance.animation.loop = Loop.oneShot;
        _denied.isActive = _hasDenied = !_hasDenied;
        break;
      case PeerStatus.Completed:
        if (_inProgress) {
          _sending.instance.animation.loop = Loop.oneShot;
        }

        if (_isInvited) {
          _pending.instance.animation.loop = Loop.oneShot;
        }

        // Start Complete Animation
        shouldChangeVisibility = true;
        _complete.instance.animation.loop = Loop.oneShot;
        _complete.isActive = _hasCompleted = !_hasCompleted;
        break;
    }
  }

  // ^ Calculate Peer Offset from Line ^ //
  Offset _calculateOffset(double value,
      {Peer_Proximity proximity = Peer_Proximity.NEAR}) {
    Path path = ZonePainter.getBubblePath(Get.width, proximity);
    PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(0.5); // TODO
    return pos.position;
  }

  // ^ Add listener for file transfer ^
  _handleAcceptToSend() {
    if (_accepted.isActive == false) {
      _hasAccepted = !_hasAccepted;
      _sending.isActive = _inProgress = !_inProgress;
    }
  }

// ^ Add listener for file transfer ^
  _handleReset() {
    if (_complete.isActive == false) {
      _hasCompleted = false;
      _isInvited = true;
      _idle.isActive = true;
      _complete.mix = 0.0;
    }
  }
}
