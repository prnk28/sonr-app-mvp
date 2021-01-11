import 'dart:async';

import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonr_core/sonr_core.dart';

class PeerController extends GetxController {
  // Properties
  final isContentVisible = false.obs;
  final artboard = Rx<Artboard>();
  final difference = 0.0.obs;
  final direction = 0.0.obs;
  final offset = Offset(0, 0).obs;
  final proximity = Rx<Peer_Proximity>();

  // References
  final RxDouble userDirection = Get.find<SonrService>().direction;
  var peer = Peer();
  int index;

  // Checkers
  var _isInvited = false;
  var _hasDenied = false;
  var _hasAccepted = false;
  var _inProgress = false;
  var _hasCompleted = false;

  // Animations
  SimpleAnimation _pending, _denied, _accepted, _sending, _complete;

  PeerController() {
    // Listen to this peers updates
    Get.find<SonrService>().peers.listen((lob) {
      lob.forEach((key, value) {
        if (key == peer.id) {
          difference((userDirection.value - value.direction).abs());
          direction(value.direction);
          offset(calculateOffset(value.device));
          proximity(value.proximity);
          _log();
        }
      });
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
    super.onInit();
  }

  // ^ Sets Peer for this Widget ^
  initialize(Peer peer, int index) {
    this.peer = peer;
    this.index = index;
    isContentVisible(true);
    difference((userDirection.value - peer.direction).abs());
    direction(peer.direction);
    offset(calculateOffset(peer.device));
    proximity(peer.proximity);
  }

  _log() {
    print("Difference: ${difference.value}");
    print("Direction: ${direction.value}");
    print("Offset: ${offset.value}");
  }

  // ^ Handle User Invitation ^
  invite() {
    if (!_isInvited) {
      // Perform Invite
      Get.find<SonrService>().invite(this);

      // Check for File
      if (Get.find<SonrService>().payload.value == Payload.FILE) {
        isContentVisible(true);
        _pending.instance.animation.loop = Loop.pingPong;
        _pending.isActive = _isInvited = !_isInvited;
      }
      // Contact/URL
      else {
        playCompleted();
      }
    }
  }

  // ^ Handle Accepted ^
  playAccepted() async {
    // Update Visibility
    isContentVisible(false);

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
    isContentVisible(false);

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
    isContentVisible(false);

    // Start Complete Animation
    _sending.instance.animation.loop = Loop.oneShot;
    _complete.isActive = _hasCompleted = !_hasCompleted;

    // Update After Delay
    Future.delayed(Duration(milliseconds: 2500)).then((_) {
      // Call Finish
      _reset();
    });
  }

  // ^ Temporary: Workaround to handle Bubble States ^ //
  _reset() async {
    // Call Finish
    _hasDenied = false;
    _hasCompleted = false;
    _inProgress = false;
    _isInvited = false;
    isContentVisible(true);

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
  Offset calculateOffset(Device device) {
    if (device.platform == "Mac") {
      var pos = Tangent.fromAngle(
          Offset(difference.value, Get.height / 5), direction.value);
      return pos.position;
    } else {
      if (proximity.value == Peer_Proximity.IMMEDIATE) {
        var pos = Tangent.fromAngle(
            Offset(difference.value, Get.height / 5), direction.value);
        return pos.position;
      } else {
        var pos = Tangent.fromAngle(
            Offset(difference.value, Get.height / 14), direction.value);
        return pos.position;
      }
    }
  }
}
