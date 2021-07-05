import 'package:sonr_app/modules/peer/peer.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import 'package:sonr_app/style/style.dart';

class LobbyInfo {
  /// Last Lobby Reference
  final Lobby? lastLobby;

  /// New Lobby Reference
  final Lobby? newLobby;

  // @ Calculations
  /// Fetch Difference Count
  int get differenceCount {
    if (lastLobby != null && newLobby != null) {
      return lastLobby!.count - newLobby!.count;
    } else if (newLobby != null) {
      return newLobby!.count;
    } else {
      return 0;
    }
  }

  /// Check whether more label required
  bool get needsMoreLabel {
    if (newLobby != null) {
      return newLobby!.count > 4;
    } else {
      return false;
    }
  }

  /// Check if Users have Joined
  bool get hasJoined => differenceCount > 0;

  /// Check if Users have Left
  bool get hasLeft => differenceCount < 0;

  /// Checks wether Lobby has stayed same
  bool get hasStayed => differenceCount == 0;

  /// Returns Count of Additional Peers excluding first 4.
  int get additionalPeers {
    if (this.newLobby != null) {
      final diffCount = this.newLobby!.count - 4;
      return diffCount > 0 ? diffCount : 0;
    }
    return 0;
  }

  // Constructer: Takes Last Lobby and New Lobby
  LobbyInfo({this.lastLobby, this.newLobby});

  List<Widget> mapNearby() {
    if (this.newLobby != null) {
      if (needsMoreLabel) {
        final firstValues = this.newLobby!.peers.values.take(4).toList();
        return firstValues.map<Widget>((value) => PeerItem.mini(value)).toList();
      } else {
        return this.newLobby!.peers.values.map<Widget>((value) => PeerItem.mini(value)).toList();
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
          from: 40,
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
