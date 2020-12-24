import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/theme/theme.dart';
import 'profile_controller.dart';

const double _K_CONTAINER_HEIGHT = 285;
const double _K_TITLE_FONT_SIZE = 24;

class ContactHeader extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      titlePadding: EdgeInsets.only(bottom: 24),
      title: _buildTitle(),
      centerTitle: true,
      background: SonrTheme(NeumorphicBackground(
        backendColor: Colors.transparent,
        child: ClipPath(
          clipper: OvalBottomBorderClipper(),
          child: Neumorphic(
            style: NeumorphicStyle(color: Colors.blue),
            child: Container(
              height: _K_CONTAINER_HEIGHT, // Same Header Color
              child: Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
      )),
    );
  }

  // ^ Builds Flexible SpaceBar Title ^ //
  _buildTitle() {
    return SonrText.normal(
        controller.firstName.value + " " + controller.lastName.value,
        color: HexColor.fromHex("FFFDFA"),
        size: _K_TITLE_FONT_SIZE);
  }
}

class _AvatarField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14.0),
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
    );
  }
}
