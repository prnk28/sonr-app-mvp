import 'dart:io';

import 'package:get/get.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

class IncomingFileSheet extends StatelessWidget {
  final List<SharedMediaFile> sharedFiles;
  const IncomingFileSheet(this.sharedFiles);

  @override
  Widget build(BuildContext context) {
    // Set Window Properties
    final double windowWidth = Get.width;
    final double windowHeight = Get.height / 3 + 150;
    final double previewWidth = windowWidth - 20;
    final double previewHeight = windowHeight - 50;

    // Set Shared File
    File file = sharedFiles.length > 1
        ? File(sharedFiles.last.path)
        : File(sharedFiles.first.path);

    // Build View
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
      width: windowWidth,
      height: windowHeight,
      child: NeumorphicBackground(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // @ Confirm Button
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            // Bottom Left Close/Cancel Button
            SonrButton.close(() {
              Get.back();
            }),
            SonrText.header("Share", size: 36),
            // Bottom Right Confirm Button
            SonrButton.accept(() {
              Get.find<SonrService>().queue(Payload_Type.FILE, file: file);
            }),
          ]),

          // @ Preview of Image
          Expanded(
            child: Container(
              alignment: Alignment.center,
              width: previewWidth,
              height: previewHeight,
              child: FittedBox(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 1,
                        minHeight: 1,
                      ),
                      child: Image.file(file))),
            ),
          ),
        ]),
      ),
    );
  }
}
