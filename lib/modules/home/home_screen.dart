import 'package:sonr_app/data/constants.dart';
import 'package:sonr_app/theme/theme.dart';
import 'home_controller.dart';
import 'search_view.dart';
import 'share_button.dart';

class HomeScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    // Check for Initial Media after connected
    MediaService.checkInitialShare();
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
              if (controller.status.value != HomeState.None) {
                SonrOverlay.show(
                  SearchView(),
                  barrierDismissible: true,
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
              onTap: () => controller.closeShare(),
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
    // Create Page Controller
    final pageController = PageController(viewportFraction: 0.8, keepPage: false);
    controller.pageController = pageController;

    // Build View
    return GestureDetector(
        onTap: () => controller.closeShare(),
        child: Container(
            padding: EdgeInsets.only(top: 15),
            margin: EdgeInsets.all(10),
            height: 500,
            child: Obx(() {
              // Loading Cards
              if (controller.status.value == HomeState.Loading) {
                return Center(child: CircularProgressIndicator());
              }

              // New User
              else if (controller.status.value == HomeState.First) {
                return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  SonrText.header("Welcome to Sonr", gradient: FlutterGradientNames.magicRay, size: 36),
                  SonrText.normal("Share to begin viewing your Cards!", color: Colors.black.withOpacity(0.7), size: 18)
                ]);
              }

              // Zero Cards
              else if (controller.status.value == HomeState.None) {
                return Center(child: SonrText.bold("No Cards Found!", color: Colors.grey[500]));
              }

              // Build Cards
              else {
                return PageView.builder(
                  itemCount: controller.getCardList().length,
                  controller: pageController,
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
                              child: buildCard(idx),
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
                              child: buildCard(idx),
                            );
                          },
                        );
                      } else {
                        return Transform.scale(
                          scale: 0.85,
                          child: buildCard(idx),
                        );
                      }
                    });
                  },
                );
              }
            })));
  }

  Widget buildCard(int index) {
    // Get Card List
    List<TransferCard> list = controller.getCardList();
    bool isNew = false;

    // Check if New Card
    if (controller.status.value == HomeState.New) {
      isNew = index == list.length - 1;
    }

    // Determin CardView
    if (list[index].payload == Payload.MEDIA) {
      return MediaCard.item(list[index], isNewItem: isNew);
    } else if (list[index].payload == Payload.CONTACT) {
      return ContactCard.item(list[index], isNewItem: isNew);
    } else if (list[index].payload == Payload.URL) {
      return URLCard.item(list[index], isNewItem: isNew);
    } else {
      return FileCard.item(list[index], isNewItem: isNew);
    }
  }
}
