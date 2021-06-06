import 'package:sonr_app/modules/peer/card_view.dart';
import 'package:sonr_app/style/style.dart';
import '../transfer_controller.dart';

class LocalView extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Label
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: "Local".subheading(align: TextAlign.start, color: SonrTheme.textColor),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 4)),

        // Scroll View
        Obx(
          () => LobbyService.local.value.isEmpty ? _LocalEmptyView() : _LocalLobbyView(),
        ),
      ],
    );
  }
}

/// @ LocalLobbyView:  When Lobby is NOT Empty
class _LocalLobbyView extends GetView<TransferController> {
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
                slivers: LobbyService.local.value
                    .mapAll((i) => Builder(builder: (context) {
                          return SliverToBoxAdapter(key: ValueKey(i.id.peer), child: PeerCard(i));
                        }))
                    .toList(),
              ),
            ));
  }
}

/// @ LobbyEmptyView: When Lobby is Empty
class _LocalEmptyView extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(54),
        height: 260,
        child: SonrAssetIllustration.NoPeers.widget,
      ),
    );
  }
}
