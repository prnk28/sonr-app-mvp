import 'package:sonr_app/theme/theme.dart';
import 'grid_controller.dart';

class CardStatsView extends GetView<GridController> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      floating: false,
      snap: false,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: _StatsHeaderWidget(),
      ),
      expandedHeight: 120,
      // bottom:
    );
  }
}

class _StatsHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _StatsGraphItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
