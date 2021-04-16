import 'dart:async';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart' hide Node;
import 'package:motion_sensors/motion_sensors.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/data/model/model_lobby.dart';
import 'package:sonr_app/modules/common/peer/peer.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

class LobbyService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<LobbyService>();
  static LobbyService get to => Get.find<LobbyService>();

  // @ Set Properties
  final _flatModeCancelled = false.obs;
  final _lastIsFacingFlat = false.obs;
  final _isFlatMode = false.obs;
  final _lobbies = RxList<LobbyModel>();
  final _local = Rx<LobbyModel>(null);
  final _localFlatPeers = RxMap<String, Peer>();
  final _localSize = 0.obs;
  final _position = Rx<VectorPosition>(null);
  final counter = 0.0.obs;
  final flatOverlayIndex = (-1).obs;

  // @ Routing to Reactive
  static RxBool get isFlatMode => Get.find<LobbyService>()._isFlatMode;
  static RxList<LobbyModel> get lobbies => Get.find<LobbyService>()._lobbies;
  static Rx<LobbyModel> get local => Get.find<LobbyService>()._local;
  static RxInt get localSize => Get.find<LobbyService>()._localSize;
  static Rx<VectorPosition> get userPosition => to._position;

  // @ References
  bool get _flatModeEnabled => !_flatModeCancelled.value && UserService.flatModeEnabled && Get.currentRoute != "/transfer";
  StreamSubscription<AccelerometerEvent> _accelStream;
  StreamSubscription<CompassEvent> _compassStream;
  Timer _timer;

  // # Initialize Service Method ^ //
  Future<LobbyService> init() async {
    _accelStream = DeviceService.accelerometer.listen(_handleAccelStream);
    _compassStream = DeviceService.compass.listen(_handleCompassStream);
    return this;
  }

  // # On Service Close //
  @override
  void onClose() {
    _accelStream.cancel();
    _compassStream.cancel();
    super.onClose();
  }

  // ^ Method to Cancel Flat Mode ^ //
  void cancelFlatMode() {
    // Reset Timers
    _flatModeCancelled(true);
    _resetTimer();
    Get.back();
    Future.delayed(25.seconds, () {
      _flatModeCancelled(false);
    });
  }

  // ^ Method to Listen to Specified Peer ^ //
  static AsyncSnapshot<Peer> usePeer<T>(Peer peer) {
    return useStream(PeerStream(peer, local.value).stream, initialData: peer);
  }

  // ^ Method to Listen to Specified Lobby ^ //
  static AsyncSnapshot<LobbyModel> useRemoteLobby<T>(RemoteInfo remote) {
    return useStream(LobbyStream(remote).stream, initialData: LobbyModel());
  }

  // ^ Method to Listen to Specified Peer ^ //
  static PeerStream listenToPeer(Peer peer, {Lobby lobby}) {
    return PeerStream(peer, lobby != null ? lobby : local.value);
  }

  // ^ Method to Cancel Flat Mode ^ //
  bool sendFlatMode(Peer peer) {
    // Send Invite
    SonrService.sendFlat(peer);

    // Reset Timers
    _flatModeCancelled(true);
    _resetTimer();
    Future.delayed(15.seconds, () {
      _flatModeCancelled(false);
    });
    var flatPeer = LobbyService.local.value.firstFlat();
    SonrSnack.success("Sent Contact to ${flatPeer.profile.firstName}");
    Get.back();
    return true;
  }

  // # Handle Lobby Update //
  void handleRefresh(Lobby data) {
    // @ Update Local Topics
    if (data.isLocal) {
      // Update Local
      _handleFlatPeers(data);
      _local(LobbyModel(lobby: data));
      _localSize(data.count);

      // Refresh Values
      _local.refresh();
      _localSize.refresh();
    }

    // @ Update Other Topics
    else {
      _lobbies.add(LobbyModel(lobby: data));
      _lobbies.refresh();
    }
  }

  // # Handle Lobby Event //
  void handleEvent(LobbyEvent data) {
    // @ Update Local Topics
    if (data.event == LobbyEvent_Event.MESSAGE) {
      print(data.message);
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
    if (_flatModeEnabled) {
      var newIsFacingFlat = data.y < 2.75;
      if (newIsFacingFlat != _lastIsFacingFlat.value) {
        if (newIsFacingFlat) {
          _startTimer();
          _lastIsFacingFlat(data.y < 2.75);
        } else {
          _resetTimer();
        }
      }
    }
  }

  void _handleCompassStream(CompassEvent data) {
    // Set Vector Position
    _position(VectorPosition.fromQuadruple(DeviceService.direction));
  }

  // # Begin Facing Invite Check
  void _startTimer() {
    _timer = Timer.periodic(500.milliseconds, (_) {
      // Add MS to Counter
      counter(counter.value += 500);

      // Check if Facing
      if (counter.value == 2000) {
        if (_lastIsFacingFlat.value) {
          // Update Refs
          _isFlatMode(true);
          SonrService.setFlatMode(true);

          // Present View
          if (_localFlatPeers.length == 0 && !_flatModeCancelled.value) {
            FlatMode.outgoing();
          } else {
            _resetTimer();
          }
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
