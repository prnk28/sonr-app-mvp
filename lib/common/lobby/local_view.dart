import 'package:sonr_app/pages/transfer/compass_view.dart';
import 'package:sonr_app/pages/transfer/transfer_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import 'sheet_view.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonr_app/data/model/model_lobby.dart';
import '../../common/peer/bubble_view.dart';

// ^ Local Lobby View ^ //
class LocalLobbyView extends StatelessWidget {
  final TransferController controller;

  const LocalLobbyView(this.controller, {Key key}) : super(key: key);
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
            LobbyService.localSize.value > 0 ? _LocalLobbyStack(controller) : Container(),

            // @ Compass View
            Padding(
              padding: EdgeInsetsX.bottom(32.0),
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

// ^ Local Lobby Stack View ^ //
class _LocalLobbyStack extends StatefulWidget {
  final TransferController transfer;

  const _LocalLobbyStack(this.transfer, {Key key}) : super(key: key);
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
      children.add(PeerBubble(peer, widget.transfer));
    });

    // Update View
    setState(() {
      lobbySize = data.mobilePeers.length;
      stackChildren = children;
    });
  }
}
