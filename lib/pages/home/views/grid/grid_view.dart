import 'dart:ui';
import 'package:sonr_app/modules/card/card.dart';
import 'package:sonr_app/service/user/cards.dart';
import 'package:sonr_app/style/style.dart';
import 'grid_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'search_view.dart';

const K_LIST_HEIGHT = 225.0;

/// @ Root Grid View
class CardMainView extends GetView<RecentsController> {
  CardMainView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.closeSearch(context),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: CustomScrollView(controller: controller.scrollController, slivers: [
            SliverToBoxAdapter(child: _CardSearchView()),
            SliverPadding(padding: EdgeInsets.only(top: 14)),
            Obx(() => SliverToBoxAdapter(
                child: Container(
                    height: Height.ratio(0.4) + 125,
                    child: AnimatedSlideSwitcher.fade(
                      child: _buildView(controller.view.value),
                    )))),
            SliverPadding(padding: EdgeInsets.all(8)),
          ])),
    );
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

  // # Builds Subview from Controller Status
  Widget _buildView(RecentsViewStatus status) {
    if (status == RecentsViewStatus.Default) {
      return Container(
        key: ValueKey(RecentsViewStatus.Default),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(padding: EdgeInsets.only(top: 8)),
          "Recents".headFour(align: TextAlign.start, color: Get.theme.focusColor),
          Padding(padding: EdgeInsets.only(top: 4)),
          TagsView(tags: _buildTags()),
          Padding(padding: EdgeInsets.only(top: 16)),
          Container(
              height: Height.ratio(0.4),
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  CardsGridView(type: TransferItemsType.All, controller: controller.scrollController),
                  CardsListView(type: TransferItemsType.Metadata, controller: controller.scrollController),
                  CardsListView(type: TransferItemsType.Contacts, controller: controller.scrollController),
                  CardsListView(type: TransferItemsType.Links, controller: controller.scrollController)
                ],
              ))
        ]),
      );
    } else {
      return SearchResultsView(key: ValueKey(RecentsViewStatus.Search));
    }
  }
}

/// @ Card Search View - Displays Search View
class _CardSearchView extends GetView<RecentsController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(16),
      height: 96,
      width: Width.ratio(0.4),
      alignment: Alignment.center,
      child: Container(
          child: Obx(() => SonrSearchField.forCards(
                value: controller.query.value,
                onChanged: (val) {
                  controller.query(val);
                  controller.query.refresh();
                },
              ))),
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
