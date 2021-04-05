import 'package:sonr_app/modules/nav/bottom_bar.dart';
import 'package:sonr_app/theme/theme.dart';
import '../../main.dart';
import 'search_view.dart';
import 'home_controller.dart';
import 'share_button.dart';
import 'carousel_view.dart';
import 'settings_sheet.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create Page Controller
    final pageController = PageController(viewportFraction: 0.8, keepPage: false);
    return GetX<HomeController>(
      init: HomeController(pageController),
      builder: (controller) {
        // Build Grid View
        var gridView;
        // Loading Cards
        if (controller.status.value == HomeState.Loading) {
          gridView = Center(child: CircularProgressIndicator());
        }

        // New User
        else if (controller.status.value == HomeState.First) {
          gridView = Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            SonrText.header("Welcome to Sonr"),
            SonrText.normal("Share to begin viewing your Cards!", color: SonrColor.Black.withOpacity(0.7), size: 18)
          ]);
        }

        // Zero Cards
        else if (controller.status.value == HomeState.None) {
          gridView = Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            SonrText.header("No Cards Found!", size: 32),
            Padding(padding: EdgeInsets.all(8)),
            LottieContainer(type: LottieBoard.David, width: Get.width, height: Get.height / 2.5, repeat: true),
            Padding(padding: EdgeInsets.all(16)),
          ]);
        }

        // Build Cards
        else {
          controller.promptAutoSave();
          if (controller.getCardList().length > 0) {
            gridView = StackedCardCarousel(
              initialOffset: 2,
              spaceBetweenItems: 435,
              onPageChanged: (int index) => controller.pageIndex(index),
              pageController: pageController,
              items: List<Widget>.generate(controller.getCardList().length, (idx) {
                return _buildCard(idx, controller);
              }),
            );
          } else {
            gridView = Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
              SonrText.header("No Cards Found!", size: 32),
              Padding(padding: EdgeInsets.all(8)),
              LottieContainer(type: LottieBoard.David, width: Get.width, height: Get.height / 2.5, repeat: true),
              Padding(padding: EdgeInsets.all(16)),
            ]);
          }
        }

        // Build Scaffold
        return SonrScaffold.appBarLeadingAction(
          resizeToAvoidBottomPadding: false,
          bottomNavigationBar: SonrBottomNavBar(),
          title: "Home",
          leading: _buildLeadingByMode(),
          action: ShapeButton.circle(
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
          body: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              padding: EdgeInsets.only(top: 8),
              margin: EdgeInsetsX.horizontal(24),
              child: NeumorphicToggle(
                style: NeumorphicToggleStyle(depth: 20, backgroundColor: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White),
                selectedIndex: controller.toggleIndex.value,
                onChanged: (val) => controller.setToggleCategory(val),
                thumb: Neumorphic(style: SonrStyle.toggle),
                children: [
                  ToggleElement(
                      background: Center(child: SonrText.medium("Media", color: SonrColor.Grey, size: 18)),
                      foreground: SonrIcon.neumorphicGradient(SonrIconData.media, FlutterGradientNames.newRetrowave, size: 24)),
                  ToggleElement(
                      background: Center(child: SonrText.medium("All", color: SonrColor.Grey, size: 18)),
                      foreground: SonrIcon.neumorphicGradient(SonrIconData.all_categories,
                          UserService.isDarkMode ? FlutterGradientNames.happyUnicorn : FlutterGradientNames.eternalConstance,
                          size: 22.5)),
                  ToggleElement(
                      background: Center(child: SonrText.medium("Contacts", color: SonrColor.Grey, size: 18)),
                      foreground: SonrIcon.neumorphicGradient(SonrIconData.friends, FlutterGradientNames.orangeJuice, size: 24)),
                ],
              ),
            ),
            Expanded(child: Container(child: gridView)),
          ]),
        );
      },
    );
  }

// ^ Helper Method for Test Mode Leading Button ^ //
  Widget _buildLeadingByMode() {
    if (K_TESTER_MODE) {
      return ShapeButton.circle(
        icon: SonrIcon.more,
        onPressed: () => Get.dialog(SettingsSheet(), barrierColor: Colors.transparent),
        shape: NeumorphicShape.flat,
      );
    } else {
      return ShapeButton.circle(
        icon: SonrIcon.profile,
        onPressed: () => Get.toNamed("/profile"),
        onLongPressed: () => UserService.toggleDarkMode(),
        shape: NeumorphicShape.flat,
      );
    }
  }

// ^ Helper Method for Test Mode Leading Button ^ //
  Widget _buildCard(int index, HomeController controller) {
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
