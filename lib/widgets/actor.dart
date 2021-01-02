import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:sonar_app/theme/theme.dart';

class RiveActor extends StatelessWidget {
  final double width;
  final double height;
  final Artboard artboard;
  const RiveActor(this.artboard, this.width, this.height);

  factory RiveActor.fromType(
      {@required ArtboardType type, double width = 55, double height = 55}) {
    final path = 'assets/animations/tile_preview.riv';
    final controller = Get.put(RiveActorController(path));
    return RiveActor(controller.getArtboard(type), width, height);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: 55,
      child: Center(child: Rive(artboard: artboard)),
    );
  }
}

enum ArtboardType {
  Camera,
  Gallery,
  Icon,
  Feed,
}

class RiveActorController extends GetxController {
  // References
  ByteData _riveFileData;
  final String path;

  RiveActorController(this.path);

  @override
  void onInit() {
    // Load the RiveFile from the binary data.
    rootBundle.load(path).then((data) async {
      if (data != null) {
        _riveFileData = data;
      }
    });
    super.onInit();
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
    return artboard;
  }
}
