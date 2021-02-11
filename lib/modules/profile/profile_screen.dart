import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:sonr_core/models/models.dart' hide Platform;
import 'social_tile.dart';
import 'profile_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import 'header_view.dart';
import 'tile_stepper.dart';

class ProfileScreen extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    // Build View
    return SonrScaffold(
        body: _SliverViews(),
        floatingActionButton: NeumorphicFloatingActionButton(
            child: SonrIcon.gradient(Icons.add, FlutterGradientNames.morpheusDen),
            style: NeumorphicStyle(intensity: 0.85, depth: 10, shape: NeumorphicShape.convex),
            onPressed: () {
              Get.dialog(TileCreateStepper(), barrierColor: K_DIALOG_COLOR);
            }));
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
          SonrHeaderBar.sliver(
              leading: SonrButton.circle(
                  icon: SonrIcon.close,
                  onPressed: () => Get.offNamed("/home/profile"),
                  intensity: 0.85,
                  shadowLightColor: Colors.lightBlueAccent[50]),
              action: SonrButton.circle(icon: SonrIcon.more, onPressed: () => {}, intensity: 0.85, shadowLightColor: Colors.lightBlueAccent[50]),
              flexibleSpace: ContactHeader()),

          SliverPadding(padding: EdgeInsets.all(14)),

          // @ Builds List of Social Tile
          Obx(() => SocialsGrid(controller.socials, controller.focusTileIndex.value)),
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
          return AnimatedContainer(duration: Duration(milliseconds: 1500), child: SocialTileItem(tiles[index], index));
        }),
        gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12.0,
            crossAxisSpacing: 6.0,
            staggeredTileCount: tiles.length,
            staggeredTileBuilder: (index) {
              if (focusedIndex >= 0) {
                return focusedIndex == index ? StaggeredTile.count(4, 4) : StaggeredTile.count(2, 2);
              } else {
                return StaggeredTile.count(2, 2);
              }
            }));
  }
}
