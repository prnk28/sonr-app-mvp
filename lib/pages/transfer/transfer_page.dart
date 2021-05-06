import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonr_app/data/data.dart';

import 'package:sonr_app/style/style.dart';
import 'payload_view.dart';
import 'transfer_controller.dart';
import 'package:sonr_app/modules/peer/card_view.dart';

// ^ Transfer Screen Entry with Arguments ^ //
class Transfer {
  static void transferWithContact() {
    Get.offNamed("/transfer", arguments: TransferArguments(Payload.CONTACT, contact: UserService.contact.value));
  }

  static void transferWithFile(SonrFile file) {
    Get.offNamed("/transfer", arguments: TransferArguments(file.payload, file: file));
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
          gradient: SonrGradients.PlumBath,
          appBar: DesignAppBar(
            centerTitle: true,
            leading: PlainIconButton(icon: SonrIcons.Close.black, onPressed: () => Get.offNamed("/home")),
            subtitle: Container(child: controller.title.value.headFive(color: SonrColor.Black, weight: FontWeight.w400, align: TextAlign.start)),
            title: "Sharing ${controller.sonrFile.value!.payload.toString().capitalizeFirst}".h3,
          ),
          bottomSheet: PayloadSheetView(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // @ Lobby View
              Obx(() {
                // Carousel View
                if (controller.isNotEmpty.value) {
                  return Container(
                    height: 260,
                    child: CustomScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      controller: controller.scrollController,
                      slivers: LobbyService.local.value!.map((i) => Builder(builder: (context) => SliverToBoxAdapter(child: PeerCard(i)))).toList(),
                    ),
                  );
                }

                // Default Empty View
                else {
                  return Center(
                    child: Container(
                      padding: EdgeInsets.all(54),
                      height: 500,
                      child: SonrAssetIllustration.NoPeers.widget,
                    ),
                  );
                }
              }),
            ],
          ),
        ));
  }
}
