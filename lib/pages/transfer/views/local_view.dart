import 'package:sonr_app/pages/transfer/models/filter.dart';
import 'package:sonr_app/pages/transfer/widgets/peer/peer.dart';
import 'package:sonr_app/pages/transfer/models/status.dart';
import 'package:sonr_app/style.dart';
import 'package:sonr_app/style/buttons/arrow.dart';
import '../transfer.dart';

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
            Obx(() => ArrowButton(
                  key: controller.localArrowButtonKey,
                  onPressed: () => controller.onLocalArrowPressed(),
                  title: _buildArrowTitle(controller.phonesEnabled.value, controller.desktopsEnabled.value),
                ))
          ]),
        ),
        Padding(padding: EdgeInsets.only(top: 4)),

        // Scroll View
        Obx(() => _buildView(LocalService.status.value, controller.phonesEnabled.value, controller.desktopsEnabled.value)),
      ],
    );
  }

  Widget _buildView(LocalStatus status, bool phones, bool desktops) {
    if (status.isEmpty || !phones && !desktops) {
      return _LocalEmptyView();
    } else if (status.isFew) {
      return _LocalFewView(LobbyFilterUtils.fromEnabled(phones, desktops));
    } else {
      return _LocalManyView(LobbyFilterUtils.fromEnabled(phones, desktops));
    }
  }

  String _buildArrowTitle(bool phones, bool desktops) {
    if (phones && desktops) {
      return "All";
    } else if (phones && !desktops) {
      return "Phones";
    } else if (desktops && !phones) {
      return "Desktops";
    } else {
      return "None";
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
  final LobbyFilter filter;

  _LocalFewView(this.filter);
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
                slivers: _buildSlivers(LocalService.lobby.value),
              ),
            ));
  }

  /// Build Slivers by Filter Type
  List<Widget> _buildSlivers(Lobby lobby) {
    switch (filter) {
      case LobbyFilter.All:
        return lobby
            .mapAll((i) => Builder(builder: (context) {
                  return SliverToBoxAdapter(key: ValueKey(i.id.peer), child: PeerCard(i));
                }))
            .toList();
      case LobbyFilter.Phones:
        return lobby
            .mapMobile((i) => Builder(builder: (context) {
                  return SliverToBoxAdapter(key: ValueKey(i.id.peer), child: PeerCard(i));
                }))
            .toList();
      case LobbyFilter.Desktops:
        return lobby
            .mapDesktop((i) => Builder(builder: (context) {
                  return SliverToBoxAdapter(key: ValueKey(i.id.peer), child: PeerCard(i));
                }))
            .toList();
    }
  }
}

/// @ _LocalManyView:  When Lobby is > 5 Peers
class _LocalManyView extends GetView<TransferController> {
  final LobbyFilter filter;

  _LocalManyView(this.filter);
  @override
  Widget build(BuildContext context) {
    return
        // Scroll View
        Obx(() => Container(
              width: Get.width,
              height: 400,
              child: ListView.builder(itemBuilder: (context, index) {
                switch (filter) {
                  case LobbyFilter.All:
                    return PeerListItem(index: index, peer: LocalService.lobby.value.peerAtIndex(index));
                  case LobbyFilter.Phones:
                    return PeerListItem(index: index, peer: LocalService.lobby.value.peerAtIndex(index));
                  case LobbyFilter.Desktops:
                    return PeerListItem(index: index, peer: LocalService.lobby.value.peerAtIndex(index));
                }
              }),
            ));
  }
}
