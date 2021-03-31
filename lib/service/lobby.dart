import 'dart:async';
import 'package:get/get.dart' hide Node;
import 'package:motion_sensors/motion_sensors.dart';
import 'package:sonr_app/modules/profile/profile_card.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

class LobbyService extends GetxService {
  // @ Set Properties
  final _isFlatMode = false.obs;
  final _lobbies = RxMap<String, Lobby>();
  final _local = Rx<Lobby>();
  final _localFlatPeers = RxMap<String, Peer>();
  final _localSize = 0.obs;
  final counter = 0.0.obs;
  final flatOverlayIndex = (-1).obs;

  // @ Static Accessors
  static RxBool get isFlatMode => Get.find<LobbyService>()._isFlatMode;
  static RxMap<String, Lobby> get lobbies => Get.find<LobbyService>()._lobbies;
  static Rx<Lobby> get local => Get.find<LobbyService>()._local;
  static RxMap<String, Peer> get localFlatPeers => Get.find<LobbyService>()._localFlatPeers;
  static RxInt get localSize => Get.find<LobbyService>()._localSize;

  // @ References
  StreamSubscription<AccelerometerEvent> _accelStream;
  final _flatModeCancelled = false.obs;
  final _lastIsFacingFlat = false.obs;
  Timer _timer;

  // # Initialize Service Method ^ //
  Future<LobbyService> init() async {
    _accelStream = DeviceService.accelerometer.listen(_handleAccelStream);
    return this;
  }

  // # On Service Close //
  void onDispose() {
    _accelStream.cancel();
  }

  // ^ Method to Cancel Flat Mode ^ //
  void sendFlatMode() {
    _flatModeCancelled(true);
    _resetTimer();
    Future.delayed(15.seconds, () {
      _flatModeCancelled(false);
    });
  }

  // # Handle Lobby Update //
  void handleRefresh(Lobby data) {
    // @ Update Local Topics
    if (data.isLocal) {
      // Update Local
      _handleFlatPeers(data);
      _local(data);
      _localSize(data.count);
      _local.refresh();
    }

    // @ Update Other Topics
    else {
      _lobbies[data.name] = data;
      _lobbies.refresh();
    }
  }

  // # Handle Lobby Flat Peers ^ //
  void _handleFlatPeers(Lobby data) {
    var flatPeers = <String, Peer>{};
    data.peers.forEach((id, peer) {
      if (peer.properties.isFlatMode) {
        flatPeers[id] = peer;
      }
    });
    _localFlatPeers(flatPeers);
    _localFlatPeers.refresh();
  }

  // # Handle Incoming Acceleromter Stream
  void _handleAccelStream(AccelerometerEvent data) {
    if (!_flatModeCancelled.value) {
      var newIsFacingFlat = data.y < 2.6;
      if (newIsFacingFlat != _lastIsFacingFlat.value) {
        if (newIsFacingFlat) {
          _startTimer();
          _lastIsFacingFlat(data.y < 2.6);
        } else {
          _resetTimer();
        }
      }
    }
  }

  // # Begin Facing Invite Check
  void _startTimer() {
    _timer = Timer.periodic(400.milliseconds, (_) {
      // Add MS to Counter
      counter(counter.value += 400);

      // Check if Facing
      if (counter.value == 2400) {
        if (_lastIsFacingFlat.value && localFlatPeers.length > 0) {
          // Update Refs
          _isFlatMode(true);
          SonrService.setFlatMode(true);

          // Present View
          Get.dialog(FlatModeView(), barrierColor: Colors.transparent, barrierDismissible: false, useSafeArea: false);
        } else {
          _resetTimer();
        }
      }
    });
  }

  // # Stop Timer for Facing Check
  void _resetTimer() {
    _isFlatMode(false);
    SonrService.setFlatMode(false);
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
      _lastIsFacingFlat(false);
      counter(0);
    }
  }
}
