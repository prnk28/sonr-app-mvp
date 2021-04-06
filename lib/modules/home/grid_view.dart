import 'package:sonr_app/service/cards.dart';
import 'package:sonr_app/theme/theme.dart';
import 'home_controller.dart';
import 'carousel_view.dart';

// ^ Card Grid View ^ //
class CardGridView extends GetView<HomeController> {
  CardGridView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        Expanded(child: Container(child: _CardGridWidget(cardList))),
      ]);
    });
  }
}

class _CardGridWidget extends GetView<HomeController> {
  final List<TransferCardItem> cardList;

  _CardGridWidget(this.cardList);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pageController = PageController(viewportFraction: 0.8);

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
