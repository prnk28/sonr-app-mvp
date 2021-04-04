import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonr_app/data/model/model_lobby.dart';
import 'package:sonr_app/modules/transfer/peer_widget.dart';
import 'package:sonr_app/theme/theme.dart';
import 'compass_view.dart';
import 'lobby_view.dart';
import 'transfer_controller.dart';

// ^ Transfer Screen Entry Point ^ //
class TransferScreen extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isRemoteActive.value) {
        return RemoteLobbyView(info: controller.remote.value);
      } else {
        return LocalLobbyView();
      }
    });
  }
}

// ^ Local Lobby View ^ //
class LocalLobbyView extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    return SonrScaffold.appBarLeadingAction(
      disableDynamicLobbyTitle: true,
      titleWidget: GestureDetector(child: SonrText.appBar(controller.title.value), onTap: () => Get.bottomSheet(LobbySheet())),
      leading: ShapeButton.circle(icon: SonrIcon.close, onPressed: () => Get.offNamed("/home/transfer"), shape: NeumorphicShape.flat),
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
            LobbyService.localSize.value > 0 ? LocalLobbyStack() : Container(),

            // @ Compass View
            Padding(
              padding: EdgeInsetsX.bottom(64.0),
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
    );
  }
}

// ^ Remote Lobby View ^ //
class RemoteLobbyView extends StatefulWidget {
  final RemoteInfo info;

  const RemoteLobbyView({Key key, @required this.info}) : super(key: key);
  @override
  _RemoteLobbyViewState createState() => _RemoteLobbyViewState();
}

class _RemoteLobbyViewState extends State<RemoteLobbyView> {
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
        titleWidget: SonrText.appBar("Remote"),
        leading: ShapeButton.circle(icon: SonrIcon.close, onPressed: () => Get.offNamed("/home/transfer"), shape: NeumorphicShape.flat),
        action: Container(),
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
                title: '',
              );
            } else {
              // Build List Item
              return PeerListItem(lobbyModel.atIndex(index - 1), index - 1);
            }
          },
        ));
  }

  // ^ Updates Stack Children ^ //
  _handlePeerUpdate(LobbyModel lobby) {
    // Update View
    setState(() {
      lobbyModel = lobby;
    });
  }
}
