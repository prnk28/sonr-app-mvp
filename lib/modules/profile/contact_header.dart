import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/theme/theme.dart';
import 'profile_controller.dart';

class ContactHeader extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        Diagonal(
          clipHeight: 120.0,
          child: Container(
            width: Get.width,
            height: 360.0,
            color: Colors.blue, // Same Header Color
          ),
        ),
        _buildActions(),
      ],
    );
  }

  _buildActions() {
    return SizedBox(
        height: 231,
        child: Container(
            color: Colors.blue, // Same Header Color
            padding: EdgeInsets.only(top: 64),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // @ Exit Button
                  Padding(
                    padding: EdgeInsets.only(left: 14),
                    child: Neumorphic(
                        drawSurfaceAboveChild: false,
                        child: Align(
                            alignment: Alignment.center,
                            child: NeumorphicButton(
                              padding: EdgeInsets.all(8),
                              style: NeumorphicStyle(
                                  color: Colors.grey[200],
                                  intensity: 0.6,
                                  boxShape: NeumorphicBoxShape.circle(),
                                  shape: NeumorphicShape.flat,
                                  depth: 8),
                              child: GradientIcon(Icons.close,
                                  FlutterGradientNames.phoenixStart),
                              onPressed: () {
                                Get.offNamed("/home/profile");
                              },
                            ))),
                  ),

                  // @ Avatar / Name
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Neumorphic(
                            drawSurfaceAboveChild: false,
                            child: _AvatarField()),
                        Text(controller.userContact.value.firstName,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.white,
                            ))
                      ]),

                  // @ More Button
                  Padding(
                    padding: EdgeInsets.only(right: 14),
                    child: Neumorphic(
                        drawSurfaceAboveChild: false,
                        child: Align(
                            alignment: Alignment.center,
                            child: NeumorphicButton(
                                padding: EdgeInsets.all(8),
                                style: NeumorphicStyle(
                                    color: Colors.grey[200],
                                    intensity: 0.6,
                                    boxShape: NeumorphicBoxShape.circle(),
                                    shape: NeumorphicShape.flat,
                                    depth: 8),
                                child: GradientIcon(Icons.more_horiz_outlined,
                                    FlutterGradientNames.northMiracle),
                                onPressed: () {}))),
                  ),
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
          depth: NeumorphicTheme.embossDepth(context),
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
