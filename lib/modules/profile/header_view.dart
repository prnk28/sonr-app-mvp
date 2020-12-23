import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/theme/theme.dart';
import 'profile_controller.dart';

class ContactHeader extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
        background: SonrTheme(NeumorphicBackground(
          backendColor: Colors.transparent,
          child: Stack(
            overflow: Overflow.visible,
            children: [
              Diagonal(
                clipHeight: 75.0,
                child: Neumorphic(
                  child: Container(
                    width: Get.width,
                    height: 350.0,
                    color: Colors.blue, // Same Header Color
                  ),
                ),
              ),
              _buildView()
            ],
          ),
        )),
        title:  SonrText.normal(
            controller.firstName.value + " " + controller.lastName.value,
            size: 18),
        centerTitle: true);
  }

  _buildView() {
    return SizedBox(
        height: 250,
        child: Container(
            color: Colors.blue, // Same Header Color
            padding: EdgeInsets.only(top: 64),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              // @ Avatar
              Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: _AvatarField(),
                )
              ]),
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
          depth: -10,
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
