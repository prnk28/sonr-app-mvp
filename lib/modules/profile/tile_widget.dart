import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonar_app/data/medium_model.dart';
import 'package:sonar_app/modules/profile/tile_view.dart';
import 'package:sonar_app/modules/profile/tile_controller.dart';
import 'package:sonar_app/service/social_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:vibration/vibration.dart';
import 'package:sonr_core/sonr_core.dart';
import 'tile_dialog.dart';

// ** Builds Social Tile ** //
class SocialTile extends GetView<TileController> {
  final Contact_SocialTile data;
  final int index;
  SocialTile(this.data, this.index);
  @override
  Widget build(BuildContext context) {
    controller.fetchData(data); // Initial Data Fetch
    return GetBuilder<TileController>(
        id: "SocialTile",
        builder: (_) {
          // @ Check If Data Loaded
          if (controller.state == TileState.Loading) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blueAccent)));
          }
          // @ Other States
          else {
            // Determine State
            bool isEditing = (controller.state == TileState.Editing &&
                controller.currentTile.value == data);

            // Build View
            return GestureDetector(
                onLongPress: () async {
                  controller.toggleEditing(data);
                  HapticFeedback.heavyImpact();
                },
                child: Neumorphic(
                    margin: EdgeInsets.all(4),
                    style: isEditing
                        ? NeumorphicStyle(
                            intensity: 0.75,
                            shape: NeumorphicShape.flat,
                            depth: 15)
                        : NeumorphicStyle(
                            intensity: 0.75,
                            shape: NeumorphicShape.convex,
                            depth: 8),
                    child: Container(
                      child: _buildView(),
                    )));
          }
        });
  }

  // ^ Builds Data for Corresponding Model ^ //
  Widget _buildView() {
    // Medium Data
    if (controller.fetchedData is MediumFeedModel) {
      return MediumView(data.type, data: controller.fetchedData);
    }
    return Container();
  }
}
