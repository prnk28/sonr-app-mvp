import 'dart:io';

import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sonar_app/modules/card/card_controller.dart';
import 'package:sonar_app/modules/card/card_grid.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonr_core/sonr_core.dart';

part 'floater_button.dart';

class HomeScreen extends GetView<CardController> {
  @override
  Widget build(BuildContext context) {
    // Build View
    return SonrTheme(Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        appBar: SonrHomeBar(() {}),
        floatingActionButton: FloaterButton(),
        body: CardGrid()));
  }
}
