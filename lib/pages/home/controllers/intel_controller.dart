import 'dart:async';
import 'package:sonr_app/modules/peer/peer.dart';
import 'package:sonr_app/style/style.dart';

class IntelController extends GetxController with StateMixin<CompareLobbyResult> {
  // Properties
  final title = "".obs;
  final badgeVisible = false.obs;

  // Streams
  late StreamSubscription<Lobby?> _lobbyStream;
  late StreamSubscription<Status> _statusStream;

  // References
  Lobby _lastLobby = LobbyService.lobby.value;

  /// @ Controller Constructer
  @override
  onInit() {
    // Listen to Streams
    _lobbyStream = LobbyService.lobby.listen(_handleLobbyStream);
    _statusStream = NodeService.status.listen(_handleStatusStream);

    // Set Default Values
    _handleStatusStream(NodeService.status.value);

    // Initialize
    super.onInit();
  }

  /// @ On Dispose
  @override
  void onClose() {
    _lobbyStream.cancel();
    _statusStream.cancel();
    super.onClose();
  }

  // @ Handle Size Update
  void _handleLobbyStream(Lobby onData) {
    // Check Valid
    final compareResult = CompareLobbyResult(current: onData, previous: _lastLobby);

    // Swap Text
    HapticFeedback.mediumImpact();
    badgeVisible(true);

    // Revert Text
    Future.delayed(1200.milliseconds, () {
      if (!isClosed) {
        badgeVisible(false);
      }
    });

    // Change State
    change(
      compareResult,
      status: onData.isEmpty ? RxStatus.empty() : RxStatus.success(),
    );

    // Update Reference
    _lastLobby = onData;
  }

  void _handleStatusStream(Status onData) {
    if (onData.isConnected) {
      // Update Title
      DeviceService.location.then((location) {
        location.initPlacemark().then((result) {
          if (result) {
            if (location.placemark.subLocality.isNotEmpty) {
              title(location.placemark.subLocality);
            } else if (location.placemark.locality.isNotEmpty) {
              title(location.placemark.locality);
            } else if (location.placemark.name.isNotEmpty) {
              title(location.placemark.name);
            }
          } else {
            title('Welcome');
          }
        });
      });

      // Check Lobby Size
      _handleLobbyStream(LobbyService.lobby.value);
    } else if (onData == Status.FAILED) {
      title("Failed");
    } else {
      title("Connecting");
    }
  }
}


extension CompareLobbyResultUtil on CompareLobbyResult {
  List<Widget> mapNearby() {
    if (this.current != null) {
      if (hasMoreThanVisible) {
        final firstValues = this.current!.peers.values.take(4).toList();
        return firstValues.map<Widget>((value) => PeerItem.mini(value)).toList();
      } else {
        return this.current!.peers.values.map<Widget>((value) => PeerItem.mini(value)).toList();
      }
    } else {
      return [];
    }
  }

  Widget text() {
    if (!this.hasStayed) {
      return FadeIn(
        animate: true,
        child: this.differenceCount.toString().light(
              color: this.hasJoined ? SonrColor.Tertiary : SonrColor.Critical,
            ),
      );
    } else {
      return Container();
    }
  }

  Widget icon() {
    if (this.hasJoined) {
      return Center(
        child: FadeInUp(
          animate: true,
          duration: 300.milliseconds,
          child: SonrIcons.Up.icon(
            color: AppTheme.itemColor,
            size: 14,
          ),
        ),
      );
    } else if (this.hasLeft) {
      return Center(
        child: FadeInDown(
          animate: true,
          from: 40,
          duration: 300.milliseconds,
          child: SonrIcons.Down.icon(
            color: SonrColor.Critical,
            size: 14,
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
