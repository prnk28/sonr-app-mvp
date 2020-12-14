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
      // Validate Invited
      if (isInvited()) {
        // Check Reply
        if (transConn.reply.decision) {
          hasResponded(true);
          update();
          _setAccepted();
          _hasResponded.value = true;
        } else {
          hasResponded(true);
          update();
          _setDenied();
          _hasResponded.value = true;
        }

        // Check Completed
        if (transConn.completed) {
          hasCompleted(true);
          update();
          _setComplete();
        }
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
  OneShotAnimation _complete;

  // Internal Checkers
  var _isActive = false;
  ValueNotifier<bool> _hasInvited = new ValueNotifier<bool>(false);
  ValueNotifier<bool> _hasResponded = new ValueNotifier<bool>(false);

  // Observable Checkers
  var isInvited = false.obs;
  var hasResponded = false.obs;
  var hasCompleted = false.obs;

  // ^ Widget Start ^ //
  onInit() {
    // Import File
    _import().then((value) => artboard = value);

    // Start Widget
    super.onInit();
    start();
  }

  // ^ Loads Rive File and Initializes Animations ^ //
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
      _complete = OneShotAnimation('Complete');
      artboard = file.mainArtboard;
      return file.mainArtboard;
    }
    return null;
  }

  // ^ Sets initial Animation ^ //
  start() {
    // ** Validate Active ** //
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
    // ** Validate Active ** //
    if (_isActive) {
      artboard.addController(_idle);
      _idle.startUntil(_hasInvited);
    } else {
      _import().then((value) => _setIdle());
    }
  }

  // ^ Sets Pending Animation after Invite ^ //
  invite() {
    // ** Validate Active ** //
    if (_isActive) {
      // Set Checkers
      _hasInvited.value = true;
      isInvited(true);

      // Start Pending
      artboard.addController(_pending);
      _pending.startUntil(_hasResponded);
    } else {
      _import().then((value) => _setIdle());
    }
  }

  // ^ Sets Accepted Animation after Invite ^ //
  _setAccepted() {
    // ** Validate Active ** //
    if (_isActive) {
      // Start Accepted
      _pending.stop();
      artboard.addController(_accepted);
      _accepted.startThen(setSending);
    } else {
      _import().then((value) => _setIdle());
    }
  }

  // ^ Sets Denied Animation after Invite ^ //
  _setDenied() {
    // ** Validate Active ** //
    if (_isActive) {
      // Start Denied
      _pending.stop();
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

  _setComplete() {
    artboard.addController(_complete);
    _complete.startThen(() => _setIdle());
  }
}
