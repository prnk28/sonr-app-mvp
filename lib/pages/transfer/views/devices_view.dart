import 'package:sonr_app/style/style.dart';
import '../transfer.dart';

class DevicesView extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Label
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: "My Devices".subheading(align: TextAlign.start, color: Get.theme.focusColor),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 4)),

        // Scroll View
        _DevicesEmptyView(),
      ],
    );
  }
}

/// @ LocalLobbyView:  When Lobby is NOT Empty
// ignore: unused_element
class _DevicesLobbyView extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    return
        // Scroll View
        Obx(() => Container(
              width: Get.width,
              height: 260,
              child: CustomScrollView(
                scrollDirection: Axis.horizontal,
                controller: controller.scrollController,
                anchor: 0.225,
                slivers: LobbyService.lobby.value
                    .mapAll((i) => Builder(builder: (context) {
                          return SliverToBoxAdapter(key: ValueKey(i.id.peer), child: PeerItem.card(i));
                        }))
                    .toList(),
              ),
            ));
  }
}

/// @ LobbyEmptyView: When Lobby is Empty
class _DevicesEmptyView extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 24),
      margin: EdgeInsets.symmetric(horizontal: 48),
      child: "Coming Soon!".paragraph(color: SonrColor.White),
    );
  }
}
