import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/data/model/model_file.dart';
import 'package:sonr_app/theme/theme.dart';
import 'transfer_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sonr_app/modules/lobby/lobby.dart';
import 'package:sonr_app/modules/peer/card_view.dart';
import 'package:sonr_app/pages/transfer/transfer_controller.dart';
import 'payload_view.dart';

// ^ Transfer Screen Entry with Arguments ^ //
class Transfer {
  static void transferWithContact() {
    Get.offNamed("/transfer", arguments: TransferArguments(Payload.CONTACT, contact: UserService.contact.value));
  }

  static void transferWithFile(FileItem fileItem) {
    Get.offNamed("/transfer", arguments: TransferArguments(fileItem.payload, metadata: fileItem.metadata, item: fileItem));
  }

  static void transferWithUrl(String url) {
    Get.offNamed("/transfer", arguments: TransferArguments(Payload.URL, url: url));
  }
}

// ^ Transfer Screen Entry Point ^ //
class TransferScreen extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    // Set Payload from Args
    controller.setPayload(Get.arguments);

    // Build View
    return Obx(() => SonrScaffold(
          gradientName: FlutterGradientNames.plumBath,
          appBar: DesignAppBar(
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
      if (controller.isNotEmpty.value) {
        return CarouselSlider(
          carouselController: controller.carouselController,
          options: K_CAROUSEL_OPTS,
          items: LobbyService.local.value.peers.map((i) => Builder(builder: (context) => PeerCard(i))).toList(),
        );
      }

      // Default Empty View
      else {
        return Container(
          padding: EdgeInsets.all(24),
          height: 260,
          child: SonrAssetIllustration.NoPeers.widget,
        );
      }
    });
  }
}
