import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonar_app/data/medium_model.dart';
import 'package:sonar_app/modules/profile/tile_view.dart';
import 'package:sonar_app/modules/profile/tile_controller.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

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
            // Build View
            return Stack(children: [
              Draggable(
                  feedback: _buildView(isDragging: true),
                  child: _buildView(),
                  data: data,
                  childWhenDragging: Container(),
                  onDragStarted: () {
                    HapticFeedback.heavyImpact();
                    controller.state = TileState.Dragging;
                    controller.update(["SocialTile"]);
                  }),
              DragTarget(
                builder: (context, candidateData, rejectedData) {
                  return Container();
                },
                // Only accept same tiles
                onWillAccept: (data) {
                  return true;
                },
                // Switch Index Positions with animation
                onAccept: (data) {
                  print(data);
                },
              ),
            ]);
          }
        });
  }

  // ^ Builds Data for Corresponding Model ^ //
  Widget _buildView({bool isDragging = false}) {
    // Determine State
    bool isEditing = (controller.state == TileState.Editing &&
        controller.currentTile.value == data);

    Widget child;
    // Medium Data
    if (controller.fetchedData is MediumFeedModel) {
      child = MediumView(data.type, data: controller.fetchedData);
    }

    // Theming View
    return Neumorphic(
      margin: EdgeInsets.all(4),
      style: isEditing
          ? NeumorphicStyle(
              intensity: 0.75, shape: NeumorphicShape.flat, depth: 15)
          : NeumorphicStyle(
              intensity: 0.75, shape: NeumorphicShape.convex, depth: 8),
      child: Container(
        width: isDragging ? 200 : Get.width,
        height: isDragging ? 200 : Get.height,
        child: isDragging ? Icon(Icons.drag_indicator) : child,
      ),
    );
  }
}
