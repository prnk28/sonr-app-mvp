import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonr_app/data/model/model_lobby.dart';
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
  StreamSubscription<LobbyModel> localLobbyStream;

  // * Initial State * //
  @override
  void initState() {
    // Add Initial Data
    _handleLobbyUpdate(LobbyService.local.value);
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
    if (lobbySize > 0) {
      return OpacityAnimatedWidget(duration: 150.milliseconds, child: Stack(children: stackChildren), enabled: true);
    } else {
      return Container();
    }
  }

  // * Updates Stack Children * //
  _handleLobbyUpdate(LobbyModel data) {
    // Initialize
    var children = <PeerBubble>[];

    // Clear List
    stackChildren.clear();

    // Iterate through peers and IDs
    data.mobilePeers.forEach((peer) {
      // Add to Stack Items
      children.add(PeerBubble(peer, stackChildren.length - 1));
    });

    // Update View
    setState(() {
      lobbySize = data.size;
      stackChildren = children;
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
  LobbyModel lobby;
  int toggleIndex = 1;
  StreamSubscription<LobbyModel> peerStream;

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
    // Build View
    return NeumorphicBackground(
        backendColor: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: Neumorphic(
            style: SonrStyle.normal,
            child: ListView.builder(
              itemCount: lobby != null ? lobby.length + 1 : 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return LobbyTitleView(
                    title: "Local Lobby",
                    onChanged: (index) {
                      setState(() {
                        toggleIndex = index;
                      });
                    },
                  );
                } else {
                  // Build List Item
                  return Column(children: [
                    PeerListItem(lobby.atIndex(index - 1), index - 1),
                    Padding(
                      padding: EdgeInsets.all(8),
                    )
                  ]);
                }
              },
            )));
  }

  // ^ Updates Stack Children ^ //
  _handlePeerUpdate(LobbyModel data) {
    // Update View
    setState(() {
      lobby = data;
    });
  }
}

// ^ Lobby Title View ^ //
class LobbyTitleView extends StatefulWidget {
  final Function(int) onChanged;
  final String title;
  const LobbyTitleView({Key key, @required this.onChanged, this.title = ''}) : super(key: key);

  @override
  _LobbyTitleViewState createState() => _LobbyTitleViewState();
}

class _LobbyTitleViewState extends State<LobbyTitleView> {
  int toggleIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Build Title
      widget.title != '' ? Padding(padding: EdgeInsetsX.top(8)) : Container(),
      widget.title != ''
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [SonrIcon.location, Padding(padding: EdgeInsetsX.right(16)), SonrText.title(widget.title)])
          : Container(),

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
            widget.onChanged(val);
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
}
