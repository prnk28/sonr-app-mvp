import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/modules/common/lobby/lobby.dart';
import 'package:sonr_app/modules/common/peer/peer.dart';
import 'package:sonr_app/theme/theme.dart';
import 'compass_widget.dart';
import 'transfer_controller.dart';

// ^ Transfer Screen Entry Point ^ //
class TransferScreen extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.isRemoteActive.value) {
          return RemoteLobbyFullView(controller, info: controller.remote.value);
        } else {
          return LocalLobbyView();
        }
      },
    );
  }
}

// ^ Fullscreen Remote View ^ //
class RemoteLobbyFullView extends StatefulWidget {
  RemoteLobbyFullView(this.controller, {Key key, @required this.info}) : super(key: key);
  final RemoteInfo info;
  final TransferController controller;

  @override
  _RemoteLobbyFullViewState createState() => _RemoteLobbyFullViewState();
}

class _RemoteLobbyFullViewState extends State<RemoteLobbyFullView> {
// References
  int toggleIndex = 1;
  LobbyModel lobbyModel;
  LobbyStream peerStream;

  // * Initial State * //
  @override
  void initState() {
    // Set Stream
    peerStream = LobbyService.listenToLobby(widget.info);
    peerStream.listen(_handlePeerUpdate);
    super.initState();
  }

  // * On Dispose * //
  @override
  void dispose() {
    peerStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SonrScaffold.appBarLeadingAction(
        disableDynamicLobbyTitle: true,
        titleWidget: _buildTitleWidget(),
        leading: ShapeButton.circle(icon: SonrIcon.close, onPressed: () => Get.back(closeOverlays: true), shape: NeumorphicShape.flat),
        action: ShapeButton.circle(icon: SonrIcon.leave, onPressed: () => widget.controller.stopRemote(), shape: NeumorphicShape.flat),
        body: ListView.builder(
          itemCount: lobbyModel != null ? lobbyModel.length + 1 : 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return LobbyTitleView(
                onChanged: (index) {
                  setState(() {
                    toggleIndex = index;
                  });
                },
                title: widget.info.display,
              );
            } else {
              // Build List Item
              return PeerListItem(
                lobbyModel.atIndex(index - 1),
                index - 1,
                remote: widget.info,
              );
            }
          },
        ));
  }

  Widget _buildTitleWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      SonrText.appBar("Remote"),
      IconButton(
        icon: Icon(Icons.info_outline),
        onPressed: () {
          SonrSnack.remote(message: widget.info.display, duration: 12000);
        },
      )
    ]);
  }

  _handlePeerUpdate(LobbyModel lobby) {
    // Update View
    setState(() {
      lobbyModel = lobby;
    });
  }
}

// ^ Local Lobby View ^ //
class LocalLobbyView extends GetView<TransferController> {
  const LocalLobbyView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => SonrScaffold.appBarLeadingAction(
          disableDynamicLobbyTitle: true,
          titleWidget: GestureDetector(child: SonrText.appBar(controller.title.value), onTap: () => Get.bottomSheet(LobbySheet())),
          leading: ShapeButton.circle(icon: SonrIcon.close, onPressed: () => Get.back(closeOverlays: true), shape: NeumorphicShape.flat),
          action: Get.find<SonrService>().payload != Payload.CONTACT
              ? ShapeButton.circle(icon: SonrIcon.remote, onPressed: () async => controller.startRemote(), shape: NeumorphicShape.flat)
              : Container(),
          body: GestureDetector(
            onDoubleTap: () => controller.toggleBirdsEye(),
            child: Stack(
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
                LobbyService.localSize.value > 0 ? _LocalLobbyStack() : Container(),

                // @ Compass View
                Padding(
                  padding: EdgeWith.bottom(32.0),
                  child: GestureDetector(
                    onTap: () {
                      controller.toggleShifting();
                    },
                    child: CompassView(),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

// ^ Local Lobby Stack View ^ //
class _LocalLobbyStack extends StatefulWidget {
  const _LocalLobbyStack({Key key}) : super(key: key);
  @override
  _LocalLobbyStackState createState() => _LocalLobbyStackState();
}

class _LocalLobbyStackState extends State<_LocalLobbyStack> {
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
      children.add(PeerBubble(peer));
    });

    // Update View
    setState(() {
      lobbySize = data.mobilePeers.length;
      stackChildren = children;
    });
  }
}
