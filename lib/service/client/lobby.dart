import 'dart:async';
import 'package:get/get.dart' hide Node;
import 'package:sonr_app/service/device/mobile.dart';
import 'package:sonr_app/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

class LobbyService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<LobbyService>();
  static LobbyService get to => Get.find<LobbyService>();

  // @ Set Properties
  final _flatModeCancelled = false.obs;
  final _lastIsFacingFlat = false.obs;
  final _isFlatMode = false.obs;
  final _lobbies = RxList<Lobby>();
  final _local = Lobby().obs;
  final _localFlatPeers = RxMap<String, Peer>();
  final _position = Position().obs;
  final counter = 0.0.obs;
  final flatOverlayIndex = (-1).obs;

  // @ Routing to Reactive
  static RxBool get isFlatMode => Get.find<LobbyService>()._isFlatMode;
  static RxList<Lobby> get lobbies => Get.find<LobbyService>()._lobbies;
  static Rx<Lobby> get local => Get.find<LobbyService>()._local;

  // @ References
  bool get _flatModeEnabled => !_flatModeCancelled.value && UserService.flatModeEnabled && Get.currentRoute != "/transfer";
  StreamSubscription<Position>? _positionStream;
  Timer? _timer;
  Map<String, LobbyCallback> _lobbyCallbacks = <String, LobbyCallback>{};
  Map<Peer?, PeerCallback> _peerCallbacks = <Peer?, PeerCallback>{};

  // # Initialize Service Method
  Future<LobbyService> init() async {
    if (DeviceService.isMobile) {
      _positionStream = MobileService.position.listen(_handlePosition);
    }
    return this;
  }

  // # On Service Close //
  @override
  void onClose() {
    if (_positionStream != null) {
      _positionStream!.cancel();
    }
    super.onClose();
  }

  /// @ Method to Cancel Flat Mode
  void cancelFlatMode() {
    // Reset Timers
    _flatModeCancelled(true);
    _resetTimer();
    Get.back();
    Future.delayed(25.seconds, () {
      _flatModeCancelled(false);
    });
  }

  /// @ Registers RemoteResponse to Lobby to Manage Callback
  static void registerRemoteCallback(String topic, LobbyCallback callback) {
    // Check if Found
    to._lobbyCallbacks[topic] = callback;
  }

  /// @ Registers Peer to Callback
  static void registerPeerCallback(Peer peer, PeerCallback callback) {
    to._peerCallbacks[peer] = callback;
  }

  /// @ Removes Lobby Callback
  static void unregisterRemoteCallback(Lobby lobby) {
    if (to._lobbyCallbacks.containsKey(lobby)) {
      to._lobbyCallbacks.remove(lobby);
    }
  }

  /// @ Removes Peer Callback
  static void unregisterPeerCallback(Peer? peer) {
    if (to._peerCallbacks.containsKey(peer)) {
      to._peerCallbacks.remove(peer);
    }
  }

  /// @ Method to Cancel Flat Mode
  bool sendFlatMode(Peer? peer) {
    // Send Invite
    SonrService.sendFlat(peer);

    // Reset Timers
    _flatModeCancelled(true);
    _resetTimer();
    Future.delayed(15.seconds, () {
      _flatModeCancelled(false);
    });
    var flatPeer = LobbyService.local.value.flatFirst()!;
    Snack.success("Sent Contact to ${flatPeer.profile.firstName}");
    Get.back();
    return true;
  }

  // # Handle Lobby Update //
  void handleRefresh(Lobby data) {
    // @ Callbacks
    // Handle Lobby Callbacks
    if (_lobbyCallbacks.containsKey(data)) {
      var call = _lobbyCallbacks[data]!;
      call(data);
    }

    // Handle Peer Callbacks
    data.peers.forEach((id, peer) {
      if (_peerCallbacks.containsKey(peer)) {
        var call = _peerCallbacks[peer]!;
        call(peer);
      }
    });

    // @ Update Local Topics
    if (data.type == Lobby_Type.LOCAL) {
      // Update Flat Peers
      _handleFlatPeers(data);

      // Set Lobby
      _local(data);

      // Refresh Values
      _local.refresh();
    }

    // @ Update Remote Topics
    else if (data.type == Lobby_Type.REMOTE && data.hasRemote()) {
      // Check for callback
      if (_lobbyCallbacks.containsKey(data.remote.topic)) {
        _lobbyCallbacks[data.remote.topic]!(data);
      }
    }
  }

  // # Handle Lobby Flat Peers
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

  // # Handle Incoming Position Stream
  void _handlePosition(Position data) {
    // Update Orientation
    if (_flatModeEnabled && _localFlatPeers.length > 0) {
      var newIsFacingFlat = data.accelerometer.y < 2.75;
      if (newIsFacingFlat != _lastIsFacingFlat.value) {
        if (newIsFacingFlat) {
          _startTimer();
          _lastIsFacingFlat(data.accelerometer.y < 2.75);
        } else {
          _resetTimer();
        }
      }
    }

    // Set Vector Position
    _position(data);
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
      _timer!.cancel();
      _timer = null;
      _lastIsFacingFlat(false);
      counter(0);
    }
  }
}
