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

  // # Builds Subview from Controller Status
  Widget _buildView(RecentsViewStatus status) {
    if (status == RecentsViewStatus.Default) {
      return Container(
        height: Height.ratio(0.46),
        key: ValueKey(RecentsViewStatus.Default),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(padding: EdgeInsets.only(top: 8)),
          "Quick Access".headFour(align: TextAlign.start, color: Get.theme.focusColor),
          Padding(padding: EdgeInsets.only(top: 4)),
          Container(
            height: Height.ratio(0.45),
            padding: EdgeInsets.all(8),
            child: GridView.builder(
                itemCount: TransferItemsType.values.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                ),
                itemBuilder: (context, index) {
                  return _QuickOptionButton(data: TransferItemsType.values[index]);
                }),
          ),
        ]),
      );
    } else {
      return SearchResultsView(key: ValueKey(RecentsViewStatus.Search));
    }
  }
}

/// @ Card Search View - Displays Search View
class _CardSearchView extends GetView<DashboardController> {
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

class _QuickOptionButton extends StatelessWidget {
  final TransferItemsType data;
  const _QuickOptionButton({Key? key, required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(QuickAccessScreen(type: data), transition: Transition.rightToLeftWithFade),
      child: Container(
        decoration: Neumorphic.floating(theme: Get.theme, radius: 24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          data.icon(),
          Padding(padding: EdgeInsets.only(top: 8)),
          data.label(),
        ]),
      ),
    );
  }
}
