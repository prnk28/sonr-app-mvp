import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'profile_controller.dart';

const double _K_CONTAINER_HEIGHT = 285;

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
          print("Launch Text Dialog to Update Name");
          Get.dialog(EditDialog.textField("Name", "Enter your First Name", controller.firstName.value, text: "Text", onChanged: (val) {
            controller.firstName(val);
          }));
          HapticFeedback.heavyImpact();
        },
        child: SonrText.normal(controller.firstName.value + " " + controller.lastName.value,
            color: HexColor.fromHex("FFFDFA"), size: 24));
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
