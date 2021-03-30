import 'package:sonr_app/theme/theme.dart';
import '../../main.dart';
import 'search_view.dart';
import 'home_controller.dart';
// import 'search_view.dart';
import 'share_button.dart';

class HomeScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    // Build Scaffold
    return SonrScaffold.appBarLeadingAction(
      resizeToAvoidBottomPadding: false,
      title: "Home",
      leading: _buildLeadingByMode(),
      action: SonrButton.circle(
          icon: SonrIcon.search,
          shape: NeumorphicShape.flat,
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
      body: NeumorphicBackground(
        backendColor: Colors.transparent,
        child: Container(
          width: Get.width,
          height: Get.height,
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              margin: EdgeInsets.only(left: 30, right: 30),
              child: Obx(() => NeumorphicToggle(
                    style: NeumorphicToggleStyle(depth: 20, backgroundColor: UserService.isDarkMode.value ? SonrColor.Dark : SonrColor.White),
                    selectedIndex: controller.toggleIndex.value,
                    onChanged: (val) => controller.setToggleCategory(val),
                    thumb: SonrAnimatedSwitcher.fade(
                      child: GestureDetector(
                          key: ValueKey<int>(controller.toggleIndex.value),
                          onDoubleTap: () => controller.jumpToStart(),
                          onLongPress: () => controller.jumpToEnd(),
                          child: Center(child: Obx(() => _buildToggleView()))),
                    ),
                    children: [
                      ToggleElement(background: Center(child: SonrText.medium("Media", color: SonrColor.Grey, size: 16))),
                      ToggleElement(background: Center(child: SonrText.medium("All", color: SonrColor.Grey, size: 16))),
                      ToggleElement(background: Center(child: SonrText.medium("Contacts", color: SonrColor.Grey, size: 16))),
                    ],
                  )),
            ),
            TransferCardGrid(),
            Spacer()
          ]),
        ),
      ),
    );
  }

// ^ Helper Method for Test Mode Leading Button ^ //
  Widget _buildLeadingByMode() {
    if (K_TESTER_MODE) {
      return SonrButton.circle(
        icon: SonrIcon.more,
        onPressed: () => Get.bottomSheet(_SettingsSheet(), backgroundColor: Colors.transparent),
        shape: NeumorphicShape.flat,
      );
    } else {
      return SonrButton.circle(
        icon: SonrIcon.profile,
        onPressed: () => Get.toNamed("/profile"),
        onLongPressed: () => UserService.toggleDarkMode(),
        shape: NeumorphicShape.flat,
      );
    }
  }

  // ^ Helper Method for Category Filter ^ //
  Widget _buildToggleView() {
    // Change Category
    if (controller.toggleIndex.value == 0) {
      return SonrIcon.neumorphicGradient(SonrIconData.media, FlutterGradientNames.newRetrowave, size: 24);
    } else if (controller.toggleIndex.value == 1) {
      return SonrIcon.neumorphicGradient(
          SonrIconData.all_categories, UserService.isDarkMode.value ? FlutterGradientNames.happyUnicorn : FlutterGradientNames.eternalConstance,
          size: 22.5);
    } else if (controller.toggleIndex.value == 2) {
      return SonrIcon.neumorphicGradient(SonrIconData.friends, FlutterGradientNames.orangeJuice, size: 24);
    } else {
      return SonrIcon.neumorphicGradient(SonrIconData.url, FlutterGradientNames.sugarLollipop, size: 24);
    }
  }
}

class TransferCardGrid extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    // Create Page Controller
    final pageController = PageController(viewportFraction: 0.8, keepPage: false);
    controller.pageController = pageController;

    // Build View
    return Container(
        padding: EdgeInsets.only(top: 15),
        height: 500,
        child: Obx(() {
          // Loading Cards
          if (controller.status.value == HomeState.Loading) {
            return Center(child: CircularProgressIndicator());
          }

          // New User
          else if (controller.status.value == HomeState.First) {
            return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
              SonrText.header("Welcome to Sonr"),
              SonrText.normal("Share to begin viewing your Cards!", color: SonrColor.black.withOpacity(0.7), size: 18)
            ]);
          }

          // Zero Cards
          else if (controller.status.value == HomeState.None) {
            return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
              SonrText.header(
                "No Cards Found!",
                size: 32,
              ),
              Padding(padding: EdgeInsets.all(10)),
              RiveContainer(type: RiveBoard.NotFound, width: Get.width, height: Get.height / 3.5),
              // LottieContainer(board: LottieBoard.Empty, width: Get.width, height: ,)
            ]);
          }

          // Build Cards
          else {
            controller.promptAutoSave();
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
        }));
  }

  Widget buildCard(int index) {
    // Get Card List
    List<TransferCard> list = controller.getCardList();
    bool isNew = false;

    // Check if New Card
    if (controller.status.value == HomeState.New) {
      isNew = index == 0;
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

class _SettingsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      // borderRadius: BorderRadius.circular(20),
      // margin: EdgeInsets.only(left: 15, right: 15, top: 75),
      // backendColor: Colors.transparent,
      height: Get.height / 3,
      child: Stack(children: [
        Container(
            width: Get.width,
            child: Obx(() => Container(
                  child: Column(children: [
                    // @ Title of Pane
                    Align(
                      heightFactor: 0.9,
                      alignment: Alignment.topCenter,
                      child: SonrText.header("Settings", size: 45),
                    ),
                    Padding(padding: EdgeInsetsX.top(28)),

                    // @ Dark Mode
                    Obx(() => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          // Dark Mode Title
                          SonrText.medium("Dark Mode"),

                          // Dark Mode Switch
                          NeumorphicSwitch(
                            style: NeumorphicSwitchStyle(
                              activeTrackColor: UserService.isDarkMode.value ? SonrColor.red : SonrColor.Blue,
                              inactiveTrackColor: UserService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
                            ),
                            value: UserService.isDarkMode.value,
                            onChanged: (val) => UserService.toggleDarkMode(),
                          )
                        ])),
                    Padding(padding: EdgeInsetsX.top(20)),

                    // @ Dark Mode
                    Obx(() => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          // Dark Mode Title
                          SonrText.medium("Point To Share"),

                          // Dark Mode Switch
                          NeumorphicSwitch(
                            style: NeumorphicSwitchStyle(
                              activeTrackColor: UserService.isDarkMode.value ? SonrColor.red : SonrColor.Blue,
                              inactiveTrackColor: UserService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
                            ),
                            value: UserService.hasPointToShare.value,
                            onChanged: (val) async {
                              if (val) {
                                // Overlay Prompt
                                SonrOverlay.question(
                                        barrierDismissible: false,
                                        title: "Wait!",
                                        description:
                                            "Point To Share is still experimental, performance may not be stable. \n Do you still want to continue?",
                                        acceptTitle: "Continue",
                                        declineTitle: "Cancel")
                                    .then((value) {
                                  // Check Result
                                  if (value) {
                                    UserService.togglePointToShare();
                                  } else {
                                    Get.back();
                                  }
                                });
                              } else {
                                UserService.togglePointToShare();
                              }
                            },
                          )
                        ])),
                    Spacer(),
                    // @ Version Number
                    Align(
                      heightFactor: 0.9,
                      alignment: Alignment.topCenter,
                      child: SonrText.light("Internal Alpha - 0.9.1", size: 16),
                    ),
                    Padding(padding: EdgeInsetsX.top(20)),
                  ]),
                )))
      ]),
    );
  }
}
