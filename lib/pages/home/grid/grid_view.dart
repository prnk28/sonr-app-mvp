import 'dart:ui';
import 'package:sonr_app/modules/contact/contact.dart';
import 'package:sonr_app/modules/file/file.dart';
import 'package:sonr_app/modules/media/card_view.dart';
import 'package:sonr_app/modules/url/card_view.dart';
import 'package:sonr_app/service/user/cards.dart';
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
              tags: _buildTags(),
            ),
          ),
          SliverPadding(padding: EdgeInsets.only(top: 24)),
          SliverToBoxAdapter(
              child: Container(
            height: K_LIST_HEIGHT,
            child: TabBarView(controller: controller.tabController, children: _buildViews()),
          )),
          SliverPadding(padding: EdgeInsets.all(8)),
        ]));
  }

  // # Build Tags
  List<String> _buildTags() {
    var list = <String>["All"];

    // Check Files Length
    if (CardService.hasFiles) {
      list.add("Files");
    }

    // Check Media Length
    if (CardService.hasMedia) {
      list.add("Media");
    }

    // Check Contacts Length
    if (CardService.hasContacts) {
      list.add("Contacts");
    }

    // Check URLs Length
    if (CardService.hasURLs) {
      list.add("Links");
    }
    return list;
  }

  // # Build Views
  List<Widget> _buildViews() {
    var list = <Widget>[_CardGridAll()];

    // Check Files Length
    if (CardService.hasFiles) {
      list.add(_CardGridFiles());
    }

    // Check Media Length
    if (CardService.hasMedia) {
      list.add(_CardGridMedia());
    }

    // Check Contacts Length
    if (CardService.hasContacts) {
      list.add(_CardGridContacts());
    }

    // Check URLs Length
    if (CardService.hasURLs) {
      list.add(_CardGridLinks());
    }
    return list;
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
        background: Container(
          clipBehavior: Clip.antiAlias,
          decoration: Neumorph.floating(),
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.all(32),
          width: Get.width,
          child: Container(
            width: context.widthTransformer(reducedBy: 0.8),
            height: context.heightTransformer(reducedBy: 0.6),
            alignment: Alignment.center,
            child: "Search ".h4,
          ),
        ),
      ),
      expandedHeight: 120,
      // bottom:
    );
  }
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
        AssetController.randomNoFiles(),
        label.p_Grey,
        Padding(padding: EdgeInsets.all(16)),
      ]),
    );
  }
}
