import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/data/model/model_file.dart';
import 'package:sonr_app/modules/common/lobby/lobby.dart';
import 'package:sonr_app/modules/common/peer/peer.dart';
import 'package:sonr_app/theme/theme.dart';
import 'compass_widget.dart';
import 'transfer_controller.dart';

// ^ Transfer Screen Entry with Arguments ^ //
class Transfer {
  static void transferWithContact() {
    Get.offNamed("/transfer", arguments: TransferArguments(Payload.CONTACT, contact: UserService.contact.value));
  }

  static void transferWithFile(FileItem fileItem) {
    Get.offNamed("/transfer", arguments: TransferArguments(fileItem.payload, metadata: fileItem.metadata));
  }

  static void transferWithUrl(String url) {
    Get.offNamed("/transfer", arguments: TransferArguments(Payload.CONTACT, url: url));
  }
}

// ^ Transfer Screen Entry Point ^ //
class TransferScreen extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    // Set Payload from Args
    controller.setPayload(Get.arguments);

    // Build View
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
        leading: PlainButton(icon: SonrIcon.close, onPressed: () => Get.back(closeOverlays: true)),
        action: PlainButton(icon: SonrIcon.leave, onPressed: () => widget.controller.stopRemote()),
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
      "Remote".h3,
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
          titleWidget: GestureDetector(child: controller.title.value.h3, onTap: () => Get.bottomSheet(LobbySheet())),
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
                _LocalLobbyStack(data: LobbyService.local.value),

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
class _LocalLobbyStack extends StatelessWidget {
  final LobbyModel data;
  _LocalLobbyStack({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize Children
    var children = <Widget>[];

    // Check for Mobile
    if (data.peers.isEmpty) {
      data.peers.forEach((peer) {
        if (peer.platform == Platform.Android || peer.platform == Platform.iOS) {
          children.add(PeerBubble(peer));
        }
      });
    } else {
      children.add(Container());
    }

    return Stack(children: children);
  }
}
