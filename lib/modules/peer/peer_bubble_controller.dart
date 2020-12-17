import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:sonar_app/modules/transfer/zone_painter.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonr_core/sonr_core.dart';

// ^ PeerStatus Enum ^ //
enum PeerStatus {
  Idle,
  Accepted,
  Denied,
  Completed,
}

class PeerBubbleController extends GetxController {
  final Peer peer;
  final shouldChangeVisibility = false.obs;
  final artboard = Rx<Artboard>();
  SonrService _sonr = Get.find();
  String id;
  var offest = Offset(0, 0);

  bool _isInvited = false;
  bool _hasDenied = false;
  bool _hasAccepted = false;
  bool _inProgress = false;
  bool _hasCompleted = false;

  SimpleAnimation _idle, _pending, _denied, _accepted, _sending, _complete;

  PeerBubbleController(this.peer) {
    // Set Default Values
    id = peer.id;
    offest = _calculateOffset(peer.difference);

    // Listen to User Status
    _sonr.status.listen((status) {
      // * Check if Invited * //
      if (_isInvited) {
        // @ Pending -> Busy = Peer Accepted File
        if (status == Status.Busy) {
          shouldChangeVisibility(true);
          updateStatus(PeerStatus.Accepted);
        }

        // @ Pending -> Searching = Peer Denied File
        if (status == Status.Searching) {
          shouldChangeVisibility(true);
          updateStatus(PeerStatus.Denied);
        }

        // @ Pending -> Searching = Peer Completed File
        if (status == Status.Complete) {
          shouldChangeVisibility(true);
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

      // Observable Artboard
      this.artboard(artboard);
    }
    super.onInit();
  }

  invite() {
    if (!_isInvited) {
      _sonr.invitePeer(peer);
      shouldChangeVisibility(false);
      _pending.isActive = _isInvited = !_isInvited;
    }
  }

  // ^ Handle Update Status ^
  updateStatus(PeerStatus status) {
    switch (status) {
      case PeerStatus.Idle:
        shouldChangeVisibility(false);
        break;
      case PeerStatus.Accepted:
        // Start Animation
        _pending.instance.animation.loop = Loop.oneShot;
        _accepted.instance.animation.loop = Loop.oneShot;
        _accepted.isActive = _hasAccepted = !_hasAccepted;

        // Update After Delay
        Future.delayed(Duration(seconds: 1)).then((_) {
          _hasAccepted = !_hasAccepted;
          _accepted.instance.time = 0.0;
          _sending.isActive = _inProgress = !_inProgress;
        });
        break;
      case PeerStatus.Denied:
        _pending.instance.animation.loop = Loop.oneShot;
        _denied.instance.animation.loop = Loop.oneShot;
        _denied.isActive = _hasDenied = !_hasDenied;
        break;
      case PeerStatus.Completed:
        // Start Complete Animation
        _sending.instance.animation.loop = Loop.oneShot;
        _complete.instance.animation.loop = Loop.oneShot;
        _complete.isActive = _hasCompleted = !_hasCompleted;

        // Update After Delay
        Future.delayed(Duration(seconds: 1)).then((_) {
          // Call Finish
          _isInvited = false;
          _sonr.reset();

          // Reset Animation States
          artboard().advance(0);
          this.refresh();
        });
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
}