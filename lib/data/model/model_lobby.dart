import 'package:sonr_core/sonr_core.dart';
import 'package:sonr_app/theme/theme.dart';

class LobbyModel {
  List<Peer> allPeers = <Peer>[];
  List<Peer> desktopPeers = <Peer>[];
  List<Peer> mobilePeers = <Peer>[];
  Map<String, Peer> flatPeers = <String, Peer>{};

  bool get isEmpty => lobby.count == 0;
  bool get isLocal => lobby.isLocal;
  String get name => lobby.name;
  int get size => lobby.size;
  int get length => lobby.peers.length;

  final Lobby lobby;

  LobbyModel(this.lobby) {
    // Iterate through peers and IDs
    lobby.peers.forEach((id, peer) {
      allPeers.add(peer);

      // Add to Peer Lists
      if (peer.isOnMobile) {
        mobilePeers.add(peer);
      } else if (peer.isOnDesktop) {
        desktopPeers.add(peer);
      }
    });

    // Check if Local Lobby
    if (lobby.isLocal) {
      lobby.peers.forEach((id, peer) {
        if (peer.properties.isFlatMode) {
          flatPeers[id] = peer;
        }
      });
    }
  }

  Peer atIndex(int i) {
    return allPeers[i];
  }

  List<Peer> getAndroidPeers() {
    var list = <Peer>[];
    lobby.peers.forEach((id, peer) {
      if (peer.platform == Platform.Android) {
        list.add(peer);
      }
    });
    return list;
  }

  List<Peer> getIOSPeers() {
    var list = <Peer>[];
    lobby.peers.forEach((id, peer) {
      if (peer.platform == Platform.iOS) {
        list.add(peer);
      }
    });
    return list;
  }

  List<Peer> getMacPeers() {
    var list = <Peer>[];
    lobby.peers.forEach((id, peer) {
      if (peer.platform == Platform.MacOS) {
        list.add(peer);
      }
    });
    return list;
  }

  List<Peer> getWindowsPeers() {
    var list = <Peer>[];
    lobby.peers.forEach((id, peer) {
      if (peer.platform == Platform.Windows) {
        list.add(peer);
      }
    });
    return list;
  }
}
