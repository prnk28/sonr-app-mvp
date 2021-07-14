// Exports
export 'views/flat_view.dart';
export 'controllers/transfer_controller.dart';
export 'controllers/position_controller.dart';
export 'data/animation.dart';
export 'data/types.dart';

// Imports
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonr_app/modules/share/share.dart';
import 'package:sonr_app/pages/transfer/views/composer_view.dart';
import 'package:sonr_app/style/style.dart';
import 'controllers/transfer_controller.dart';
import 'views/local_view.dart';

/// #### Transfer Screen Entry Point
class TransferPage extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    controller.initialize();
    // Build View
    return SonrScaffold(
        appBar: DetailAppBar(
          action: DeviceService.isIOS
              ? ActionButton(
                  iconData: SimpleIcons.Compass,
                  onPressed: () {
                    AppRoute.popup(InviteComposer());
                  },
                )
              : null,
          onPressed: () => Get.back(closeOverlays: true),
          title: "Transfer",
          isClose: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  LocalView(),
                  //DevicesView(),
                ],
              ),
            ),
            Align(alignment: Alignment.bottomCenter, child: PayloadSheetView()),
          ],
        ));
  }
}

class PayloadSheetView extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (AppRoute.isPopupOpen) {
        return Container();
      } else {
        if (controller.hasInvite.value) {
          return controller.invite.value.payload.isMultipleFiles
              // Build List View
              ? DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.20,
                  maxChildSize: 0.5,
                  minChildSize: 0.2,
                  builder: (BuildContext context, ScrollController scrollController) {
                    final file = controller.invite.value.file;
                    return Container(
                      padding: EdgeInsets.only(top: 24),
                      decoration: BoxDecoration(color: AppTheme.ForegroundColor, borderRadius: BorderRadius.circular(37)),
                      child: CustomScrollView(
                        controller: scrollController,
                        slivers: [
                          SliverAppBar(
                            title: PayloadListItemHeader(),
                            pinned: true,
                            floating: false,
                            automaticallyImplyLeading: false,
                            backgroundColor: AppTheme.ForegroundColor,
                            toolbarHeight: 80,
                            forceElevated: false,
                            shadowColor: AppTheme.ShadowColor,
                          ),
                          SliverList(
                              delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return PayloadListItem.multi(
                                item: file.items[index],
                                index: index,
                                key: GlobalKey(debugLabel: "InfoButton-$index"),
                              );
                            },
                            childCount: file.items.length,
                          ))
                        ],
                      ),
                    );
                  })
              :
              // Build Single Item
              BoxContainer(
                  padding: EdgeInsets.all(8),
                  child: Container(
                      height: Height.ratio(0.15),
                      child: PayloadListItem.single(
                        key: GlobalKey(
                          debugLabel: "InfoButton-SingleItem",
                        ),
                      )));
        } else {
          return Container(
            alignment: Alignment.center,
            height: Height.ratio(0.15),
            margin: EdgeInsets.all(24),
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 42, vertical: 24),
                child: ColorButton.primary(
                  icon: SimpleIcons.Add,
                  text: "Add File",
                  onPressed: () => AppPage.Share.to(init: ShareController.initAlert),
                )),
          );
        }
      }
    });
  }
}
