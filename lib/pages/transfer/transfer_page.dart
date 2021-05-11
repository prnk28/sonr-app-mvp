import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonr_app/style/style.dart';
import 'lobby_view.dart';
import 'payload_view.dart';
import 'transfer_controller.dart';

/// @ Transfer Screen Entry Point
class TransferScreen extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    // Build View
    return Obx(() => SonrScaffold(
          gradient: SonrGradients.PlumBath,
          appBar: DesignAppBar(
            centerTitle: true,
            leading: ActionButton(icon: SonrIcons.Close.gradient(value: SonrGradients.PhoenixStart), onPressed: () => Get.offNamed("/home")),
            subtitle: Container(child: controller.subtitle.value.headFive(color: SonrColor.Black, weight: FontWeight.w400, align: TextAlign.start)),
            title: TransferService.shareTitle.value.h3,
          ),
          bottomSheet: PayloadSheetView(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // @ Lobby View
              Obx(() {
                // Carousel View
                if (controller.isNotEmpty.value) {
                  return LobbyView();
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
