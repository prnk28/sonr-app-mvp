import 'package:sonr_app/pages/transfer/transfer.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_app/modules/peer/peer.dart';

class LocalView extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Label
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            "Around Me".section(align: TextAlign.start, color: AppTheme.ItemColor),
            Obx(() => ArrowButton.checkList(
                  title: _buildArrowTitle(controller.phonesEnabled.value, controller.desktopsEnabled.value),
                  onSelectedOption: (index) {
                    print(index);
                  },
                  options: [
                    ChecklistOption("Phones", controller.phonesEnabled),
                    ChecklistOption("Desktops", controller.desktopsEnabled),
                  ],
                  offset: Offset(-80, -10),
                ))
          ]),
        ),
        Padding(padding: EdgeInsets.only(top: 4)),

        // Scroll View
        Obx(() => _buildView(LobbyService.status.value, controller.phonesEnabled.value, controller.desktopsEnabled.value)),
      ],
    );
  }

  Widget _buildView(Lobby_Status status, bool phones, bool desktops) {
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

/// ### LobbyEmptyView: When Lobby is Empty
class _LocalEmptyView extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: [
          Padding(padding: EdgeInsets.only(top: 24)),
          Image.asset(
            'assets/images/illustrations/EmptyLobby.png',
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

/// ### _LocalFewView:  When Lobby is <= 5 Peers
class _LocalFewView extends GetView<TransferController> {
  final LobbyFilter filter;

  _LocalFewView(this.filter);
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          width: Get.width,
          height: Height.ratio(0.35),
          child: ListView(
            scrollDirection: Axis.horizontal,
            controller: controller.scrollController,
            children: _buildSlivers(LobbyService.lobby.value),
          ),
        ));
  }

  /// Build Slivers by Filter Type
  List<Widget> _buildSlivers(Lobby lobby) {
    switch (filter) {
      case LobbyFilter.All:
        return lobby
            .mapAll((i) => Builder(builder: (context) {
                  return PeerItem.card(i);
                }))
            .toList();
      case LobbyFilter.Phones:
        return lobby
            .mapMobile((i) => Builder(builder: (context) {
                  return PeerItem.card(i);
                }))
            .toList();
      case LobbyFilter.Desktops:
        return lobby
            .mapDesktop((i) => Builder(builder: (context) {
                  return PeerItem.card(i);
                }))
            .toList();
    }
  }
}

/// ### _LocalManyView:  When Lobby is > 5 Peers
class _LocalManyView extends GetView<TransferController> {
  final LobbyFilter filter;

  _LocalManyView(this.filter);
  @override
  Widget build(BuildContext context) {
    return
        // Scroll View
        Obx(() => Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              width: Get.width,
              height: Height.ratio(0.7),
              decoration: BoxDecoration(
                color: Color(0xffF8F8F9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  switch (filter) {
                    case LobbyFilter.All:
                      return PeerItem.list(index: index, member: LobbyService.lobby.value.peerAtIndex(index));
                    case LobbyFilter.Phones:
                      return PeerItem.list(index: index, member: LobbyService.lobby.value.peerAtIndex(index));
                    case LobbyFilter.Desktops:
                      return PeerItem.list(index: index, member: LobbyService.lobby.value.peerAtIndex(index));
                  }
                },
                itemCount: LobbyService.lobby.value.count,
              ),
            ));
  }
}
