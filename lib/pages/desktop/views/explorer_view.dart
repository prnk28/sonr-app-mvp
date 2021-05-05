import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sonr_app/modules/peer/card_view.dart';
import 'package:sonr_app/pages/desktop/controllers/explorer_controller.dart';
import 'package:sonr_app/theme/theme.dart';

class ExplorerDesktopView extends GetView<ExplorerController> {
  ExplorerDesktopView({Key key}) : super(key: key);

  final K_CAROUSEL_OPTS = CarouselOptions(
    height: 260.0,
    enableInfiniteScroll: false,
    enlargeCenterPage: true,
    scrollPhysics: NeverScrollableScrollPhysics(),
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() {
        // Carousel View
        if (controller.isNotEmpty.value) {
          return CarouselSlider(
            carouselController: controller.carouselController,
            options: K_CAROUSEL_OPTS,
            items: LobbyService.local.value.map((i) => Builder(builder: (context) => PeerCard(i))).toList(),
          );
        }

        // Default Empty View
        else {
          return Center(
            child: [Container(padding: EdgeInsets.all(54), width: 500, child: SonrAssetIllustration.NoPeers.widget), "Nobody Around".h5_Grey]
                .column(mainAxisAlignment: MainAxisAlignment.center),
          );
        }
      }),
    );
  }
}
