import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import 'icon.dart';

// ^ Sonr Global AppBar Data ^ //
// ignore: non_constant_identifier_names
NeumorphicAppBar SonrAppBar(
  String title,
) {
  if (title == "") {}
  return NeumorphicAppBar(
      title: Center(
          child: NeumorphicText(title,
              style: NeumorphicStyle(
                depth: 2, //customize depth here
                color: Colors.white, //customize color here
              ),
              textStyle: NeumorphicTextStyle(
                fontFamily: "Raleway",
                fontWeight: FontWeight.w400,
                fontSize: 28,
              ),
              textAlign: TextAlign.center)),
      leading: null);
}

// ignore: non_constant_identifier_names
NeumorphicAppBar SonrHomeBar(
  Function onPressed,
) {
  return NeumorphicAppBar(
      title: Center(
          child: NeumorphicText("Home",
              style: NeumorphicStyle(
                depth: 2, //customize depth here
                color: Colors.white, //customize color here
              ),
              textStyle: NeumorphicTextStyle(
                fontFamily: "Raleway",
                fontWeight: FontWeight.w400,
                fontSize: 28,
              ),
              textAlign: TextAlign.center)),
      leading: Align(
          alignment: Alignment.centerLeft,
          child: NeumorphicButton(
            padding: EdgeInsets.all(18),
            style: NeumorphicStyle(
                intensity: 0.85,
                boxShape: NeumorphicBoxShape.circle(),
                shape: NeumorphicShape.convex,
                depth: 8),
            child: SonrIcon("049-edit.svg"),
            onPressed: onPressed,
          )));
}

// ^ Utilized in Transfer/Settings/Profile Screens ^ //
// ignore: non_constant_identifier_names
NeumorphicAppBar SonrExitAppBar(
  BuildContext context,
  String exitLocation, {
  String title: "",
}) {
  // Create App Bar
  return NeumorphicAppBar(
      title: Center(child: Text(title)),
      leading: Align(
          alignment: Alignment.centerLeft,
          child: NeumorphicButton(
            padding: EdgeInsets.all(18),
            style: NeumorphicStyle(
                intensity: 0.85,
                boxShape: NeumorphicBoxShape.circle(),
                shape: NeumorphicShape.flat,
                depth: 8),
            child: Icon(
              Icons.close,
              color: Colors.black87,
            ),
            onPressed: () {
              Get.offAllNamed(exitLocation);
            },
          )));
}
