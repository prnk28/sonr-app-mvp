import 'dart:io';

import 'package:sonar_app/ui/ui.dart';
import 'package:flutter/widgets.dart';
import 'package:sonar_app/controller/controller.dart';

class CompletedPopup extends StatelessWidget {
  final ReceiveController receiveController = Get.find();
  final FileController fileController = Get.find();

  @override
  Widget build(BuildContext context) {
    fileController.saveMeta(receiveController.file());
    return Dialog(
        shape: windowBorder(),
        insetAnimationDuration: Duration(seconds: 1),
        insetPadding: MediaQuery.of(context).viewInsets +
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 125.0),
        elevation: 45,
        child: Container(
            decoration: windowDecoration(context),
            child: Column(
              children: [
                // Some Space
                Padding(padding: EdgeInsets.all(15)),

                // Top Right Close/Cancel Button
                GestureDetector(
                  onTap: () {
                    // Shift to Detail Screen with Image
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
