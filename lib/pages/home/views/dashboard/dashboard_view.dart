import 'dart:ui';
import 'package:sonr_app/pages/detail/detail_page.dart';
import 'package:sonr_app/style.dart';
import 'dashboard_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'search_view.dart';

const K_LIST_HEIGHT = 225.0;

/// @ Root Grid View
class DashboardView extends GetView<DashboardController> {
  DashboardView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.closeSearch(context),
      child: Container(
          padding: EdgeInsets.all(8),
          margin: _getMargin(context),
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

  // # Builds Subview from Controller Status
  Widget _buildView(RecentsViewStatus status) {
    if (status == RecentsViewStatus.Default) {
      return Container(
        height: Height.ratio(0.46),
        key: ValueKey(RecentsViewStatus.Default),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(padding: EdgeInsets.only(top: 8)),
          "My Stuff".section(align: TextAlign.start, color: Get.theme.focusColor),
          Padding(padding: EdgeInsets.only(top: 4)),
          Container(
              height: Height.ratio(0.435),
              width: Width.ratio(0.9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ImageButton(
                        path: TransferItemsType.Media.imagePath(),
                        label: TransferItemsType.Media.name(),
                        imageFit: BoxFit.fitWidth,
                        imageWidth: 130,
                        onPressed: () {
                          if (TransferItemsType.Media.count() > 0) {
                            Details.toPostsList(TransferItemsType.Media);
                          } else {
                            Details.toError(DetailPageType.ErrorEmptyMedia);
                          }
                        },
                      ),
                      ImageButton(
                        path: TransferItemsType.Files.imagePath(),
                        label: TransferItemsType.Files.name(),
                        onPressed: () {
                          if (TransferItemsType.Files.count() > 0) {
                            Details.toPostsList(TransferItemsType.Files);
                          } else {
                            Details.toError(DetailPageType.ErrorEmptyFiles);
                          }
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ImageButton(
                        path: TransferItemsType.Contacts.imagePath(),
                        label: TransferItemsType.Contacts.name(),
                        onPressed: () {
                          if (TransferItemsType.Contacts.count() > 0) {
                            Details.toPostsList(TransferItemsType.Contacts);
                          } else {
                            Details.toError(DetailPageType.ErrorEmptyContacts);
                          }
                        },
                      ),
                      ImageButton(
                        path: TransferItemsType.Links.imagePath(),
                        imageWidth: 90,
                        imageHeight: 90,
                        label: TransferItemsType.Links.name(),
                        onPressed: () {
                          if (TransferItemsType.Links.count() > 0) {
                            Details.toPostsList(TransferItemsType.Links);
                          } else {
                            Details.toError(DetailPageType.ErrorEmptyLinks);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              )),
        ]),
      );
    } else {
      return SearchResultsView(key: ValueKey(RecentsViewStatus.Search));
    }
  }

  // # Gets View Margin for Dashboard
  EdgeInsets _getMargin(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return EdgeInsets.only(left: width * 0.05, right: width * 0.05);
  }
}

/// @ Card Search View - Displays Search View
class _CardSearchView extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      height: 108,
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
