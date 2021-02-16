import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:sonr_core/models/models.dart' hide Platform;
import 'edit_dialog.dart';
import 'social_tile.dart';
import 'profile_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import 'tile_stepper.dart';

class ProfileScreen extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    // Build View
    return SonrScaffold(
        floatingActionButton: NeumorphicFloatingActionButton(
            child: SonrIcon.gradient(Icons.add, FlutterGradientNames.morpheusDen),
            style: NeumorphicStyle(intensity: 0.85, depth: 10, shape: NeumorphicShape.convex),
            onPressed: () {
              SonrDialog.large(TileCreateStepper());
            }),
        body: NeumorphicBackground(
            backendColor: Colors.transparent,
            child: CustomScrollView(
              slivers: [
                // @ Builds Profile Header
                SonrHeaderBar.sliver(
                    leading: SonrButton.circle(
                        icon: SonrIcon.close,
                        onPressed: () => Get.offNamed("/home/profile"),
                        intensity: 0.85,
                        shadowLightColor: Colors.lightBlueAccent[100]),
                    action: SonrButton.circle(
                      icon: SonrIcon.more,
                      onPressed: () => {},
                      intensity: 0.85,
                      shadowLightColor: Colors.lightBlueAccent[100],
                    ),
                    flexibleSpace: ContactHeader()),

                SliverPadding(padding: EdgeInsets.all(14)),

                // @ Builds List of Social Tile
                Obx(() => SocialsGrid(controller.socials, controller.focusTileIndex.value)),
              ],
            )));
  }
}

class SocialsGrid extends StatelessWidget {
  final List<Contact_SocialTile> tiles;
  final int focusedIndex;

  SocialsGrid(
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

class ContactHeader extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      titlePadding: EdgeInsets.only(bottom: 24),
      title: _buildTitle(),
      centerTitle: true,
      background: NeumorphicBackground(
        backendColor: Colors.transparent,
        child: ClipPath(
          clipper: OvalBottomBorderClipper(),
          child: Neumorphic(
            style: NeumorphicStyle(color: Colors.lightBlue[100]),
            child: GestureDetector(
              onLongPress: () async {
                print("Launch Color picker to change header");
                HapticFeedback.heavyImpact();
              },
              child: Container(
                height: 285, // Same Header Color
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // @ Avatar
                    _AvatarField(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ^ Builds Flexible SpaceBar Title ^ //
  _buildTitle() {
    return GestureDetector(
        onLongPress: () async {
          SonrDialog.small(
            EditDialog.nameField(
                onSubmitted: (map) {
                  controller.firstName(map["firstName"]);
                  controller.lastName(map["lastName"]);
                  controller.saveChanges();
                },
                firstValue: controller.firstName.value,
                lastValue: controller.lastName.value),
          );
          HapticFeedback.heavyImpact();
        },
        child:
            Obx(() => SonrText.normal(controller.firstName.value + " " + controller.lastName.value, color: SonrColor.fromHex("FFFDFA"), size: 24)));
  }
}

class _AvatarField extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        print("Launch Profile Pic Camera View");
        HapticFeedback.heavyImpact();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Neumorphic(
          padding: EdgeInsets.all(10),
          style: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.circle(),
            depth: -10,
          ),
          child: Icon(
            Icons.insert_emoticon,
            size: 120,
            color: Colors.black.withOpacity(0.2),
          ),
        ),
      ),
    );
  }
}
