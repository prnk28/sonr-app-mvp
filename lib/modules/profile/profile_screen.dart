import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_tiles.dart';
import 'profile_controller.dart';
import 'package:sonar_app/theme/theme.dart';
import 'profile_header.dart';

class ProfileScreen extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return SonrTheme(Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: _ProfileView()));
  }
}

class _ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Neumorphic(
        child: Column(
      children: [
        ProfileHeader(),
        Padding(padding: EdgeInsets.all(40)),
        ProfileTiles(),
      ],
    ));
  }
}
