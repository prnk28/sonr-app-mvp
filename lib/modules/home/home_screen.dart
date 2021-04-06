import 'package:sonr_app/modules/nav/app_bar.dart';
import 'package:sonr_app/service/cards.dart';
import 'package:sonr_app/theme/theme.dart';
import 'bottom_bar.dart';
import 'home_controller.dart';
import 'carousel_view.dart';

class HomeScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return SonrScaffold(
        appBar: SonrAppBar(
          title: "Home",
        ),
        bottomNavigationBar: HomeBottomNavBar(),
        body: Obx(() => AnimatedSlideSwitcher(controller.getSwitcherAnimation(), _buildView(controller.page.value), const Duration(seconds: 3))));
  }

  // @ Build Page View by Navigation Item
  Widget _buildView(BottomNavButton page) {
    // Return View
    if (page == BottomNavButton.Profile) {
      return ProfileView(key: ValueKey<BottomNavButton>(BottomNavButton.Profile));
    } else if (page == BottomNavButton.Alerts) {
      return AlertsView(key: ValueKey<BottomNavButton>(BottomNavButton.Alerts));
    } else if (page == BottomNavButton.Remote) {
      return RemoteView(key: ValueKey<BottomNavButton>(BottomNavButton.Remote));
    } else {
      return CardGridView(key: ValueKey<BottomNavButton>(BottomNavButton.Grid));
    }
  }
}

// ^ Card Grid View ^ //
class CardGridView extends GetView<HomeController> {
  CardGridView({Key key}) : super(key: key);
  final pageController = PageController(viewportFraction: 0.8);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                  foreground: SonrIcon.neumorphicGradient(
                      SonrIconData.all_categories, UserService.isDarkMode ? FlutterGradientNames.happyUnicorn : FlutterGradientNames.eternalConstance,
                      size: 22.5)),
              ToggleElement(
                  background: Center(child: SonrText.medium("Contacts", color: SonrColor.Grey, size: 18)),
                  foreground: SonrIcon.neumorphicGradient(SonrIconData.friends, FlutterGradientNames.orangeJuice, size: 24)),
            ],
          ),
        ),
        Expanded(child: Container(child: _buildView())),
      ]);
    });
  }

  // @ Builds Grid View by Card Count
  Widget _buildView() {
    // Loading Cards
    if (controller.status.value == HomeState.Loading) {
      return Center(child: CircularProgressIndicator());
    }

    // New User
    else if (controller.status.value == HomeState.First) {
      return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
        SonrText.header("Welcome to Sonr"),
        SonrText.normal("Share to begin viewing your Cards!", color: SonrColor.Black.withOpacity(0.7), size: 18)
      ]);
    }

    // Zero Cards
    else if (controller.status.value == HomeState.None) {
      return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
        SonrText.header("No Cards Found!", size: 32),
        Padding(padding: EdgeInsets.all(8)),
        LottieContainer(type: LottieBoard.David, width: Get.width, height: Get.height / 2.5, repeat: true),
        Padding(padding: EdgeInsets.all(16)),
      ]);
    }

    // Build Cards
    else {
      return Obx(() {
        // @ 1. Set List
        var cardList = <TransferCardItem>[];
        // Media
        if (controller.toggleIndex.value == 0) {
          cardList = CardService.mediaCards;
        }
        // Contacts
        else if (controller.toggleIndex.value == 2) {
          cardList = CardService.contactCards;
        }
        // All
        else {
          cardList = CardService.allCards;
        }

        // @ 2. Build View
        if (cardList.length > 0) {
          return StackedCardCarousel(
            initialOffset: 2,
            spaceBetweenItems: 435,
            onPageChanged: (int index) => controller.pageIndex(index),
            pageController: pageController,
            items: List<Widget>.generate(cardList.length, (idx) {
              return _buildCard(cardList[idx]);
            }),
          );
        } else {
          return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            SonrText.header("No Cards Found!", size: 32),
            Padding(padding: EdgeInsets.all(8)),
            LottieContainer(type: LottieBoard.David, width: Get.width, height: Get.height / 2.5, repeat: true),
            Padding(padding: EdgeInsets.all(16)),
          ]);
        }
      });
    }
  }

  // @ Helper Method for Test Mode Leading Button ^ //
  Widget _buildCard(TransferCardItem item) {
    // Determin CardView
    if (item.payload == Payload.MEDIA) {
      return MediaCard.item(item);
    } else if (item.payload == Payload.CONTACT) {
      return ContactCard.item(item);
    } else {
      return FileCard.item(item);
    }
  }
}

// ^ Profile View ^ //
class ProfileView extends GetView<HomeController> {
  ProfileView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      SonrText.header("Profile View"),
      SonrText.normal("Share to begin viewing your Cards!", color: SonrColor.Black.withOpacity(0.7), size: 18),
      Padding(padding: EdgeInsets.all(16)),
    ]);
  }
}

// ^ Remote View ^ //
class RemoteView extends GetView<HomeController> {
  RemoteView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      SonrText.header("Remote View"),
      SonrText.normal("Share to begin viewing your Cards!", color: SonrColor.Black.withOpacity(0.7), size: 18),
      Padding(padding: EdgeInsets.all(16)),
    ]);
  }
}

// ^ Alerts View ^ //
class AlertsView extends GetView<HomeController> {
  AlertsView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      SonrText.header("Alerts View"),
      SonrText.normal("Share to begin viewing your Cards!", color: SonrColor.Black.withOpacity(0.7), size: 18),
      Padding(padding: EdgeInsets.all(16)),
    ]);
  }
}
