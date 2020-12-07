import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:sonar_app/controller/controller.dart';
import 'package:sonar_app/model/model.dart';
import 'package:sonr_core/sonr_core.dart';

class BubbleAnimController extends GetxController {
  // Initialization
  Peer _peer;
  BubbleAnimController(this._peer) {
    TransferController transConn = Get.find();
    transConn.addListenerId("Listener", () {
      if (isInvited() && (transConn.status == AuthMessage_Event.ACCEPT)) {
        hasAccepted(true);
        _setAccepted();
        _hasResponded.value = true;
      }
      if (isInvited() && (transConn.status == AuthMessage_Event.DECLINE)) {
        hasDenied(true);
        _setDenied();
        _hasResponded.value = true;
      }
      if (isInvited() && (transConn.completed)) {
        hasCompleted(true);
        update();
      }
    });
  }

  // Public Artboard
  Artboard artboard;

  /// Animation References
  OneShotAnimation _android;
  OneShotAnimation _iphone;
  PingPongAnimation _idle;
  PingPongAnimation _pending;
  OneShotAnimation _denied;
  OneShotAnimation _accepted;
  OneShotAnimation _sending;

  // Internal Checkers
  var _isActive = false;
  ValueNotifier<bool> _hasInvited;
  ValueNotifier<bool> _hasResponded;

  // Observable Checkers
  var isInvited = false.obs;
  var hasAccepted = false.obs;
  var hasDenied = false.obs;
  var hasCompleted = false.obs;

  // ^ Loads Rive File and Initializes Animations ^ //
  onInit() {
    // Import File
    _import().then((value) => artboard = value);

    // Set Listenable Defaults
    _hasInvited.value = false;
    _hasResponded.value = false;

    // Start Widget
    super.onInit();
    start();
  }

  Future<Artboard> _import() async {
    // Load File
    final bytes = await rootBundle.load('assets/animations/peerbubble.riv');
    final file = RiveFile();

    // Start Controller
    if (file.import(bytes)) {
      _isActive = true;
      // Create Animations
      _android = OneShotAnimation('Android');
      _iphone = OneShotAnimation('iOS');
      _idle = PingPongAnimation('Idle');
      _pending = PingPongAnimation('Pending');
      _accepted = OneShotAnimation('Accepted');
      _denied = OneShotAnimation('Denied');
      _sending = OneShotAnimation('Sending');
      artboard = file.mainArtboard;
      return file.mainArtboard;
    }
    return null;
  }

  // ^ Sets initial Animation ^ //
  start() {
    if (_isActive) {
      // @ Check Device - iOS
      if (_peer.device.platform == "iOS") {
        artboard.addController(_iphone);
        _iphone.startThen(_setIdle);
      }
      // @ Check Device - Android
      else if (_peer.device.platform == "Android") {
        artboard.addController(_android);
        _android.startThen(_setIdle);
      }
    } else {
      _import().then((value) => start());
    }
  }

  // ^ Sets Idle Animation after initial ^ //
  _setIdle() {
    if (_isActive) {
      artboard.addController(_idle);
      _idle.startUntil(artboard, _hasInvited);
    } else {
      _import().then((value) => _setIdle());
    }
  }

  // ^ Sets Pending Animation after Invite ^ //
  invite() {
    if (_isActive) {
      // Set Checkers
      _hasInvited.value = true;
      isInvited(true);

      // Start Pending
      artboard.addController(_pending);
      _pending.startUntil(artboard, _hasResponded);
    } else {
      _import().then((value) => _setIdle());
    }
  }

  // ^ Sets Accepted Animation after Invite ^ //
  _setAccepted() {
    if (_isActive) {
      // Start Accepted
      artboard.addController(_accepted);
      _accepted.startThen(setSending);
    } else {
      _import().then((value) => _setIdle());
    }
  }

  // ^ Sets Denied Animation after Invite ^ //
  _setDenied() {
    if (_isActive) {
      // Start Denied
      artboard.addController(_denied);
      _denied.startThen(_setIdle);
    } else {
      _import().then((value) => _setIdle());
    }
  }

  // ^ Sets Sending Animation after Accepted ^ //
  setSending() {
    artboard.addController(_sending);
    _sending.start();
  }
}
