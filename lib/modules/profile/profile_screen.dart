import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonar_app/service/sonr_service.dart';

class ProfileScreen extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    SonrService sonr = Get.find();
    return SonrTheme(Scaffold(
        appBar: SonrExitAppBar(
          context,
          "/home",
          title: sonr.code.value,
        ),
        backgroundColor: NeumorphicTheme.baseColor(context),
        floatingActionButton: NeumorphicFloatingActionButton(
            child: Icon(Icons.edit),
            onPressed: () {
              controller.toggleEditing();
            }),
        body: SafeArea(
            child: Stack(
          children: <Widget>[],
        ))));
  }
}
