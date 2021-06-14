import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonr_app/style.dart';
// ignore: unused_import
import 'local/devices_view.dart';
import 'local/local_view.dart';
import 'payload/payload_sheet.dart';
import 'transfer_controller.dart';

/// @ Transfer Screen Entry Point
class TransferScreen extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    // Build View
    return SonrScaffold(
      gradient: SonrGradients.PlumBath,
      appBar: DetailAppBar(
        onPressed: () => controller.closeToHome(),
        title: "Transfer",
        isClose: true,
      ),
      bottomSheet: PayloadSheetView(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            LocalView(),
            //DevicesView(),
          ],
        ),
      ),
    );
  }
}
