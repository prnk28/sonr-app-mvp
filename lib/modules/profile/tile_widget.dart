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
    return Obx(() {
      // @ Determine State
      bool isViewing = (controller.state.value != TileState.Editing);

      // @ Build View
      return GestureDetector(
          onLongPress: () async {
            controller.toggleEditing(data);
          },
          child: Obx(() => NeumorphicButton(
              style: isViewing
                  ? NeumorphicStyle(
                      intensity: 0.45, shape: NeumorphicShape.convex, depth: 8)
                  : NeumorphicStyle(
                      intensity: 0.85, shape: NeumorphicShape.flat, depth: 15),
              margin: EdgeInsets.all(4),
              child: Container(
                child: SocialView.fromTile(data),
              ))));
    });
  }
}

// ** Builds Edit Tile ** //
class EditTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create View
    return NeumorphicButton(
      margin: EdgeInsets.all(4),
      style: NeumorphicStyle(
          intensity: 0.45, depth: 8, shape: NeumorphicShape.convex),
      child: SonrIcon.gradient(Icons.add, FlutterGradientNames.morpheusDen),
      onPressed: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.dialog(TileDialog(), barrierColor: K_DIALOG_COLOR);
        });
      },
    );
  }
}
