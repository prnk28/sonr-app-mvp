import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonr_app/modules/share/share_controller.dart';
import 'package:sonr_app/style.dart';
import 'transfer_controller.dart';
import 'views/local_view.dart';
import 'widgets/item/item.dart';

/// @ Transfer Screen Entry Point
class TransferPage extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    // Build View
    return SonrScaffold(
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

class PayloadSheetView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (TransferService.hasPayload.value) {
        return TransferService.payload.value.isMultipleFiles
            // Build List View
            ? DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.20,
                maxChildSize: 0.5,
                minChildSize: 0.2,
                builder: (BuildContext context, ScrollController scrollController) {
                  return Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    foregroundDecoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: ListView.builder(
                        controller: scrollController,
                        itemCount: TransferService.file.value.items.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          return index == 0
                              ? SonrFileListHeader()
                              : SonrFileListItem(
                                  item: TransferService.file.value.items[index - 1],
                                  index: index - 1,
                                );
                        }),
                  );
                })
            :
            // Build Single Item
            BoxContainer(padding: EdgeInsets.all(8), child: Container(height: Height.ratio(0.15), child: PayloadSingleItem()));
      } else {
        return Container(
          alignment: Alignment.center,
          height: Height.ratio(0.15),
          margin: EdgeInsets.all(24),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 42, vertical: 24),
              child: ColorButton.primary(
                icon: SonrIcons.Add,
                text: "Add File",
                onPressed: () => AppPage.Share.to(init: ShareController.initAlert),
              )),
        );
      }
    });
  }
}
