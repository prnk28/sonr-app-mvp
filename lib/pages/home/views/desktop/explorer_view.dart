import 'package:flutter/material.dart';
import 'package:sonr_app/modules/peer/card_view.dart';
import 'package:sonr_app/style/style.dart';
import 'desktop_controller.dart';

class ExplorerDesktopView extends GetView<DesktopController> {
  ExplorerDesktopView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Posthog().screen(screenName: "Explorer");
    return Center(
      child: Obx(() {
        // Carousel View
        if (controller.isNotEmpty.value) {
          return Container(
            height: 260,
            child: CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: controller.scrollController,
              slivers: LobbyService.local.value
                  .mapAll((i) => Builder(
                      builder: (context) => SliverToBoxAdapter(
                              child: GestureDetector(
                            onTap: () => controller.chooseFile(i),
                            child: PeerCard(i),
                          ))))
                  .toList(),
            ),
          );
        }

        // Default Empty View
        else {
          return Center(
            child: [
              Container(
                padding: EdgeInsets.all(54),
                width: 500,
                child: Image.asset('assets/illustrations/EmptyLobby.png'),
              ),
              "Nobody Around".h5_Grey
            ].column(mainAxisAlignment: MainAxisAlignment.center),
          );
        }
      }),
    );
  }
}