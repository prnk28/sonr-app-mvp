import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonar_app/modules/social/medium_view.dart';
import 'package:sonar_app/modules/profile/tile_controller.dart';
import 'package:sonar_app/modules/social/twitter_view.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

// ** Builds Social Tile ** //
class SocialTileItem extends GetWidget<TileController> {
  final Contact_SocialTile item;
  final int index;
  SocialTileItem(this.item, this.index) {
    controller.setTile(item);
  }
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      LongPressDraggable(
          feedback: _buildView(controller.state.value == TileState.Editing,
              isDragging: true),
          child: _buildView(controller.state.value == TileState.Editing),
          data: item,
          childWhenDragging: Container(),
          onDragStarted: () {
            HapticFeedback.heavyImpact();
            controller.state(TileState.Dragging);
          }),
      DragTarget<Contact_SocialTile>(
        builder: (context, candidateData, rejectedData) {
          return Container();
        },
        // Only accept same tiles
        onWillAccept: (data) {
          if (data.type == this.item.type) {
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

  // ^ Builds Neumorohic Item ^ //
  Widget _buildView(bool isEditing, {bool isDragging = false}) {
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
        child: isDragging ? Icon(Icons.drag_indicator) : _setSocialView(),
      ),
    );
  }

  // ^ Builds Corresponding SocialView ^ //
  Widget _setSocialView() {
    // Medium Data
    if (item.provider == Contact_SocialTile_Provider.Medium) {
      return MediumView(item);
    }
    // Twitter Data
    else if (item.provider == Contact_SocialTile_Provider.Twitter) {
      return TwitterView(item);
    }
    return Container();
  }
}