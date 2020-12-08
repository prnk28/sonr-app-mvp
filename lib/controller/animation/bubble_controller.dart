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
        _responded(true);
        _hasResponded.value = true;
      }
      if (isInvited() && (transConn.status == AuthMessage_Event.DECLINE)) {
        hasDenied(true);
        _responded(false);
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
  AnimationModel _android;
  AnimationModel _iphone;
  AnimationModel _idle;
  AnimationModel _pending;
  AnimationModel _denied;
  AnimationModel _accepted;
  AnimationModel _sending;
  AnimationTransitioner _transitioner;

  // Internal Checkers
  var _isActive = false;
  ValueNotifier<bool> _hasInvited = new ValueNotifier<bool>(false);
  ValueNotifier<bool> _hasResponded = new ValueNotifier<bool>(false);

  // Observable Checkers
  var isInvited = false.obs;
  var hasAccepted = false.obs;
  var hasDenied = false.obs;
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
      _android = AnimationModel('Android', Loop.oneShot);
      _iphone = AnimationModel('iOS', Loop.oneShot);
      _idle = AnimationModel('Idle', Loop.pingPong);
      _pending = AnimationModel('Pending', Loop.pingPong);
      _accepted = AnimationModel('Accepted', Loop.oneShot);
      _denied = AnimationModel('Denied', Loop.oneShot);
      _sending = AnimationModel('Sending', Loop.loop);
      artboard = file.mainArtboard;
      return file.mainArtboard;
    }
    return null;
  }

  // ^ Sets initial Animation ^ //
  start() {
    _transitioner = AnimationTransitioner(artboard);
    // ** Validate Active ** //
    if (_isActive) {
      // @ Check Device - iOS
      if (_peer.device.platform == "iOS") {
        _transitioner.oneShotThenUntil(_iphone, _idle, _hasInvited);
      }
      // @ Check Device - Android
      else if (_peer.device.platform == "Android") {
        _transitioner.oneShotThenUntil(_android, _idle, _hasInvited);
      }
    } else {
      _import().then((value) => start());
    }
  }

  // ^ Sets Pending Animation after Invite ^ //
  invite() {
    _transitioner = AnimationTransitioner(artboard);
    // ** Validate Active ** //
    if (_isActive) {
      // Set Checkers
      _hasInvited.value = true;
      isInvited(true);

      // Start Pending
      _transitioner.pingPong(_pending);
    } else {
      _import().then((value) => invite());
    }
  }

  _responded(bool decision) {
    _transitioner = AnimationTransitioner(artboard);
    // ** Validate Active ** //
    if (_isActive) {
      if (decision) {
        // Start Accepted
        _transitioner.oneShotThen(_accepted, _sending);
      } else {
        // Start Denied
        _transitioner.oneShotThen(_denied, _idle);
      }
    } else {
      _import().then((value) => _responded(hasAccepted.value));
    }
  }
}
