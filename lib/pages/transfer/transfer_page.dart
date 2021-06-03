import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonr_app/style/style.dart';
import 'local/devices_view.dart';
import 'local/local_view.dart';
import 'payload_sheet.dart';
import 'remote/remote_view.dart';
import 'transfer_controller.dart';

/// @ Transfer Screen Entry Point
class TransferScreen extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    Posthog().screen(screenName: "Transfer");

    // Build View
    return Obx(() => SonrScaffold(
          gradient: SonrGradients.PlumBath,
          appBar: DesignAppBar(
            centerTitle: true,
            leading: ActionButton(icon: SonrIcons.Close.gradient(value: SonrGradients.PhoenixStart), onPressed: () => controller.closeToHome()),
            action: _RemoteActionButton(),
            title: GestureDetector(
                onLongPress: () => UserService.openFeedback(context),
                child: controller.title.value.headThree(align: TextAlign.center, color: UserService.isDarkMode ? SonrColor.White : SonrColor.Black)),
          ),
          bottomSheet: PayloadSheetView(),
          body: SingleChildScrollView(
            child: controller.isRemoteActive.value
                ? RemoteView()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      LocalView(),
                      DevicesView(),
                    ],
                  ),
          ),
        ));
  }
}

/// @ Profile Action Button Widget
class _RemoteActionButton extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    return ActionButton(
        icon: SonrIcons.Compass.gradient(size: 28),
        onPressed: () {
          // Creates New Lobby
          if (!controller.isRemoteActive.value) {
            controller.createRemote();
          }
        });
  }
}
