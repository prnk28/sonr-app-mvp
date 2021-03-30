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
          titleWidget: GestureDetector(child: SonrText.appBar(controller.title.value), onTap: () => controller.toggleLobbySheet()),
          leading: SonrButton.circle(icon: SonrIcon.close, onPressed: () => Get.offNamed("/home/transfer"), shape: NeumorphicShape.flat),
          action: Get.find<SonrService>().payload != Payload.CONTACT
              ? SonrButton.circle(icon: SonrIcon.remote, onPressed: () async => controller.startRemote(), shape: NeumorphicShape.flat)
              : Container(),
          body: GestureDetector(
            onDoubleTap: () => controller.toggleBirdsEye(),
            child: controller.isRemoteActive.value
                ? RemoteLobbyView()
                : Stack(
                    children: <Widget>[
                      // @ Range Lines
                      Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Stack(
                            children: [
                              Neumorphic(style: SonrStyle.zonePath(proximity: Position_Proximity.Distant)),
                              Neumorphic(style: SonrStyle.zonePath(proximity: Position_Proximity.Near)),
                            ],
                          )),

                      // @ Lobby View
                      LocalLobbyStack(),

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
    return PlayAnimation<double>(
        tween: (0.0).tweenTo(1.0),
        duration: 150.milliseconds,
        builder: (context, child, value) {
          return AnimatedOpacity(opacity: value, duration: 150.milliseconds, child: Stack(children: stackChildren));
        });
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
  List<Peer> peerList = <Peer>[];
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
    return DraggableScrollableSheet(
      maxChildSize: 0.85,
      minChildSize: 0.25,
      initialChildSize: 0.5,
      builder: (BuildContext context, scrollController) {
        return NeumorphicBackground(
            backendColor: Colors.transparent,
            child: Neumorphic(
                child: ListView.builder(
              controller: scrollController,
              itemCount: peerList.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [SonrIcon.profile, Padding(padding: EdgeInsetsX.right(16)), SonrText.title("All Peers")]);
                } else {
                  return ListTile(
                    title: peerList[index - 1].fullName,
                    subtitle: peerList[index - 1].platformExpanded,
                  );
                }
              },
            )));
      },
    );
  }

  // ^ Updates Stack Children ^ //
  _handlePeerUpdate(Lobby lobby) {
    // Initialize
    var children = <Peer>[];

    // Clear List
    peerList.clear();

    // Iterate through peers and IDs
    lobby.peers.forEach((id, peer) {
      // Add to Stack Items
      if (peer.platform != Platform.Android || peer.platform != Platform.iOS) {
        children.add(peer);
      }
    });

    // Update View
    setState(() {
      lobbySize = lobby.size;
      peerList = children;
    });
  }
}
