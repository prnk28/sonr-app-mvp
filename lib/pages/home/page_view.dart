import 'package:sonr_app/modules/share/index_view.dart';
import 'package:sonr_app/modules/common/contact/contact.dart';
import 'package:sonr_app/modules/common/file/file.dart';
import 'package:sonr_app/modules/common/media/media.dart';
import 'package:sonr_app/modules/share/share.dart';
import 'package:sonr_app/theme/elements/carousel.dart';
import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/service/cards.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/modules/profile/profile_view.dart';
import 'package:sonr_app/modules/remote/remote_view.dart';
import 'home_controller.dart';
import 'alerts_view.dart';
import 'home_nav.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Get.find<ShareController>().shrink,
      onHorizontalDragEnd: (_) => controller.swipeComplete(),
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        int sensitivity = 8;
        if (details.delta.dx > sensitivity) {
          controller.swipeRight();
        } else if (details.delta.dx < -sensitivity) {
          controller.swipeLeft();
        }
      },
      child: SonrScaffold(
          resizeToAvoidBottomInset: false,
          shareView: ShareView(),
          bottomNavigationBar: HomeBottomNavBar(),
          appBar: DesignAppBar(title: HomeAppBarTitle()),
          body: Obx(() => AnimatedSlideSwitcher(
                controller.switchAnimation,
                _buildView(controller.page.value),
                const Duration(milliseconds: 2500),
              ))),
    );
  }

  // @ Build Page View by Navigation Item
  Widget _buildView(HomeView page) {
    // Return View
    if (page == HomeView.Profile) {
      return ProfileView(key: ValueKey<HomeView>(HomeView.Profile));
    } else if (page == HomeView.Alerts) {
      return AlertsView(key: ValueKey<HomeView>(HomeView.Alerts));
    } else if (page == HomeView.Remote) {
      return RemoteView(key: ValueKey<HomeView>(HomeView.Remote));
    } else {
      return CardGridView(
        key: ValueKey<HomeView>(HomeView.Home),
      );
    }
  }
}

// ^ Card Grid View ^ //
class CardGridView extends GetView<HomeController> {
  CardGridView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageController = PageController(viewportFraction: 0.8);
    return Obx(() {
      List<TransferCardItem> cardList;
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

      return SafeArea(
        maintainBottomViewPadding: true,
        child: Container(child: Column(children: [_CardGridToggle(), Expanded(child: _CardGridWidget(cardList, pageController))])),
      );
    });
  }
}

class _CardGridToggle extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      height: 40,
      margin: EdgeWith.horizontal(24),
      child: NeumorphicToggle(
        style: NeumorphicToggleStyle(depth: 20, backgroundColor: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White),
        selectedIndex: controller.toggleIndex.value,
        onChanged: (val) => controller.setToggleCategory(val),
        thumb: Neumorphic(style: SonrStyle.toggle),
        children: [
          ToggleElement(
              background: Center(child: "Media".h6_Grey),
              foreground: SonrIcon.neumorphicGradient(SonrIconData.media, FlutterGradientNames.newRetrowave, size: 24)),
          ToggleElement(
              background: Center(child: "All".h6_Grey),
              foreground: SonrIcon.neumorphicGradient(
                  SonrIconData.all_categories, UserService.isDarkMode ? FlutterGradientNames.happyUnicorn : FlutterGradientNames.eternalConstance,
                  size: 22.5)),
          ToggleElement(
              background: Center(child: "Contacts".h6_Grey),
              foreground: SonrIcon.neumorphicGradient(SonrIconData.friends, FlutterGradientNames.orangeJuice, size: 24)),
        ],
      ),
    );
  }
}

class _CardGridWidget extends GetView<HomeController> {
  final List<TransferCardItem> cardList;
  final PageController pageController;
  _CardGridWidget(this.cardList, this.pageController);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
          "No Cards Found!".h1,
          Padding(padding: EdgeInsets.all(8)),
          LottieContainer(type: LottieBoard.David, width: Get.width, height: Get.height / 2.5, repeat: true),
          Padding(padding: EdgeInsets.all(16)),
        ]);
      }
    });
  }

  // @ Helper Method for Test Mode Leading Button ^ //
  Widget _buildCard(TransferCardItem item) {
    // Determin CardView
    if (item.payload == Payload.MEDIA) {
      return MediaCardView(item);
    } else if (item.payload == Payload.CONTACT) {
      return ContactCardView(item);
    } else {
      return FileCardView(item);
    }
  }
}
