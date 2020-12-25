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
    return Obx(() {
      // Get Tile Count
      int count = controller.socials.length;

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
                    child: NeumorphicButton(
                      padding: EdgeInsets.all(8),
                      style: NeumorphicStyle(
                          intensity: 0.6,
                          boxShape: NeumorphicBoxShape.circle(),
                          color: K_BASE_COLOR,
                          shape: NeumorphicShape.flat,
                          depth: 8),
                      child: SonrIcon.gradient(
                          Icons.close, FlutterGradientNames.phoenixStart),
                      onPressed: () {
                        Get.offNamed("/home/profile");
                      },
                    ),
                  ),
                  // @ More Button
                  Padding(
                    padding: EdgeInsets.only(right: 4.0),
                    child: NeumorphicButton(
                      padding: EdgeInsets.all(8),
                      style: NeumorphicStyle(
                          intensity: 0.6,
                          boxShape: NeumorphicBoxShape.circle(),
                          color: K_BASE_COLOR,
                          shape: NeumorphicShape.flat,
                          depth: 8),
                      child: SonrIcon.gradient(Icons.more_horiz_outlined,
                          FlutterGradientNames.northMiracle),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            ),

            SliverPadding(padding: EdgeInsets.all(14)),

            // @ Builds List of Social Tile
            SliverStaggeredGrid(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return SocialTileItem(controller.socials[index], index);
                }),
                gridDelegate:
                    SliverStaggeredGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        staggeredTileCount: count,
                        staggeredTileBuilder: (index) {
                          // Retreive Data
                          var data = controller.socials[index];

                          // Feed Occupies 1 Whole Row/ 3 Columns
                          if (data.type == Contact_SocialTile_TileType.Feed) {
                            return StaggeredTile.count(4, 4);
                          }
                          // Showcase Occupies 0.5 Whole Rows/ 2 Columns
                          else if (data.type ==
                              Contact_SocialTile_TileType.Showcase) {
                            return StaggeredTile.count(2, 2);
                          }
                          // Icon can by 1/1
                          else {
                            return StaggeredTile.count(1, 1);
                          }
                        })),
          ],
        ),
      );
    });
  }
}
