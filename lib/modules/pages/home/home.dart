import 'dart:io';

import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sonar_app/modules/widgets/design/neumorphic.dart';
import 'package:sonar_app/service/card_service.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonr_core/sonr_core.dart';

part 'floater.dart';

class HomeScreen extends StatelessWidget {
  final double itemHeight = (Get.height - kToolbarHeight - 24) / 4;
  final double itemWidth = Get.width / 4;
  final CardService cards = Get.find();
  @override
  Widget build(BuildContext context) {
    // Build View
    return SonrTheme(Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        appBar: SonrAppBar("Home"),
        floatingActionButton: FloaterButton(() {}),
        body: Obx(() {
          return ListView.builder(
            itemCount: cards.allFiles.length,
            itemBuilder: (context, current) {
              // Get Current Metadata
              Metadata metadata = cards.allFiles[current];

              // Generate Cell
              return GestureDetector(
                  onTap: () async {
                    // TODO Utilize Hero Animation
                    // cards.getFile(metadata);
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
