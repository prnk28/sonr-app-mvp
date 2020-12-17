import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonar_app/data/card_model.dart';
import 'package:sonar_app/modules/card/card_controller.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonar_app/service/sql_service.dart';
import 'package:flutter/widgets.dart';
import 'package:sonar_app/service/sonr_service.dart';

class CardPopup extends GetView<CardController> {
  final SonrService receiveController = Get.find();
  final SQLService fileController = Get.find();

  CardPopup({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CardModel card = controller.fetchLastFileCard();
    return SonrTheme(Dialog(
        shape: SonrWindowBorder(),
        // insetAnimationDuration: Duration(seconds: 1),
        // insetPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 125.0),
        elevation: 45,
        child: Container(
            decoration: SonrWindowDecoration(),
            child: Column(
              children: [
                // Some Space
                Padding(padding: EdgeInsets.all(15)),

                // Top Right Close/Cancel Button
                GestureDetector(
                  onTap: () {
                    // Shift to Detail Screen with Image
                    receiveController.reset();
                    Get.back();
                  },
                  child: Expanded(
                    child: FittedBox(
                        alignment: Alignment.center,
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 1,
                              minHeight: 1,
                            ), // here
                            child: Image.file(File(card.meta.path)))),
                  ),
                ),
              ],
            ))));
  }
}
