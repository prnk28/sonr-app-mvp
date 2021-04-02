import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonr_app/theme/theme.dart';
import 'peer_widget.dart';

// ^ Local Lobby Stack View ^ //
class LocalLobbyStack extends StatefulWidget {
  @override
  _LocalLobbyStackState createState() => _LocalLobbyStackState();
}

class _LocalLobbyStackState extends State<LocalLobbyStack> {
  // References
  int lobbySize = 0;
  List<PeerBubble> stackChildren = <PeerBubble>[];
  StreamSubscription<Lobby> localLobbyStream;

  // * Initial State * //
  @override
  void initState() {
    // Add Initial Data
    _handleLobbyUpdate(LobbyService.local.value);

    // Set Stream
    localLobbyStream = LobbyService.local.listen(_handleLobbyUpdate);
    super.initState();
  }

  // * On Dispose * //
  @override
  void dispose() {
    localLobbyStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OpacityAnimatedWidget(duration: 150.milliseconds, child: Stack(children: stackChildren), enabled: true);
  }

  // * Updates Stack Children * //
  _handleLobbyUpdate(Lobby data) {
    // Initialize
    var children = <PeerBubble>[];

    // Clear List
    stackChildren.clear();

    // Iterate through peers and IDs
    data.peers.forEach((id, peer) {
      // Add to Stack Items
      if (peer.platform == Platform.Android || peer.platform == Platform.iOS) {
        children.add(PeerBubble(peer, stackChildren.length - 1));
      }
    });

    // Update View
    setState(() {
      lobbySize = data.size;
      stackChildren = children;
    });
  }
}

// ^ Switched Lobby View ^ //
class RemoteLobbyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: LobbyService.localSize.value,
        itemBuilder: (context, idx) {
          return Column(children: [
            SonrText.title("Handling Remote..."),
          ]);
        });
  }
}

// ^ Sheet Lobby View ^ //
class LobbySheet extends StatefulWidget {
  @override
  _LobbySheetState createState() => _LobbySheetState();
}

class _LobbySheetState extends State<LobbySheet> {
  // References
  int lobbySize = 0;
  int toggleIndex = 1;
  List<Peer> allPeers = <Peer>[];
  List<Peer> desktopPeers = <Peer>[];
  List<Peer> mobilePeers = <Peer>[];
  StreamSubscription<Lobby> peerStream;

  // * Initial State * //
  @override
  void initState() {
    // Add Initial Data
    _handlePeerUpdate(LobbyService.local.value);

    // Set Stream
    peerStream = LobbyService.local.listen(_handlePeerUpdate);
    super.initState();
  }

  // * On Dispose * //
  @override
  void dispose() {
    peerStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set Current List
    var peerList;
    if (toggleIndex == 1) {
      peerList = allPeers;
    } else if (toggleIndex == 0) {
      peerList = mobilePeers;
    } else if (toggleIndex == 2) {
      peerList = desktopPeers;
    }

    // Build View
    return NeumorphicBackground(
        backendColor: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: Neumorphic(
            style: SonrStyle.normal,
            child: ListView.builder(
              itemCount: peerList.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return _buildTitle();
                } else {
                  // Build List Item
                  return Column(children: [
                    PeerListItem(peerList[index - 1], index - 1),
                    Padding(
                      padding: EdgeInsets.all(8),
                    )
                  ]);
                }
              },
            )));
  }

  // ^ Builds Title View ^ //
  Widget _buildTitle() {
    return Column(children: [
      // Build Title
      Padding(padding: EdgeInsetsX.top(8)),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [SonrIcon.location, Padding(padding: EdgeInsetsX.right(16)), SonrText.title("Local Lobby")]),

      // Build Toggle View
      Container(
        padding: EdgeInsets.only(top: 8),
        margin: EdgeInsetsX.horizontal(24),
        child: NeumorphicToggle(
          duration: 100.milliseconds,
          style: NeumorphicToggleStyle(depth: 20, backgroundColor: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White),
          thumb: Neumorphic(style: SonrStyle.toggle),
          selectedIndex: toggleIndex,
          onChanged: (val) {
            setState(() {
              toggleIndex = val;
            });
          },
          children: [
            ToggleElement(
                background: Center(child: SonrText.medium("Mobile", color: SonrColor.Grey, size: 18)),
                foreground: SonrIcon.neumorphicGradient(Icons.smartphone, FlutterGradientNames.newRetrowave, size: 24)),
            ToggleElement(
                background: Center(child: SonrText.medium("All", color: SonrColor.Grey, size: 18)),
                foreground: SonrIcon.neumorphicGradient(
                    Icons.group, UserService.isDarkMode ? FlutterGradientNames.happyUnicorn : FlutterGradientNames.eternalConstance,
                    size: 22.5)),
            ToggleElement(
                background: Center(child: SonrText.medium("Desktop", color: SonrColor.Grey, size: 18)),
                foreground: SonrIcon.neumorphicGradient(Icons.computer, FlutterGradientNames.orangeJuice, size: 24)),
          ],
        ),
      ),

      Padding(padding: EdgeInsets.only(top: 24))
    ]);
  }

  // ^ Updates Stack Children ^ //
  _handlePeerUpdate(Lobby lobby) {
    // Initialize
    var total = <Peer>[];
    var mobile = <Peer>[];
    var desktop = <Peer>[];

    // Clear Lists
    allPeers.clear();
    mobilePeers.clear();
    desktopPeers.clear();

    // Iterate through peers and IDs
    lobby.peers.forEach((id, peer) {
      total.add(peer);
      // Add to Peer Lists
      if (peer.isOnMobile) {
        mobile.add(peer);
      } else if (peer.isOnDesktop) {
        desktop.add(peer);
      }
    });

    // Update View
    setState(() {
      lobbySize = lobby.size;
      allPeers = total;
      mobilePeers = mobile;
      desktopPeers = desktop;
    });
  }
}
