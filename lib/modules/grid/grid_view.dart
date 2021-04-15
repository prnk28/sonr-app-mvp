import 'dart:ui';
import 'package:sonr_app/modules/common/contact/contact.dart';
import 'package:sonr_app/modules/common/file/file.dart';
import 'package:sonr_app/modules/common/media/card_view.dart';
import 'package:sonr_app/modules/common/url/card_view.dart';
import 'package:sonr_app/service/cards.dart';
import 'package:sonr_app/theme/theme.dart';
import 'grid_controller.dart';
import 'tags_view.dart';

const K_LIST_HEIGHT = 225.0;

// ^ Root Grid View ^ //
class CardMainView extends GetView<GridController> {
  CardMainView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: CustomScrollView(primary: true, slivers: [
          _CardSearchView(),
          SliverPadding(padding: EdgeInsets.only(top: 24)),
          SliverToBoxAdapter(child: "Recents".headFour(align: TextAlign.start)),
          SliverToBoxAdapter(
            child: TagsView(
              tags: ["All", "Files", "Media", "Contacts", "Links"],
            ),
          ),
          SliverPadding(padding: EdgeInsets.only(top: 24)),
          SliverToBoxAdapter(
              child: Container(
            height: K_LIST_HEIGHT,
            child: TabBarView(controller: controller.tabController, children: [
              _CardGridAll(),
              _CardGridFiles(),
              _CardGridMedia(),
              _CardGridContacts(),
              _CardGridLinks(),
            ]),
          )),
          SliverPadding(padding: EdgeInsets.all(8)),
        ]));
  }
}

class _CardSearchView extends GetView<GridController> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      floating: false,
      snap: false,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(alignment: Alignment.center, height: 180, width: Get.width, decoration: Neumorphism.floating(), child: "Search ".h4),
      ),
      expandedHeight: 120,
      // bottom:
    );
  }
}

class _RecentsTitleView extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        "Recents".headTwo(align: TextAlign.start),
        TagsView(
          tags: ["All", "Files", "Media", "Contacts", "Links"],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size(Get.width - 64, 76);
}

// ^ Card Grid View - All Cards ^ //
class _CardGridAll extends GetView<GridController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // @ 2. Build View
      if (CardService.allCards.length > 0) {
        return ListView.builder(
          itemCount: CardService.allCards.length,
          itemBuilder: (BuildContext context, int index) {
            return buildCard(CardService.allCards[index]);
          },
        );
      } else {
        return _CardGridEmpty(label: "No Cards Found");
      }
    });
  }

  // @ Helper Method Builds Cards for List
  Widget buildCard(TransferCardItem item) {
    if (item.payload == Payload.MEDIA) {
      return MediaCardView(item);
    } else if (item.payload == Payload.CONTACT) {
      return ContactCardView(item);
    } else {
      return FileCardView(item);
    }
  }
}

// ^ Card Grid View - Media Cards ^ //
class _CardGridMedia extends GetView<GridController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // @ 2. Build View
      if (CardService.mediaCards.length > 0) {
        return ListView.builder(
          itemCount: CardService.mediaCards.length,
          itemBuilder: (BuildContext context, int index) {
            return MediaCardView(CardService.mediaCards[index]);
          },
        );
      } else {
        return _CardGridEmpty(label: "No Media yet");
      }
    });
  }
}

// ^ Card Grid View - File Cards ^ //
class _CardGridFiles extends GetView<GridController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // @ 2. Build View
      if (CardService.fileCards.length > 0) {
        return ListView.builder(
          itemCount: CardService.fileCards.length,
          itemBuilder: (BuildContext context, int index) {
            return FileCardView(CardService.fileCards[index]);
          },
        );
      } else {
        return _CardGridEmpty(label: "No Files yet");
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
        return ListView.builder(
          itemCount: CardService.contactCards.length,
          itemBuilder: (BuildContext context, int index) {
            return ContactCardView(CardService.contactCards[index]);
          },
        );
      } else {
        return _CardGridEmpty(label: "No Contacts yet");
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
        return ListView.builder(
          itemCount: CardService.urlCards.length,
          itemBuilder: (BuildContext context, int index) {
            return URLCardView(CardService.urlCards[index]);
          },
        );
      } else {
        return _CardGridEmpty(label: "No URL Links yet");
      }
    });
  }
}

// @ Helper Method to Build Empty List Value
class _CardGridEmpty extends GetView<GridController> {
  final String label;

  const _CardGridEmpty({Key key, @required this.label}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: K_LIST_HEIGHT,
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: [
        Image.asset(
          controller.randomNoFilesPath(),
          height: 160,
          colorBlendMode: BlendMode.dst,
        ),
        label.p_Grey,
        Padding(padding: EdgeInsets.all(16)),
      ]),
    );
  }
}
