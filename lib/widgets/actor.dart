import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:sonar_app/theme/theme.dart';

class RiveActor extends GetView<RiveActorController> {
  final double width;
  final double height;
  final Artboard artboard;
  const RiveActor(this.artboard, this.width, this.height);

  factory RiveActor.fromType(
      {@required ArtboardType type, double width = 55, double height = 55}) {
    final controller = Get.find<RiveActorController>();
    return RiveActor(controller.getArtboard(type), width, height);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loaded.value) {
        return SizedBox(
          height: height,
          width: width,
          child: Center(child: Rive(artboard: artboard)),
        );
      } else {
        return Container();
      }
    });
  }
}

enum ArtboardType {
  Camera,
  Gallery,
  Contact,
  Feed,
}

class RiveActorController extends GetxController {
  // References
  ByteData _riveFileData;
  final String path;
  final loaded = false.obs;

  RiveActorController(this.path) {
    // Load the RiveFile from the binary data.
    rootBundle.load(path).then((data) async {
      if (data != null) {
        _riveFileData = data;
      }
    });
  }

  // ^ Gets Pre Initialized Artboard by Type ^ //
  Artboard getArtboard(ArtboardType type) {
    // @ Initialize File
    final riveFile = RiveFile();
    riveFile.import(_riveFileData);
    final artboard = riveFile.mainArtboard;

    // @ Add Controller
    if (type == ArtboardType.Camera) {
      artboard.addController(SimpleAnimation('Camera'));
    }
    // Retreive Showcase Loop
    else if (type == ArtboardType.Gallery) {
      artboard.addController(SimpleAnimation('Showcase'));
    }
    // Retreive Showcase Loop
    else if (type == ArtboardType.Feed) {
      artboard.addController(SimpleAnimation('Feed'));
    }
    // Retreive Icon Loop
    else {
      artboard.addController(SimpleAnimation('Icon'));
    }

    // @ Return Board
    loaded(true);
    return artboard;
  }
}
