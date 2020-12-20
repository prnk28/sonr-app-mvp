import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonar_app/modules/profile/profile_tiles.dart';
import 'profile_controller.dart';
import 'package:sonar_app/theme/theme.dart';
import 'profile_header.dart';

class ProfileScreen extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return SonrTheme(Scaffold(
        appBar: SonrExitAppBar(
          "/home-from-profile",
          title: controller.userContact.value.firstName +
              " " +
              controller.userContact.value.lastName,
        ),
        backgroundColor: NeumorphicTheme.baseColor(context),
        floatingActionButton: NeumorphicFloatingActionButton(
            child: GradientIcon(Icons.edit, FlutterGradientNames.bigMango),
            onPressed: () {
              controller.toggleEditing();
            }),
        body: Column(
          children: [
            ProfileHeader(),
            //ProfileTiles(),
          ],
        )));
  }
}
