import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sonr_app/modules/card/grid_item.dart';
import 'package:sonr_app/service/device_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'home_controller.dart';
import 'search_dialog.dart';
import 'share_button.dart';

class HomeScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    // Check for Initial Media after connected
    Get.find<DeviceService>().checkInitialShare();

    return SonrScaffold.appBarLeadingAction(
        resizeToAvoidBottomPadding: false,
        title: "Home",
        leading: SonrButton.circle(
          icon: SonrIcon.profile,
          onPressed: () => Get.offNamed("/profile"),
        ),
        action: SonrButton.circle(
            icon: SonrIcon.search,
            onPressed: () {
              if (controller.allCards.length > 0) {
                Get.dialog(
                  SearchDialog(),
                  barrierDismissible: true,
                  useRootNavigator: false,
                  useSafeArea: true,
                  barrierColor: K_DIALOG_COLOR,
                  transitionCurve: Curves.bounceInOut,
                );
              } else {
                SonrSnack.error("No Cards Found");
              }
            }),
        floatingActionButton: ShareButton(),
        body: Container(
          width: Get.width,
          height: Get.height,
          child: Column(children: [
            GestureDetector(
              onTap: () => controller.toggleShareExpand(options: ToggleForced(false)),
              child: Container(
                padding: EdgeInsets.only(top: 10),
                margin: EdgeInsets.only(left: 30, right: 30),
                child: Obx(() => NeumorphicToggle(
                      selectedIndex: controller.toggleIndex.value,
                      onChanged: (val) => controller.setToggleCategory(val),
                      thumb: Center(child: Obx(() => controller.getToggleCategory())),
                      children: [
                        ToggleElement(),
                        ToggleElement(),
                        ToggleElement(),
                        //ToggleElement(),
                      ],
                    )),
              ),
            ),
            TransferCardGrid()
          ]),
        ));
  }
}

class TransferCardGrid extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Initialize
      return Container(
        padding: EdgeInsets.only(top: 15),
        margin: EdgeInsets.all(10),
        height: 500, // card height
        child: PageView.builder(
            itemCount: getCardList(controller).length,
            controller: controller.pageController,
            onPageChanged: (int index) => controller.pageIndex(index),
            itemBuilder: (_, idx) {
              return Obx(() {
                if (idx == controller.pageIndex.value) {
                  return PlayAnimation<double>(
                    tween: (0.85).tweenTo(0.95),
                    duration: 200.milliseconds,
                    builder: (context, child, value) {
                      return Transform.scale(
                        scale: value,
                        child: GridItemCardView.fromItem(getCardList(controller)[idx], idx),
                      );
                    },
                  );
                } else if (idx == controller.pageIndex.value) {
                  return PlayAnimation<double>(
                    tween: (0.95).tweenTo(0.85),
                    duration: 200.milliseconds,
                    builder: (context, child, value) {
                      return Transform.scale(
                        scale: value,
                        child: GridItemCardView.fromItem(getCardList(controller)[idx], idx),
                      );
                    },
                  );
                } else {
                  return Transform.scale(
                    scale: 0.85,
                    child: GridItemCardView.fromItem(getCardList(controller)[idx], idx),
                  );
                }
              });
            }),
      );
    });
  }

  List<TransferCard> getCardList(HomeController controller) {
    if (controller.toggleIndex.value == 1) {
      return controller.mediaCards();
    } else if (controller.toggleIndex.value == 2) {
      return controller.contactCards;
    } else {
      return controller.allCards;
    }
  }
}
