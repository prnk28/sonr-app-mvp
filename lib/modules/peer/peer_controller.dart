import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:sonar_app/modules/transfer/compass/zone_painter.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonr_core/sonr_core.dart';

// ^ PeerStatus Enum ^ //
enum PeerStatus {
  Idle,
  OffLeft,
  OffRight,
  Accepted,
  Denied,
  Completed,
}

class PeerController extends GetxController {
  // Properties
  final String id;
  final Peer peer;
  final shouldChangeVisibility = false.obs;
  final artboard = Rx<Artboard>();
  final offset = Offset(0, 0).obs;
  final proximity = Rx<Peer_Proximity>();

  // References
  SonrService _sonr = Get.find();

  // Checkers
  bool _isInvited = false;
  bool _hasDenied = false;
  bool _hasAccepted = false;
  bool _inProgress = false;
  bool _hasCompleted = false;

  // Animations
  SimpleAnimation _idle, _pending, _denied, _accepted, _sending, _complete;

  PeerController(this.id, this.peer) {
    // Set Default Values
    offset(_calculateOffsetForPeer(peer));
    proximity(peer.proximity);

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

  // ^ Handle User Invitation ^
  invite() {
    if (!_isInvited) {
      _sonr.invitePeer(peer);
      shouldChangeVisibility(false);
      _pending.isActive = _isInvited = !_isInvited;
    }
  }

  // ^ setOffset User to Invite ^
  setOffset(Peer newValue) {
    if (!_isInvited) {
      proximity(peer.proximity);
      offset(_calculateOffsetForPeer(newValue));
    }
  }

  // ^ Handle Update Status ^
  updateStatus(PeerStatus status) {
    switch (status) {
      case PeerStatus.Idle:
        shouldChangeVisibility(false);
        break;
      case PeerStatus.OffLeft:
        // TODO: Handle this case.
        break;
      case PeerStatus.OffRight:
        // TODO: Handle this case.
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
  Offset _calculateOffsetForPeer(Peer peer) {
    // Get Data
    double value;
    Peer_Proximity proximity = peer.proximity;
    if (peer.difference > 1.0) {
      value = 1 / value;
    } else {
      value = peer.difference;
    }

    // Get Path
    // Path path = ZonePainter.getBubblePath(Get.width, proximity);
    // PathMetrics pathMetrics = path.computeMetrics();
    // PathMetric pathMetric = pathMetrics.elementAt(0);
    // value = pathMetric.length * value;

    // Return Position
    var pos =
        Tangent.fromAngle(Offset(Get.width / 2, Get.height / 2 - 300), value);
    //Tangent pos = pathMetric.getTangentForOffset(value);
    return pos.position;
  }
}
