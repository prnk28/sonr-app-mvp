import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonar_app/modules/profile/social_view.dart';
import 'package:sonar_app/modules/profile/tile_controller.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'tile_dialog.dart';

// ** Builds Social Tile ** //
class SocialTile extends GetView<TileController> {
  final Contact_SocialTile data;
  final int index;
  SocialTile(this.data, this.index);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TileController>(
        id: "SocialTile",
        builder: (_) {
          // @ Determine State
          bool isEditing = (controller.state == TileState.Editing &&
              controller.currentTile == data);

          // @ Build View
          return GestureDetector(
              onLongPress: () async {
                controller.toggleEditing(data);
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
                    child: SocialView.fromTile(data),
                  )));
        });
  }
}

// ** Builds Edit Tile ** //
class EditTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
        onPressed: () {
          Get.dialog(TileDialog(), barrierColor: K_DIALOG_COLOR);
        },
        margin: EdgeInsets.all(4),
        style: NeumorphicStyle(
            intensity: 0.45, depth: 8, shape: NeumorphicShape.convex),
        child: SonrIcon.gradient(Icons.add, FlutterGradientNames.morpheusDen));
  }
}
