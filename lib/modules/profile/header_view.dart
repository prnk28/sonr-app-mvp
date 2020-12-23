import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/theme/theme.dart';
import 'profile_controller.dart';

const double _K_CONTAINER_HEIGHT = 250;

class ContactHeader extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
        background: SonrTheme(NeumorphicBackground(
          backendColor: Colors.transparent,
          child: Stack(
            overflow: Overflow.visible,
            children: [
              ClipPath(
                clipper: DiagonalPathClipperOne(),
                child: Neumorphic(
                  style: NeumorphicStyle(color: Colors.blue),
                  child: Container(
                    height: _K_CONTAINER_HEIGHT, // Same Header Color
                  ),
                ),
              ),
              _buildView()
            ],
          ),
        )),
        title: Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: SonrText.normal(
              controller.firstName.value + " " + controller.lastName.value,
              color: Colors.white,
              size: 24),
        ),
        centerTitle: true);
  }

  _buildView() {
    return SizedBox(
        height: 250,
        child: Container(
            color: Colors.blue, // Same Header Color
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // @ Avatar
                  Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: _AvatarField(),
                    ),
                    Padding(padding: EdgeInsets.all(35))
                  ]),
                ])));
  }
}

class _AvatarField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
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
