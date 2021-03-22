import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'compass_view.dart';
import 'peer_widget.dart';
import 'transfer_controller.dart';

class TransferScreen extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => SonrScaffold.appBarLeadingAction(
          disableDynamicLobbyTitle: true,
          title: controller.title.value,
          leading: SonrButton.circle(icon: SonrIcon.close, onPressed: () => Get.offNamed("/home/transfer"), shape: NeumorphicShape.flat),
          action: Get.find<SonrService>().payload != Payload.CONTACT
              ? SonrButton.circle(icon: SonrIcon.remote, onPressed: () async => controller.startRemote(), shape: NeumorphicShape.flat)
              : Container(),
          // bottomSheet: LobbySheet(),
          body: GestureDetector(
            onDoubleTap: () => controller.toggleBirdsEye(),
            child: controller.isRemoteActive.value
                ? RemoteView()
                : Stack(
                    children: <Widget>[
                      // @ Range Lines
                      Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Stack(
                            children: [
                              Neumorphic(style: SonrStyle.zonePath(proximity: Position_Proximity.Distant)),
                              Neumorphic(style: SonrStyle.zonePath(proximity: Position_Proximity.Near)),
                              //Neumorphic(style: SonrStyle.zonePath(proximity: Position_Proximity.Immediate)),
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
                        padding: EdgeInsetsX.bottom(64.0),
                        child: CompassView(),
                      ),
                    ],
                  ),
          ),
        ));
  }
}

class LobbySheet extends StatefulWidget {
  @override
  _LobbySheetState createState() => _LobbySheetState();
}

class _LobbySheetState extends State<LobbySheet> {
  // References
  int lobbySize = 0;
  List<Peer> peerList = <Peer>[];
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
    return DraggableScrollableSheet(
      maxChildSize: 0.7,
      minChildSize: 0.1,
      initialChildSize: 0.1,
      expand: false,
      builder: (BuildContext context, scrollController) {
        return ListView.builder(
          controller: scrollController,
          itemCount: peerList.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [SonrIcon.profile, Padding(padding: EdgeInsetsX.right(16)), SonrText.title("Other Peers")]);
            } else {
              return ListTile(
                title: peerList[index - 1].fullName,
                subtitle: peerList[index - 1].platformExpanded,
                onTap: SonrService.inviteFromList(peerList[index - 1]),
              );
            }
          },
        );
      },
    );
  }

  // ^ Updates Stack Children ^ //
  _handlePeerUpdate(Map<String, Peer> lobby) {
    // Initialize
    var children = <Peer>[];

    // Clear List
    peerList.clear();

    // Iterate through peers and IDs
    lobby.forEach((id, peer) {
      // Add to Stack Items
      if (peer.platform != Platform.Android || peer.platform != Platform.iOS) {
        children.add(peer);
      }
    });

    // Update View
    setState(() {
      lobbySize = lobby.length;
      peerList = children;
    });
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

    // Clear List
    stackChildren.clear();

    // Iterate through peers and IDs
    lobby.forEach((id, peer) {
      // Add to Stack Items
      if (peer.platform == Platform.Android || peer.platform == Platform.iOS) {
        children.add(PeerBubble(peer, stackChildren.length - 1));
      }
    });

    // Update View
    setState(() {
      lobbySize = lobby.length;
      stackChildren = children;
    });
  }
}

class RemoteView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SonrText.title("Handling Remote..."),
    ]);
  }
}
