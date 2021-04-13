import 'package:sonr_app/modules/share/index_view.dart';
import 'package:sonr_app/modules/common/contact/contact.dart';
import 'package:sonr_app/modules/common/file/file.dart';
import 'package:sonr_app/modules/common/media/media.dart';
import 'package:sonr_app/modules/share/share.dart';
import 'package:sonr_app/theme/buttons/utility.dart';
import 'package:sonr_app/theme/elements/carousel.dart';
import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/service/cards.dart';
import 'package:sonr_app/pages/home/tag_widget.dart';
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
          appBar: DesignAppBar(
            title: HomeAppBarTitle(),
            action: HomeActionButton(),
          ),
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
        child: cardList.length > 0 ? _CardGridWidget(cardList, pageController) : _CardGridEmpty(),
      );
    });
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
        return _CardGridEmpty();
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

// @ Helper Method to Build Empty List Value
class _CardGridEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      "No Cards Found!".h3,
      Padding(padding: EdgeInsets.all(8)),
      LottieContainer(type: LottieBoard.David, width: Get.width, height: Get.height / 2.5, repeat: true),
      Padding(padding: EdgeInsets.all(16)),
    ]);
  }
}

class CardToggleFilter extends GetView<HomeController> {
  CardToggleFilter({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      child: Obx(
        () => GestureDetector(
          onTap: controller.handleAction,
          child: Opacity(
            opacity: 0.85,
            child: AnimatedContainer(
              width: controller.isFilterOpen.value ? 360 : 56,
              height: controller.isFilterOpen.value ? 56 : 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: SonrColor.White),
              duration: ButtonUtility.K_BUTTON_DURATION,
              child: controller.isFilterOpen.value
                  ? TagView(
                      tags: [
                        Tuple(Icon(SonrIconData.all_categories, color: SonrColor.White, size: 20), "All"),
                        Tuple(Icon(SonrIconData.media, color: SonrColor.White, size: 20), "Media"),
                        Tuple(Icon(SonrIconData.friends, color: SonrColor.White, size: 20), "Contacts")
                      ],
                    )
                  : Icon(
                      Icons.filter_alt_outlined,
                      color: SonrColor.Black,
                      size: 34,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggle() {
    return NeumorphicToggle(
      style: NeumorphicToggleStyle(depth: 20, backgroundColor: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White),
      selectedIndex: controller.toggleIndex.value,
      onChanged: (val) => controller.setToggleCategory(val),
      thumb: Neumorphic(style: SonrStyle.toggle),
      children: [
        ToggleElement(
            background: Center(child: SonrIcon.normal(SonrIconData.media, color: SonrColor.Grey, size: 24)),
            foreground: SonrIcon.neumorphicGradient(SonrIconData.media, FlutterGradientNames.newRetrowave, size: 24)),
        ToggleElement(
            background: Center(child: SonrIcon.normal(SonrIconData.all_categories, color: SonrColor.Grey, size: 22.5)),
            foreground: SonrIcon.neumorphicGradient(SonrIconData.all_categories, FlutterGradientNames.eternalConstance, size: 22.5)),
        ToggleElement(
            background: Center(child: SonrIcon.normal(SonrIconData.friends, color: SonrColor.Grey, size: 24)),
            foreground: SonrIcon.neumorphicGradient(SonrIconData.friends, FlutterGradientNames.orangeJuice, size: 24)),
      ],
    );
  }

  Widget buildBubbles() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          padding: EdgeInsets.all(4),
          child: "All".p_White,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.black.withOpacity(0.85)),
        ),
        Container(
          padding: EdgeInsets.all(4),
          child: "Media".p_White,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.orange.withOpacity(0.85)),
        ),
        Container(
          padding: EdgeInsets.all(4),
          child: "Contacts".p_White,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.purple.withOpacity(0.85)),
        ),
      ]),
    );
  }
}
