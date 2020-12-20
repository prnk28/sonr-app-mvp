import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonar_app/theme/theme.dart';
import 'profile_controller.dart';

// ** Builds List of Social Tile ** //
class ProfileTiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: ListView.builder(
            itemCount: 6,
            itemBuilder: (context, idx) {
              return _SocialTile();
            }));
  }
}

// ** Builds Social Tile ** //
class _SocialTile extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onLongPress: () async {
          print("Long tapped jiggle");
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
