import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonr_app/style.dart';
// ignore: unused_import
import 'local/devices_view.dart';
import 'local/local_view.dart';
import 'payload/payload_sheet.dart';
import 'remote/remote_view.dart';
import 'transfer_controller.dart';

/// @ Transfer Screen Entry Point
class TransferScreen extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    // Build View
    return Obx(() => SonrScaffold(
          gradient: SonrGradients.PlumBath,
          appBar: DetailAppBar(
            onPressed: () => controller.closeToHome(),
            // action: _RemoteActionButton(),
            title: "Transfer",
            isClose: true,
          ),
          bottomSheet: PayloadSheetView(),
          body: SingleChildScrollView(
            child: controller.isRemoteActive.value
                ? RemoteView()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      LocalView(),
                      //DevicesView(),
                    ],
                  ),
          ),
        ));
  }
}

/// @ Profile Action Button Widget
// ignore: unused_element
class _RemoteActionButton extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    return ActionButton(
        iconData: SonrIcons.Compass,
        onPressed: () {
          // Creates New Lobby
          if (!controller.isRemoteActive.value) {
            controller.createRemote();
          }
        });
  }
}
