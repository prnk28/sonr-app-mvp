import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonr_app/modules/common/peer/item_view.dart';
import 'package:sonr_app/data/model/model_lobby.dart';
import 'package:sonr_app/theme/theme.dart';
import 'title_widget.dart';

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
    return Container(
        decoration: Neumorph.floating(),
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
        ));
  }

  // ^ Updates Stack Children ^ //
  _handlePeerUpdate(LobbyModel data) {
    // Update View
    setState(() {
      lobby = data;
    });
  }
}
