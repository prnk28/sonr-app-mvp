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
    return Expanded(
        child: GridView.builder(
            padding: EdgeInsets.only(left: 4, right: 4, bottom: 20, top: 2),
            itemCount: 5,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, mainAxisSpacing: 8, crossAxisSpacing: 4),
            itemBuilder: (context, idx) {
              // Generate File Cell
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
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    normalText("Some Text"),
                    normalText("Some URL"),
                    normalText("Some Preview"),
                  ]),
            )));
  }
}
