import 'dart:ui';
import 'package:sonr_app/modules/card/url/card.dart';
import 'package:sonr_app/service/user/cards.dart';
import 'package:sonr_app/style/style.dart';
import 'recents_controller.dart';
import 'package:fl_chart/fl_chart.dart';
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
          _CardStatsView(),
          SliverPadding(padding: EdgeInsets.only(top: 8)),
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
                child: TabBarView(controller: controller.tabController, children: [
                  CardsGridView(type: TransferItemsType.All),
                  CardsListView(type: TransferItemsType.Metadata),
                  CardsListView(type: TransferItemsType.Contacts),
                  CardsListView(type: TransferItemsType.Links)
                ])),
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

/// @ Card Stats View - Displays Pie Chart
class _CardStatsView extends StatelessWidget {
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
          decoration: Neumorphic.floating(color: SonrColor.Primary),
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.all(16),
          height: 100,
          width: Width.ratio(0.4),
          alignment: Alignment.center,
          child: StorageChart(),
        ),
      ),
      expandedHeight: 200,
      // bottom:
    );
  }
}

/// @ Card Storage Chart Widget
class StorageChart extends GetView<RecentsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          child: PieChart(
            PieChartData(
                pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) => controller.tapChart(pieTouchResponse)),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 0,
                sections: controller.chartData),
          ),
        ));
  }
}

/// @ Graph Element Badge Widget
class Badge extends StatelessWidget {
  final double size;
  final Color borderColor;
  final Widget child;

  const Badge({
    Key? key,
    required this.size,
    required this.borderColor,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: Neumorphic.compact(shape: BoxShape.circle),
      child: Center(child: child),
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
