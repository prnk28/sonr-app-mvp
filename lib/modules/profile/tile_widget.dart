import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonar_app/modules/profile/tile_controller.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'tile_dialog.dart';
import 'profile_controller.dart';

// ** Builds Social Tile ** //
class SocialTile extends GetView<TileController> {
  final Contact_SocialTile data;
  SocialTile(this.data) {}
  @override
  Widget build(BuildContext context) {
    // Initialize
    controller.setTile(data);

    return Obx(() {
      // @ Determine State
      Widget view;
      bool isViewing = (controller.state.value != TileState.Editing);

      // @ Create View
      switch (data.type) {
        case Contact_SocialTile_TileType.Icon:
          view = _buildIconView(isViewing);
          break;
        case Contact_SocialTile_TileType.Showcase:
          view = _buildShowcaseView(isViewing);
          break;
        case Contact_SocialTile_TileType.Feed:
          view = _buildFeedView(isViewing);
          break;
      }

      // @ Build View
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
    });
  }

  Widget _buildIconView(bool isViewing) {
    if (isViewing) {
      return Center(
          child: SonrIcon.socialFromProvider(IconType.Gradient, data.provider));
    } else {
      return Center(
          child:
              SonrIcon.gradient(Icons.edit, FlutterGradientNames.alchemistLab));
    }
  }

  // ^ Create Showcase View based on Data ^ //
  Widget _buildShowcaseView(bool isViewing) {
    if (isViewing) {
      return Text("Showcase View TODO");
    } else {
      return Text("Showcase View Editing TODO");
    }
  }

  // ^ Create Feed View based on Data ^ //
  Widget _buildFeedView(bool isViewing) {
    if (isViewing) {
      return Text("Feed View TODO");
    } else {
      return Text("Feed View Editing TODO");
    }
  }
}

// ** Builds Edit Tile ** //
class EditTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create View
    return NeumorphicButton(
      style: NeumorphicStyle(intensity: 0.85),
      child: SonrIcon.gradient(Icons.add, FlutterGradientNames.morpheusDen),
      onPressed: () {
        Get.dialog(TileDialog(), barrierColor: K_DIALOG_COLOR);
      },
    );
  }
}
