import 'package:get/get.dart';
import 'package:sonr_app/modules/card/card_controller.dart';
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
            itemCount: controller.getCardList().length,
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
                        child: buildCard(controller, idx),
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
                        child: buildCard(controller, idx),
                      );
                    },
                  );
                } else {
                  return Transform.scale(
                    scale: 0.85,
                    child: buildCard(controller, idx),
                  );
                }
              });
            }),
      );
    });
  }

  Widget buildCard(HomeController controller, int index) {
    // Get Card List
    List<TransferCard> list;
    if (controller.toggleIndex.value == 1) {
      list = controller.mediaCards();
    } else if (controller.toggleIndex.value == 2) {
      list = controller.contactCards;
    } else {
      list = controller.allCards;
    }

    // Determin CardView
    if (list[index].payload == Payload.MEDIA) {
      return MediaCard.item(card: list[index]);
    } else if (list[index].payload == Payload.CONTACT) {
      return ContactCard.item(card: list[index]);
    } else if (list[index].payload == Payload.URL) {
      return URLCard.item(card: list[index]);
    } else {
      return FileCard.item(card: list[index]);
    }
  }
}
