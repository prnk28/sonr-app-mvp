import 'package:flutter/material.dart';
import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/pages/transfer/widgets/peer/peer.dart';
import 'package:sonr_app/style.dart';

class NearbyListView extends GetView<HomeController> {
  NearbyListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BoxContainer(
      width: 400,
      height: 700,
      child: Column(
        children: [
          // Label
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 8),
              child: "Nearby Devices".subheading(align: TextAlign.start, color: SonrTheme.itemColor),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Obx(
              () => LocalService.lobby.value.isEmpty ? _LocalEmptyView() : _LocalLobbyView(),
            ),
          ),
        ],
      ),
    );
  }
}

/// @ LocalLobbyView:  When Lobby is NOT Empty
class _LocalLobbyView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return
        // Scroll View
        Obx(() => Container(
            width: Get.width,
            height: 400,
            child: ListView.builder(
                itemCount: LocalService.lobby.value.peers.length,
                itemBuilder: (context, index) {
                  return PeerListItem(peer: LocalService.lobby.value.peerAtIndex(index), index: index);
                })));
  }
}

/// @ LobbyEmptyView: When Lobby is Empty
class _LocalEmptyView extends GetView<HomeController> {
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
