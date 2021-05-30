import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonr_app/pages/transfer/remote/remote_controller.dart';
import 'package:sonr_app/style/style.dart';
import 'linked/devices_view.dart';
import 'local/local_view.dart';
import 'payload_sheet.dart';
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
            leading: ActionButton(icon: SonrIcons.Close.gradient(value: SonrGradients.PhoenixStart), onPressed: () => Get.offNamed("/home")),
            action: _RemoteActionButton(),
            title: controller.title.value.headThree(align: TextAlign.center, color: UserService.isDarkMode ? SonrColor.White : SonrColor.Black),
          ),
          bottomSheet: PayloadSheetView(),
          body: SingleChildScrollView(
            child: Column(
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
class _RemoteActionButton extends GetView<RemoteController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => ActionButton(
          icon: _buildIcon(controller.status.value),
          onPressed: () {
            // Creates New Lobby
            if (controller.status.value.isDefault) {
              controller.create();
            }
          },
        ));
  }

  // @ Builds Icon by Status
  Widget _buildIcon(RemoteViewStatus status) {
    switch (status) {
      case RemoteViewStatus.Created:
        return SonrIcons.Logout.gradient(value: SonrGradient.Critical, size: 28);

      case RemoteViewStatus.Joined:
        return SonrIcons.Logout.gradient(value: SonrGradient.Critical, size: 28);

      default:
        return SonrIcons.Compass.gradient(size: 28);
    }
  }
}
