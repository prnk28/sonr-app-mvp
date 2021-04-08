import 'package:sonr_app/modules/common/peer/item_view.dart';
import 'package:sonr_app/modules/remote/remote_controller.dart';
import 'package:sonr_app/pages/transfer/transfer_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import 'title_widget.dart';
import 'package:sonr_app/data/data.dart';

// ^ Card Aspect Ratio Remote View ^ //
class RemoteLobbyCardView extends GetView<RemoteController> {
  RemoteLobbyCardView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          SonrText.header("${controller.currentRemote.value.display}"),
          Expanded(
              child: ListView.builder(
            itemCount: controller.currentLobby.value != null ? controller.currentLobby.value.length + 1 : 1,
            itemBuilder: (BuildContext context, int index) {
              // Build List Item
              return PeerListItem(
                controller.currentLobby.value.atIndex(index - 1),
                index - 1,
                remote: controller.currentRemote.value,
              );
            },
          )),
          Padding(padding: EdgeInsets.all(8)),
        ]));
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
        leading: ShapeButton.circle(icon: SonrIcon.close, onPressed: () => Get.offNamed("/home/transfer"), shape: NeumorphicShape.flat),
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
