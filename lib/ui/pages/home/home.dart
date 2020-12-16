import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sonar_app/ui/ui.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:sonr_core/sonr_core.dart';

part 'widgets/floater.dart';

class HomeScreen extends GetView<ReceiveController> {
  final double itemHeight = (Get.height - kToolbarHeight - 24) / 4;
  final double itemWidth = Get.width / 4;
  final FileService files = Get.find();
  @override
  Widget build(BuildContext context) {
    // Build View
    return AppTheme(Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        appBar: titleAppBar("Home"),
        floatingActionButton: FloaterButton(() {}),
        body: Obx(() {
          return ListView.builder(
            itemCount: files.allFiles.length,
            itemBuilder: (context, current) {
              // Get Current Metadata
              Metadata metadata = files.allFiles[current];

              // Generate Cell
              return GestureDetector(
                  onTap: () async {
                    // Process data.
                    files.getFile(metadata);
                  },
                  child: Container(
                    height: 75,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(File(metadata.path)),
                            fit: BoxFit.cover)),
                    child:
                        // Image Info
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Text(metadata.name),
                          Text(metadata.mime.type.toString()),
                          Text("Owner: " + metadata.owner.firstName),
                        ]),
                  ));
            },
          );
        })));
  }
}
