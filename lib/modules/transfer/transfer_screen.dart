import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'compass_view.dart';
import 'group_view.dart';
import 'peer_widget.dart';
import 'transfer_controller.dart';

class TransferScreen extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => SonrScaffold.appBarLeadingAction(
          title: controller.title.value,
          leading: SonrButton.circle(
            icon: SonrIcon.close,
            onPressed: () => Get.offNamed("/home/transfer"),
            shape: NeumorphicShape.flat,
          ),
          action: SonrButton.circle(
              icon: SonrIcon.add,
              onPressed: () async {
                String name = await SonrService.createGroup();
                print("New Group Name $name");
                SonrOverlay.show(GroupView(name));
              }),
          body: GestureDetector(
            onDoubleTap: () => controller.toggleBirdsEye(),
            child: Stack(
              children: <Widget>[
                // @ Range Lines
                Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Stack(
                      children: [
                        Neumorphic(style: SonrStyle.zonePath(proximity: Position_Proximity.Distant)),
                        Neumorphic(style: SonrStyle.zonePath(proximity: Position_Proximity.Near)),
                        Neumorphic(style: SonrStyle.zonePath(proximity: Position_Proximity.Immediate)),
                      ],
                    )),

                // @ Lobby View
                PlayAnimation<double>(
                    tween: (0.0).tweenTo(1.0),
                    duration: 150.milliseconds,
                    builder: (context, child, value) {
                      return AnimatedOpacity(opacity: value, duration: 150.milliseconds, child: LobbyStack());
                    }),

                // @ Compass View
                Padding(
                  padding: EdgeInsetsX.bottom(16.0),
                  child: CompassView(),
                ),
              ],
            ),
          ),
        ));
  }
}

class LobbyStack extends StatefulWidget {
  @override
  _LobbyStackState createState() => _LobbyStackState();
}

class _LobbyStackState extends State<LobbyStack> {
  // References
  int lobbySize = 0;
  List<PeerBubble> stackChildren = <PeerBubble>[];
  StreamSubscription<Map<String, Peer>> peerStream;

  // * Initial State * //
  @override
  void initState() {
    // Add Initial Data
    _handlePeerUpdate(SonrService.peers);

    // Set Stream
    peerStream = SonrService.peers.listen(_handlePeerUpdate);
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
    return Stack(children: stackChildren);
  }

  // ^ Updates Stack Children ^ //
  _handlePeerUpdate(Map<String, Peer> lobby) {
    // Initialize
    var children = <PeerBubble>[];

    // Check if Lobby has Changed
    if (lobby.length != lobbySize) {
      // Clear List
      stackChildren.clear();

      // Iterate through peers and IDs
      lobby.forEach((id, peer) {
        // Add to Stack Items
        children.add(PeerBubble(peer, stackChildren.length - 1));
      });

      // Update View
      setState(() {
        lobbySize = lobby.length;
        stackChildren = children;
      });
    }
  }
}
