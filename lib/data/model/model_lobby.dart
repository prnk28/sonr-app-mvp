import 'dart:async';

import 'package:sonr_core/sonr_core.dart';
import 'package:sonr_app/theme/theme.dart';

// ^ Lobby Data Api Model ^ //
class LobbyModel {
  // Properties
  final Lobby lobby;
  List<Peer> peers = <Peer>[];
  Map<String, Peer> flatPeers = <String, Peer>{};

  // Accessors
  bool get isEmpty => lobby.count == 0;
  bool get isLocal => lobby.isLocal;
  String get name => lobby.name;
  int get size => lobby.size;
  int get length => lobby.peers.length;

  // * Constructer * //
  LobbyModel({this.lobby}) {
    if (this.lobby != null) {
      // Iterate through peers and IDs
      lobby.peers.forEach((id, peer) {
        peers.add(peer);
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
  }

  // # Check for Remote Lobby from Info
  bool isRemoteLobby(RemoteInfo info) => info.topic == this.name;

  // # Return Peer at Index for Mobile List
  Peer atFlatID(String i) => flatPeers[i];

  // # Return Peer at Index for Mobile List
  Peer firstFlat() => flatPeers.values.first;

  // # Return Peer at Index
  Peer atIndex(int i) => peers[i];

  // # Return Peer at Index
  Peer atID(Peer_ID id) {
    lobby.peers.forEach((key, value) {
      if (value.id.peer == id.peer) {
        return value;
      }
    });
    return null;
  }

  // # Return Peer at Index
  bool hasPeer(Peer peer) {
    lobby.peers.forEach((key, value) {
      return (value.id.peer == peer.id.peer);
    });
    return false;
  }

  // # Return All Android Peers
  List<Peer> getAndroidPeers() {
    var list = <Peer>[];
    lobby.peers.forEach((id, peer) {
      if (peer.platform == Platform.Android) {
        list.add(peer);
      }
    });
    return list;
  }

  // # Return All iOS Peers
  List<Peer> getIOSPeers() {
    var list = <Peer>[];
    lobby.peers.forEach((id, peer) {
      if (peer.platform == Platform.IOS) {
        list.add(peer);
      }
    });
    return list;
  }

  // # Return All Linux Peers
  List<Peer> getLinuxPeers() {
    var list = <Peer>[];
    lobby.peers.forEach((id, peer) {
      if (peer.platform == Platform.Linux) {
        list.add(peer);
      }
    });
    return list;
  }

  // # Return All MacOS Peers
  List<Peer> getMacPeers() {
    var list = <Peer>[];
    lobby.peers.forEach((id, peer) {
      if (peer.platform == Platform.MacOS) {
        list.add(peer);
      }
    });
    return list;
  }

  // # Return All Windows Peers
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

// ^ Lobby Stream Api Model ^ //
class LobbyStream {
  final RemoteInfo remote;

  LobbyStream(this.remote) {
    LobbyService.lobbies.listen((List<LobbyModel> data) {
      data.forEach((lobby) {
        if (lobby.isRemoteLobby(remote)) {
          _controller.sink.add(lobby);
        }
      });
    });
  }

  // ignore: close_sinks
  final _controller = StreamController<LobbyModel>();
  Stream<LobbyModel> get stream => _controller.stream;

  listen(Function(LobbyModel) onData) {
    _controller.stream.listen(onData);
  }

  close() {
    _controller.close();
  }
}

// ^ Peer Data Stream Api Model ^ //
class PeerStream {
  final Peer peer;
  final LobbyModel lobby;

  PeerStream(this.peer, this.lobby) {
    LobbyService.lobbies.listen((data) {
      data.forEach((lobby) {
        if (lobby.hasPeer(peer)) {
          _controller.sink.add(lobby.atID(peer.id));
        }
      });
    });
  }

  listen(Function(Peer) onData) {
    _controller.stream.listen(onData);
  }

  // ignore: close_sinks
  final _controller = StreamController<Peer>();
  Stream<Peer> get stream => _controller.stream;

  close() {
    _controller.close();
  }
}
