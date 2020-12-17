
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/theme/neumorphic.dart';
import 'package:sonar_app/theme/util.dart';
import 'package:sonar_app/service/device_service.dart';
import 'package:sonr_core/sonr_core.dart';

part 'form_view.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SonrAppBar("Sonr"),
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0), child: FormView())
        ]));
  }
}
