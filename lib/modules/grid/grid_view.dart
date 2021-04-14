import 'dart:ui';
import 'package:sonr_app/service/cards.dart';
import 'package:sonr_app/theme/theme.dart';
import 'grid_controller.dart';
import 'tags_view.dart';

// ^ Root Grid View ^ //
class CardMainView extends GetView<GridController> {
  CardMainView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.start, children: [
          "Recents".headTwo(align: TextAlign.start),
          TagsView(
            tags: ["All", "Media", "Contacts", "Links"],
          ),
          Obx(() => TabBarView(controller: controller.tabController, children: [
                _CardGridAll(),
                _CardGridMedia(),
                _CardGridContacts(),
                _CardGridLinks(),
              ])),
        ]));
  }
}

// ^ Card Grid View - All Cards ^ //
class _CardGridAll extends GetView<GridController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // @ 2. Build View
      if (CardService.allCards.length > 0) {
        return Container(
          padding: EdgeInsets.only(top: 24),
          child: ListView.builder(
            itemCount: CardService.allCards.length,
            itemBuilder: (BuildContext context, int index) {
              return controller.buildCard(CardService.allCards[index]);
            },
          ),
        );
      } else {
        return _CardGridEmpty();
      }
    });
  }
}

// ^ Card Grid View - Media Cards ^ //
class _CardGridMedia extends GetView<GridController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // @ 2. Build View
      if (CardService.mediaCards.length > 0) {
        return Container(
          padding: EdgeInsets.only(top: 24),
          child: ListView.builder(
            itemCount: CardService.mediaCards.length,
            itemBuilder: (BuildContext context, int index) {
              return controller.buildCard(CardService.mediaCards[index]);
            },
          ),
        );
      } else {
        return _CardGridEmpty();
      }
    });
  }
}

// ^ Card Grid View - Contact Cards ^ //
class _CardGridContacts extends GetView<GridController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // @ 2. Build View
      if (CardService.contactCards.length > 0) {
        return Container(
          padding: EdgeInsets.only(top: 24),
          child: ListView.builder(
            itemCount: CardService.contactCards.length,
            itemBuilder: (BuildContext context, int index) {
              return controller.buildCard(CardService.contactCards[index]);
            },
          ),
        );
      } else {
        return _CardGridEmpty();
      }
    });
  }
}

// ^ Card Grid View - URL Cards ^ //
class _CardGridLinks extends GetView<GridController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // @ 2. Build View
      if (CardService.urlCards.length > 0) {
        return Container(
          padding: EdgeInsets.only(top: 24),
          child: ListView.builder(
            itemCount: CardService.urlCards.length,
            itemBuilder: (BuildContext context, int index) {
              return controller.buildCard(CardService.urlCards[index]);
            },
          ),
        );
      } else {
        return _CardGridEmpty();
      }
    });
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
