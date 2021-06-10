import 'package:flutter/material.dart';
import 'package:sonr_app/modules/peer/item_view.dart';
import 'package:sonr_app/style.dart';
import '../explorer_controller.dart';

class NearbyListView extends GetView<ExplorerController> {
  NearbyListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: SonrTheme.cardDecoration,
      width: 400,
      height: 700,
      child: Column(
        children: [
          // Label
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: "Nearby Devices".section(align: TextAlign.start, color: SonrTheme.textColor),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 4)),

          // Scroll View
          Obx(
            () => LobbyService.local.value.isEmpty ? _LocalEmptyView() : _LocalLobbyView(),
          ),
        ],
      ),
    );
  }
}

/// @ LocalLobbyView:  When Lobby is NOT Empty
class _LocalLobbyView extends GetView<ExplorerController> {
  @override
  Widget build(BuildContext context) {
    return
        // Scroll View
        Obx(() => Container(
            width: Get.width,
            height: 400,
            child: ListView.builder(
                itemCount: LobbyService.local.value.peers.length,
                itemBuilder: (context, index) {
                  return PeerListItem(LobbyService.local.value.peerAtIndex(index), index);
                })));
  }
}

/// @ LobbyEmptyView: When Lobby is Empty
class _LocalEmptyView extends GetView<ExplorerController> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: [
          Image.asset(
            'assets/illustrations/EmptyLobby.png',
            height: Height.ratio(0.45),
            fit: BoxFit.fitWidth,
          ),
          Padding(padding: EdgeInsets.only(top: 8)),
          "Nobody Here..".subheading(color: Get.theme.hintColor, fontSize: 20)
        ].column(),
        padding: EdgeInsets.all(64),
      ),
    );
  }
}
