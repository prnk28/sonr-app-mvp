import 'package:carousel_slider/carousel_slider.dart';
import 'package:sonr_app/modules/lobby/lobby.dart';
import 'package:sonr_app/modules/peer/card_view.dart';
import 'package:sonr_app/pages/transfer/transfer_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import 'payload_view.dart';

// ^ Local Lobby View ^ //
class LocalLobbyView extends GetView<TransferController> {
  const LocalLobbyView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => SonrScaffold(
          gradientName: FlutterGradientNames.plumBath,
          appBar: DesignAppBar(
            action: controller.currentPayload != Payload.CONTACT
                ? PlainButton(icon: SonrIcons.Remote, onPressed: () async => controller.startRemote())
                : Container(width: 56, height: 56),
            leading: PlainIconButton(icon: SonrIcons.Close.gradient(gradient: SonrGradient.Critical), onPressed: () => Get.offNamed("/home")),
            title: Container(child: GestureDetector(child: controller.title.value.h3, onTap: () => Get.bottomSheet(LobbySheet()))),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // @ Lobby View
              _LocalPeerCarousel(),

              // @ Compass View
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: GestureDetector(
                    onTap: () {
                      controller.toggleShifting();
                    },
                    child: PayloadView(),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

// ^ Local Carousel Peers View ^ //
class _LocalPeerCarousel extends GetView<TransferController> {
  // # Carousel Options
  final K_CAROUSEL_OPTS = CarouselOptions(
    height: 260.0,
    enableInfiniteScroll: false,
    enlargeCenterPage: true,
    scrollPhysics: NeverScrollableScrollPhysics(),
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Carousel View
      if (LobbyService.local.value.peers != null) {
        return CarouselSlider(
          carouselController: controller.carouselController,
          options: K_CAROUSEL_OPTS,
          items: LobbyService.local.value.peers.map((i) => Builder(builder: (context) => PeerCard(i))).toList(),
        );
      }

      // Default Empty View
      else {
        return Container(
          height: 260,
          child: SonrAssetIllustration.NoPeers.widget,
        );
      }
    });
  }
}
