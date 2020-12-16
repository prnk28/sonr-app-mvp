import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonar_app/modules/widgets/design/neumorphic.dart';
import 'package:sonar_app/service/card_service.dart';
import 'package:flutter/widgets.dart';
import 'package:sonar_app/service/sonr_service.dart';

class CardPopup extends StatelessWidget {
  final SonrService receiveController = Get.find();
  final CardService fileController = Get.find();

  @override
  Widget build(BuildContext context) {
    fileController.saveFile(receiveController.file());
    return Dialog(
        shape: SonrWindowBorder(),
        insetAnimationDuration: Duration(seconds: 1),
        insetPadding: MediaQuery.of(context).viewInsets +
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 125.0),
        elevation: 45,
        child: Container(
            decoration: SonrWindowDecoration(context),
            child: Column(
              children: [
                // Some Space
                Padding(padding: EdgeInsets.all(15)),

                // Top Right Close/Cancel Button
                GestureDetector(
                  onTap: () {
                    // Shift to Detail Screen with Image
                    receiveController.finish();
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
                            child: Image.file(
                                File(receiveController.file.value.path)))),
                  ),
                ),
              ],
            )));
  }
}
