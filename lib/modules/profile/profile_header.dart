import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/theme/theme.dart';
import 'profile_controller.dart';

class ProfileHeader extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        Diagonal(
          clipHeight: 150.0,
          child: Container(
            width: Get.width,
            height: 400.0,
            color: Colors.blue, // Same Header Color
          ),
        ),
        NeumorphicBackground(
          child: _buildActions(),
          backendColor: Colors.blue, // Same Header Color
        )
      ],
    );
  }

  _buildActions() {
    return SizedBox(
        height: 140,
        child: Padding(
            padding: EdgeInsets.only(top: 64),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // @ Exit Button
                  Padding(
                      padding: EdgeInsets.only(left: 14),
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
                            child: GradientIcon(
                                Icons.close, FlutterGradientNames.phoenixStart),
                            onPressed: () {
                              Get.offNamed("/home/profile");
                            },
                          ))),
                  Spacer(),

                  // @ Avatar / Name
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _AvatarField(),
                        Text(controller.userContact.value.firstName,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.white,
                            ))
                      ]),

                  // @ More Button
                  Spacer(),
                  Padding(
                      padding: EdgeInsets.only(right: 14),
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
