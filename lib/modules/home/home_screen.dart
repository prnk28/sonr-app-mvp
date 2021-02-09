import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sonr_app/modules/home/share_button.dart';
import 'package:sonr_app/service/device_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'home_controller.dart';
import 'package:flutter/material.dart';
import 'transfer_item.dart';

class HomeScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    // Check for Initial Media after connected
    Get.find<DeviceService>().checkInitialShare();

    return SonrScaffold.appBarLeadingAction(
        title: "Home",
        leading: SonrButton.circleIcon(
          SonrIcon.profile,
          () => Get.offNamed("/profile"),
        ),
        action: SonrButton.circleIcon(
          SonrIcon.search,
          () => print("Search"),
        ),
        floatingActionButton: ShareButton(),
        body: GestureDetector(onTap: () => controller.toggleShareExpand(options: ToggleForced(false)), child: _HomeView()));
  }
}

// ** Home Screen Content ** //
class _HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
        onTap: () => controller.toggleShareExpand,
        child: Container(
          padding: EdgeInsets.only(top: 10),
          margin: EdgeInsets.only(left: 30, right: 30),
          child: Obx(() => NeumorphicToggle(
                selectedIndex: controller.toggleIndex.value,
                onChanged: (val) => controller.toggleIndex(val),
                thumb: Center(child: Obx(() => controller.getToggleCategory())),
                children: [
                  ToggleElement(),
                  ToggleElement(),
                  ToggleElement(),
                  ToggleElement(),
                ],
              )),
        ),
      ),
      Obx(() => GestureDetector(
            onTap: () => controller.toggleShareExpand(options: ToggleForced(false)),
            child: Container(
              padding: EdgeInsets.only(top: 15),
              margin: EdgeInsets.all(10),
              height: 500, // card height
              child: PageView.builder(
                  itemCount: controller.allCards.length,
                  controller: controller.pageController,
                  onPageChanged: (int index) => controller.pageIndex(index),
                  itemBuilder: (_, idx) {
                    return SonrCard.fromItem(controller.allCards[idx], idx);
                  }),
            ),
          ))
    ]);
  }
}

// ** Expanded Hero Home Screen Item ** //
class ExpandedView extends StatelessWidget {
  final TransferCard card;

  const ExpandedView({Key key, @required this.card}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: Get.back,
      child: SizedBox(
        width: Get.width,
        child: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Hero(
            tag: card.id,
            child: Material(
              color: Colors.transparent,
              child: PhotoView(
                imageProvider: MemoryImage(card.metadata.thumbnail),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
