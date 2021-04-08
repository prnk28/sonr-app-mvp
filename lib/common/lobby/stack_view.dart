import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonr_app/data/model/model_lobby.dart';
import 'package:sonr_app/pages/transfer/transfer_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import '../../common/peer/bubble_view.dart';


// ^ Local Lobby Stack View ^ //
class LocalLobbyStack extends StatefulWidget {
  final TransferController transfer;

  const LocalLobbyStack(
    this.transfer, {
    Key key,
  }) : super(key: key);
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
      children.add(PeerBubble(peer, widget.transfer));
    });

    // Update View
    setState(() {
      lobbySize = data.mobilePeers.length;
      stackChildren = children;
    });
  }
}
