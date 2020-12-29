import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:sonar_app/modules/profile/tile_dialog.dart';
import 'package:sonr_core/models/models.dart';
import 'tile_item.dart';
import 'profile_controller.dart';
import 'package:sonar_app/theme/theme.dart';
import 'header_view.dart';

class ProfileScreen extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    // Build View
    return SonrTheme(
        child: Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: _SliverViews(),
      floatingActionButton: NeumorphicFloatingActionButton(
          child: SonrIcon.gradient(Icons.add, FlutterGradientNames.morpheusDen),
          style: NeumorphicStyle(
              intensity: 0.45, depth: 8, shape: NeumorphicShape.convex),
          onPressed: () {
            Get.dialog(TileDialog(), barrierColor: K_DIALOG_COLOR);
          }),
    ));
  }
}

class _SliverViews extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    // Create View
    return NeumorphicBackground(
      backendColor: Colors.transparent,
      child: CustomScrollView(
        slivers: [
          // @ Builds Profile Header
          SliverAppBar(
            pinned: true,
            floating: true,
            snap: true,
            primary: true,
            automaticallyImplyLeading: false,
            toolbarHeight: kToolbarHeight + 16 * 2,
            flexibleSpace: ContactHeader(),
            expandedHeight: 285,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // @ Close Button
                Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: SonrButton.appBar(
                        SonrIcon.close, () => Get.offNamed("/home/profile"),
                        intensity: 0.4)),

                // @ More Button
                Padding(
                    padding: EdgeInsets.only(right: 4.0),
                    child: SonrButton.appBar(SonrIcon.more, () => {},
                        intensity: 0.4)),
              ],
            ),
          ),

          SliverPadding(padding: EdgeInsets.all(14)),

          // @ Builds List of Social Tile
          Obx(() =>
              SocialsGrid(controller.socials, controller.focusTileIndex.value)),
        ],
      ),
    );
  }
}

class SocialsGrid extends StatelessWidget {
  final List<Contact_SocialTile> tiles;
  final int focusedIndex;

  const SocialsGrid(
    this.tiles,
    this.focusedIndex, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverStaggeredGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          return AnimatedContainer(
              duration: Duration(milliseconds: 1500),
              child: SocialTileItem(tiles[index], index));
        }),
        gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12.0,
            crossAxisSpacing: 6.0,
            staggeredTileCount: tiles.length,
            staggeredTileBuilder: (index) {
              if (focusedIndex >= 0) {
                return focusedIndex == index
                    ? StaggeredTile.count(4, 4)
                    : StaggeredTile.count(2, 2);
              } else {
                return StaggeredTile.count(2, 2);
              }
            }));
  }
}
