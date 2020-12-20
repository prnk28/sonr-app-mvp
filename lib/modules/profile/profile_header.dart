import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/theme/theme.dart';
import 'profile_controller.dart';

class ProfileHeader extends GetView<ProfileController> {
  static final double containerHeight = 300.0;
  final double clipHeight = containerHeight * 0.35;
  final DiagonalPosition position = DiagonalPosition.BOTTOM_LEFT;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Diagonal(
          clipHeight: 150.0,
          child: Container(
            width: double.infinity,
            height: 400.0,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}
