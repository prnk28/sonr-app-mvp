import 'package:sonr_app/modules/peer/card_view.dart';
import 'package:sonr_app/modules/peer/item_view.dart';
import 'package:sonr_app/style.dart';
import 'package:sonr_app/style/buttons/arrow.dart';
import '../transfer_controller.dart';

class LocalView extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Label
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            "Local".section(align: TextAlign.start, color: SonrTheme.itemColor),
            ArrowButton(
              key: controller.localArrowButtonKey,
              onPressed: () => controller.onLocalArrowPressed(),
              title: 'CARDS',
            )
          ]),
        ),
        Padding(padding: EdgeInsets.only(top: 4)),

        // Scroll View
        Obx(() => _buildView(LocalService.status.value)),
      ],
    );
  }

  Widget _buildView(LocalStatus status) {
    if (status.isEmpty) {
      return _LocalEmptyView();
    } else if (status.isFew) {
      return _LocalFewView();
    } else {
      return _LocalManyView();
    }
  }
}

/// @ LobbyEmptyView: When Lobby is Empty
class _LocalEmptyView extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: [
          Padding(padding: EdgeInsets.only(top: 24)),
          Image.asset(
            'assets/illustrations/EmptyLobby.png',
            height: Height.ratio(0.35),
            fit: BoxFit.fitHeight,
          ),
          Padding(padding: EdgeInsets.only(top: 8)),
          "Nobody Here..".subheading(color: Get.theme.hintColor, fontSize: 20)
        ].column(),
        padding: DeviceService.isDesktop ? EdgeInsets.all(64) : EdgeInsets.zero,
      ),
    );
  }
}

/// @ _LocalFewView:  When Lobby is <= 5 Peers
class _LocalFewView extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    return
        // Scroll View
        Obx(() => Container(
              width: Get.width,
              height: 400,
              child: CustomScrollView(
                scrollDirection: Axis.horizontal,
                controller: controller.scrollController,
                anchor: 0.225,
                slivers: LocalService.lobby.value
                    .mapAll((i) => Builder(builder: (context) {
                          return SliverToBoxAdapter(key: ValueKey(i.id.peer), child: PeerCard(i));
                        }))
                    .toList(),
              ),
            ));
  }
}

/// @ _LocalManyView:  When Lobby is > 5 Peers
class _LocalManyView extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    return
        // Scroll View
        Obx(() => Container(
              width: Get.width,
              height: 400,
              child: ListView.builder(itemBuilder: (context, index) {
                return PeerListItem(index: index, peer: LocalService.lobby.value.peerAtIndex(index));
              }),
            ));
  }
}
