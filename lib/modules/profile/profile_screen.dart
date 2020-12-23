import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:sonr_core/models/models.dart';
import 'tile_widget.dart';
import 'profile_controller.dart';
import 'package:sonar_app/theme/theme.dart';
import 'header_view.dart';

class ProfileScreen extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    // Build View
    return SonrTheme(Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: _ProfileView()));
  }
}

class _ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    // Create View
    return SonrTheme(NeumorphicBackground(
        child: Column(
      children: [
        // @ Builds Profile Header
        ContactHeader(),

        // @ Builds List of Social Tile
        Expanded(
          child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Obx(() {
                controller.fetch();
                int count = controller.tiles.length + 1;

                // Build Staggered Grid View
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 4,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  itemCount: count,
                  itemBuilder: (BuildContext context, int index) {
                    // Return Edit Button
                    if (index == count - 1) {
                      return EditTile();
                    }

                    // Return Social Tile
                    else {
                      return SocialTile(controller.tiles[index]);
                    }
                  },
                  staggeredTileBuilder: (int index) {
                    // @ Validate Socials
                    if (count > 1) {
                      // Feed Occupies 1 Whole Row/ 3 Columns
                      if (controller.tiles[index].type ==
                          Contact_SocialTile_TileType.Feed) {
                        return StaggeredTile.count(4, 4);
                      }
                      // Showcase Occupies 0.5 Whole Rows/ 2 Columns
                      else if (controller.tiles[index].type ==
                          Contact_SocialTile_TileType.Showcase) {
                        return StaggeredTile.count(2, 2);
                      }
                      // Icon can by 1/1
                      else {
                        return StaggeredTile.count(1, 1);
                      }
                    }
                    // @ No Socials
                    else {
                      return StaggeredTile.count(1, 1);
                    }
                  },
                );
              })),
        )
      ],
    )));
  }
}
