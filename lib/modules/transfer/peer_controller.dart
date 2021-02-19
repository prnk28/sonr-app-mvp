import 'dart:async';

import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:sonr_app/service/sonr_service.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonr_core/sonr_core.dart';

class PeerController extends GetxController {
  // Properties
  final isContentVisible = false.obs;
  final artboard = Rx<Artboard>();
  final difference = 0.0.obs;
  final direction = 0.0.obs;
  final offset = Offset(0, 0).obs;
  final proximity = Rx<Position_Proximity>();

  // References
  final userDirection = 0.0.obs;
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
    FlutterCompass.events.listen((dir) {
      userDirection(dir.headingForCameraMode);
    });

    // Listen to this peers updates
    Get.find<SonrService>().peers.listen((lob) {
      lob.forEach((id, value) {
        if (id == peer.id) {
          difference((userDirection.value - value.position.direction).abs());
          direction(value.position.direction);
          offset(calculateOffset(value.platform));
          proximity(value.position.proximity);
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
  initialize(Peer peerVal, int index) {
    this.peer = peerVal;
    this.index = index;
    isContentVisible(true);
    difference((userDirection.value - peerVal.position.direction).abs());
    direction(peerVal.position.direction);
    offset(calculateOffset(peerVal.platform));
    proximity(peerVal.position.proximity);
  }

  // ^ Handle User Invitation ^
  invite() {
    if (!_isInvited) {
      // Perform Invite
      Get.find<SonrService>().invite(this);

      // Check for File
      if (Get.find<SonrService>().payload.value == Payload.MEDIA) {
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
  Offset calculateOffset(Platform platform) {
    if (platform == Platform.MacOS || platform == Platform.Windows || platform == Platform.Web || platform == Platform.Linux) {
      var pos = Tangent.fromAngle(Offset(difference.value, Get.height / 5), direction.value);
      return pos.position;
    } else {
      if (proximity.value == Position_Proximity.Immediate) {
        var pos = Tangent.fromAngle(Offset(difference.value, Get.height / 5), direction.value);
        return pos.position;
      } else {
        var pos = Tangent.fromAngle(Offset(difference.value, Get.height / 14), direction.value);
        return pos.position;
      }
    }
  }
}
