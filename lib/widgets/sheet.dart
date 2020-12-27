import 'dart:io';

import 'package:get/get.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sonar_app/theme/theme.dart';

class IncomingFileSheet extends StatelessWidget {
  final List<SharedMediaFile> sharedFiles;
  const IncomingFileSheet(this.sharedFiles);

  @override
  Widget build(BuildContext context) {
    return NeumorphicBackground(
      child: Container(
        width: Get.width,
        height: Get.height / 3,
        child: Column(children: [
          // @ Top Right Close/Cancel Button
          SonrButton.close(() {
            // Pop Window
            Get.back();
          }, padTop: 8, padRight: 8),

          // Media Link
          Center(
              child:
                  Container(child: Image.file(File(sharedFiles.first.path)))),

          // Confirm Button
        ]),
      ),
    );
  }
}
