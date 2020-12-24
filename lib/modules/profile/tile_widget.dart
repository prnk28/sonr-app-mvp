import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonar_app/social/medium_data.dart';
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
    controller.getData(data); // Initial Data Fetch
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
              DragTarget<Contact_SocialTile>(
                builder: (context, candidateData, rejectedData) {
                  return Container();
                },
                // Only accept same tiles
                onWillAccept: (data) {
                  if (data.type == this.data.type) {
                    return true;
                  } else {
                    return false;
                  }
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
    // Initialize
    Widget socialChild;
    bool isEditing = (controller.state == TileState.Editing &&
        controller.currentTile.value == data);

    // Medium Data
    if (controller.fetchedData is MediumData) {
      socialChild = MediumView(data.type, data: controller.fetchedData);
    }

    // Theming View with Drag
    return Neumorphic(
      margin: EdgeInsets.all(4),
      style: isEditing
          ? NeumorphicStyle(
              intensity: 0.75, shape: NeumorphicShape.flat, depth: 15)
          : NeumorphicStyle(
              intensity: 0.75, shape: NeumorphicShape.convex, depth: 8),
      child: Container(
        width: isDragging ? 125 : Get.width,
        height: isDragging ? 125 : Get.height,
        child: isDragging ? Icon(Icons.drag_indicator) : socialChild,
      ),
    );
  }
}
