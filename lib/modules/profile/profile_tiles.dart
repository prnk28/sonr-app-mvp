import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'add_dialog.dart';
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
        view = _buildIconView();
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

  // ^ Create Icon View based on Data ^ //
  Widget _buildIconView() {
    Widget w;
    switch (data.provider) {
      case Contact_SocialTile_Provider.Facebook:
        w = GradientIcon(
            Boxicons.bxl_facebook_square, FlutterGradientNames.perfectBlue);
        break;
      case Contact_SocialTile_Provider.Instagram:
        w = GradientIcon(
            Boxicons.bxl_instagram, FlutterGradientNames.ripeMalinka);
        break;
      case Contact_SocialTile_Provider.Medium:
        w = GradientIcon(
            Boxicons.bxl_medium, FlutterGradientNames.mountainRock);
        break;
      case Contact_SocialTile_Provider.Spotify:
        w = GradientIcon(Boxicons.bxl_spotify, FlutterGradientNames.newLife);
        break;
      case Contact_SocialTile_Provider.TikTok:
        w = GradientIcon(Boxicons.bxl_creative_commons,
            FlutterGradientNames.premiumDark); // TODO
        break;
      case Contact_SocialTile_Provider.Twitter:
        w = GradientIcon(Boxicons.bxl_twitter, FlutterGradientNames.partyBliss);
        break;
      case Contact_SocialTile_Provider.YouTube:
        w = GradientIcon(Boxicons.bxl_youtube, FlutterGradientNames.loveKiss);
        break;
    }
    return Container(
      child: Center(child: w),
    );
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
        Get.dialog(AddDialog());
      },
    );
  }
}
