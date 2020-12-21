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
            height: 450.0,
            color: Colors.blue,
          ),
        ),
        _buildActions()
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
                                intensity: 0.6,
                                boxShape: NeumorphicBoxShape.circle(),
                                shape: NeumorphicShape.flat,
                                depth: 8),
                            child: GradientIcon(
                                Icons.close, FlutterGradientNames.phoenixStart),
                            onPressed: () {
                              Get.offAllNamed("/home/profile");
                            },
                          ))),
                  Spacer(),

                  // @ Text Widget
                  Center(
                      child: Text(controller.userContact.value.firstName,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            color: Colors.white,
                          ))),

                  // @ Edit Button
                  Spacer(),
                  Padding(
                      padding: EdgeInsets.only(right: 14),
                      child: Align(
                          alignment: Alignment.center,
                          child: NeumorphicButton(
                              padding: EdgeInsets.all(8),
                              style: NeumorphicStyle(
                                  intensity: 0.6,
                                  boxShape: NeumorphicBoxShape.circle(),
                                  shape: NeumorphicShape.flat,
                                  depth: 8),
                              child: GradientIcon(
                                  Icons.edit, FlutterGradientNames.bigMango),
                              onPressed: () {
                                controller.toggleEditing();
                              }))),
                ])));
  }
}
