import 'dart:ui';
import 'package:sonr_app/modules/card/card.dart';
import 'package:sonr_app/service/user/cards.dart';
import 'package:sonr_app/style/style.dart';
import 'grid_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const K_LIST_HEIGHT = 225.0;

/// @ Root Grid View
class CardMainView extends GetView<RecentsController> {
  CardMainView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: CustomScrollView(primary: true, slivers: [
          _CardSearchView(),
          SliverPadding(padding: EdgeInsets.only(top: 8)),
          SliverToBoxAdapter(child: "Recents".headFour(align: TextAlign.start, color: Get.theme.focusColor)),
          SliverToBoxAdapter(
            child: TagsView(
              tags: _buildTags(),
            ),
          ),
          SliverPadding(padding: EdgeInsets.only(top: 24)),
          SliverToBoxAdapter(
            child: Container(
                height: K_LIST_HEIGHT,
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: controller.tabController,
                  children: [
                    CardsGridView(type: TransferItemsType.All),
                    CardsListView(type: TransferItemsType.Metadata),
                    CardsListView(type: TransferItemsType.Contacts),
                    CardsListView(type: TransferItemsType.Links)
                  ],
                )),
          ),
          SliverPadding(padding: EdgeInsets.all(8)),
        ]));
  }

  // # Build Tags
  List<Tuple<String, int>> _buildTags() {
    var list = <Tuple<String, int>>[Tuple("All", 0)];

    // Check Files Length
    if (CardService.hasMetadata) {
      list.add(Tuple("Files", 1));
    }

    // Check Contacts Length
    if (CardService.hasContacts) {
      list.add(Tuple("Contacts", 2));
    }

    // Check URLs Length
    if (CardService.hasLinks) {
      list.add(Tuple("Links", 3));
    }
    return list;
  }
}

/// @ Card Search View - Displays Search View
class _CardSearchView extends StatelessWidget {
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
            decoration: Neumorphic.floating(theme: Get.theme),
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(16),
            height: 100,
            width: Width.ratio(0.4),
            alignment: Alignment.center,
            child: Container(
              decoration: Neumorphic.floating(theme: Get.theme, radius: 40),
              child: Row(
                children: [
                  SonrIcons.Search.white,
                  TextField(),
                ],
              ),
            )),
      ),
      expandedHeight: 150,
      // bottom:
    );
  }
}

/// @ Card Tag View
class TagsView extends GetView<RecentsController> {
  final List<Tuple<String, int>>? tags;

  const TagsView({Key? key, this.tags}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        controller: controller.scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List<Widget>.generate(
              tags!.length,
              (index) => GestureDetector(
                    onTap: () {
                      controller.setTag(tags![index].item2);
                    },
                    child: _TagItem(tags![index].item1, tags![index].item2),
                  )),
        ),
      ),
    );
  }
}

/// @ Card Tag Item
class _TagItem extends GetView<RecentsController> {
  final String data;
  final int index;
  const _TagItem(this.data, this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedContainer(
        decoration: controller.tagIndex.value == index
            ? BoxDecoration(borderRadius: BorderRadius.circular(40), color: SonrColor.Primary.withOpacity(0.9))
            : BoxDecoration(),
        constraints: BoxConstraints(maxHeight: 50),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        duration: 150.milliseconds,
        child: controller.tagIndex.value == index ? data.h6_White : data.h6_Grey));
  }
}
