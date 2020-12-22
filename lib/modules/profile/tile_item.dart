import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'add_tile_dialog.dart';
import 'profile_controller.dart';

// ** Builds Social Tile ** //
class SocialTile extends GetView<ProfileController> {
  final Contact_SocialTile data;
  SocialTile(this.data);
  @override
  Widget build(BuildContext context) {
    // Initialize
    Widget view;
    switch (data.type) {
      case Contact_SocialTile_TileType.Icon:
        view = Center(child: gradientIconFromSocialProvider(data.provider));
        break;
      case Contact_SocialTile_TileType.Showcase:
        view = _buildShowcaseView();
        break;
      case Contact_SocialTile_TileType.Feed:
        view = _buildFeedView();
        break;
    }

    // Create View
    return GestureDetector(
        onLongPress: () async {
          print("Long tapped jiggle");
        },
        child: Neumorphic(
            style: NeumorphicStyle(intensity: 0.85),
            margin: EdgeInsets.all(4),
            child: Container(
              child: view,
            )));
  }

  // ^ Create Showcase View based on Data ^ //
  Widget _buildShowcaseView() {
    return Text("Showcase View TODO");
  }

  // ^ Create Feed View based on Data ^ //
  Widget _buildFeedView() {
    return Text("Feed View TODO");
  }
}

// ** Builds Edit Tile ** //
class EditTile extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    // Create View
    return NeumorphicButton(
      style: NeumorphicStyle(intensity: 0.85),
      child: GradientIcon(Icons.add, FlutterGradientNames.morpheusDen),
      onPressed: () {
        Get.dialog(TileAddDialog(), barrierColor: K_DIALOG_COLOR);
      },
    );
  }
}
