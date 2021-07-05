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

  /// Check if Users have Joined
  bool get hasJoined => differenceCount > 0;

  /// Check if Users have Left
  bool get hasLeft => !hasJoined;

  // Constructer: Takes Last Lobby and New Lobby
  LobbyInfo({this.lastLobby, this.newLobby}) {
    //_fetchLocation();
  }
}
