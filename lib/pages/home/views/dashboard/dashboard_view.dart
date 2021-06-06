import 'dart:ui';
import 'package:sonr_app/pages/home/views/dashboard/quick_screen.dart';
import 'package:sonr_app/style/style.dart';
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
    Posthog().screen(screenName: "Dashboard");
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
          "Quick Access".subheading(align: TextAlign.start, color: Get.theme.focusColor),
          Padding(padding: EdgeInsets.only(top: 4)),
          Container(
              height: Height.ratio(0.425),
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _QuickOptionButton(data: TransferItemsType.values[0]),
                      _QuickOptionButton(data: TransferItemsType.values[1]),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _QuickOptionButton(data: TransferItemsType.values[2]),
                      _QuickOptionButton(data: TransferItemsType.values[3]),
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

class _QuickOptionButton extends StatelessWidget {
  final TransferItemsType data;
  const _QuickOptionButton({Key? key, required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(QuickAccessScreen(type: data), transition: Transition.rightToLeftWithFade),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            decoration: Neumorphic.floating(theme: Get.theme),
            child: data.image(),
            padding: EdgeInsets.all(8),
          ),
          Padding(padding: EdgeInsets.only(top: 8)),
          data.label(),
        ]),
      ),
    );
  }
}
