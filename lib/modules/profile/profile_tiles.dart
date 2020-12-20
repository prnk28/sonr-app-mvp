import 'package:get/get.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonar_app/theme/theme.dart';
import 'profile_controller.dart';

class ProfileTiles extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        itemCount: 6,
        padding: EdgeInsets.only(left: 4, right: 4, bottom: 20, top: 2),
        itemBuilder: (context, idx) {
          return _SocialTile();
        });
  }
}

class _SocialTile extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onLongPress: () async {
          print("Long tap begin jiggle");
        },
        child: Neumorphic(
            style: NeumorphicStyle(intensity: 0.85),
            margin: EdgeInsets.all(4),
            child: Container(
              height: 80,
              child:
                  // Image Info
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    normalText("Some Text"),
                    normalText("Some URL"),
                    normalText("Some Preview"),
                  ]),
            )));
  }
}
