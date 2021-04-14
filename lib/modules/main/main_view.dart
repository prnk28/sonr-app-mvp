import 'dart:ui';

import 'package:sonr_app/modules/common/contact/contact.dart';
import 'package:sonr_app/modules/common/file/file.dart';
import 'package:sonr_app/modules/common/media/media.dart';
import 'package:sonr_app/modules/grid/tags_view.dart';
import 'package:sonr_app/theme/elements/carousel.dart';
import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/service/cards.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/data/data.dart';
import '../../pages/home/home_controller.dart';

// ^ Card Recents View ^ //
class CardRecentsView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: 250,
      child: Obx(() => ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: CardService.allCards.length,
            itemBuilder: (context, index) {
              return MediaCardView(CardService.allCards[index]);
            },
          )),
    );
  }
}

class CardMainView extends GetView<HomeController> {
  CardMainView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          "Recents".headTwo(align: TextAlign.start),
          TagsView(
            tags: ["All", "Media", "Contacts"],
          ),
          CardGridView(),
        ]));
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
        return Container(
          padding: EdgeInsets.only(top: 24),
          child: StackedCardCarousel(
            initialOffset: 2,
            spaceBetweenItems: 435,
            onPageChanged: (int index) => controller.pageIndex(index),
            pageController: pageController,
            items: List<Widget>.generate(cardList.length, (idx) {
              return _buildCard(cardList[idx]);
            }),
          ),
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
      "No Cards Found!".h5,
      Padding(padding: EdgeInsets.all(8)),
      LottieContainer(type: LottieBoard.David, width: Get.width, height: 150, repeat: true),
      Padding(padding: EdgeInsets.all(16)),
    ]);
  }
}
