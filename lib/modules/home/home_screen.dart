import 'dart:io';

import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sonar_app/data/card_model.dart';
import 'package:sonar_app/modules/home/home_item.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonr_core/sonr_core.dart';
import 'home_controller.dart';

part 'floater_button.dart';

class HomeScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    // Build View
    controller.fetch();
    return SonrTheme(Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        appBar: SonrHomeBar(() {
          Get.offNamed("/profile");
        }),
        floatingActionButton: FloaterButton(),
        body: _HomeView()));
  }
}

class _HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<CardModel> cards = controller.allCards();
      return GridView.builder(
          padding: EdgeInsets.only(left: 4, right: 4, bottom: 20, top: 2),
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 4),
          itemBuilder: (context, idx) {
            // Generate File Cell
            return HomeCardItem(cards[idx]);
          });
    });
  }
}
