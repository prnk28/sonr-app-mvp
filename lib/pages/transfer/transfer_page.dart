import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
    Get.offNamed("/transfer", arguments: TransferArguments(Payload.URL, url: url));
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
          return RemoteLobbyFullView(info: controller.remote.value);
        } else {
          return LocalLobbyView();
        }
      },
    );
  }
}

// ^ Fullscreen Remote View ^ //
class RemoteLobbyFullView extends HookWidget {
  RemoteLobbyFullView({Key key, @required this.info}) : super(key: key);
  final RemoteInfo info;

  @override
  Widget build(BuildContext context) {
    final remoteStream = LobbyService.useRemoteLobby(info);
    return SonrScaffold(
        appBar: DesignAppBar(
          action: PlainButton(icon: SonrIcon.leave, onPressed: () => Get.find<TransferController>().stopRemote()),
          leading: PlainButton(icon: SonrIcon.close, onPressed: () => Get.offNamed("/home")),
          title: _buildTitleWidget(),
        ),
        body: ListView.builder(
            itemCount: remoteStream != null ? remoteStream.data.length + 1 : 1,
            itemBuilder: (BuildContext context, int index) {
              return PeerListItem(
                remoteStream.data.atIndex(index),
                index,
                remote: info,
              );
            }));
  }

  // # Update Title Widget
  Widget _buildTitleWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      "Remote".h3,
      IconButton(
        icon: Icon(Icons.info_outline),
        onPressed: () {
          SonrSnack.remote(message: info.display, duration: 12000);
        },
      )
    ]);
  }
}

// ^ Local Lobby View ^ //
class LocalLobbyView extends GetView<TransferController> {
  const LocalLobbyView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => SonrScaffold(
          appBar: DesignAppBar(
            action: controller.currentPayload != Payload.CONTACT
                ? PlainButton(icon: SonrIcon.remote, onPressed: () async => controller.startRemote())
                : Container(),
            leading: PlainButton(icon: SonrIcon.close, onPressed: () => Get.offNamed("/home")),
            title: GestureDetector(child: controller.title.value.h3, onTap: () => Get.bottomSheet(LobbySheet())),
          ),
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
                Obx(() => _LocalLobbyStack()),

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
    data.peers.forEach((peer) {
      if (peer.platform == Platform.iOS || peer.platform == Platform.Android) {
        // Add to Stack Items
        children.add(PeerBubble(peer));
      }
    });

    // Update View
    setState(() {
      lobbySize = data.peers.length;
      stackChildren = children;
    });
  }
}
