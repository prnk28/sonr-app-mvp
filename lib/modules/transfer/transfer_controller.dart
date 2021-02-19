import 'dart:math';

import 'package:flutter_compass/flutter_compass.dart';
import 'package:get/get.dart';
import 'package:sonr_app/modules/transfer/peer_widget.dart';
import 'package:sonr_app/service/sonr_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

enum LobbyState {
  Empty,
  Active,
  Busy,
}

class TransferController extends GetxController {
  // @ Properties
  final Rx<Gradient> gradient = FlutterGradients.findByName(FlutterGradientNames.octoberSilence, type: GradientType.linear).obs;
  final inactiveGradient = FlutterGradients.findByName(FlutterGradientNames.octoberSilence, type: GradientType.linear);
  final activeGradient = FlutterGradients.findByName(FlutterGradientNames.summerGames, type: GradientType.linear);

  // @ Direction Properties
  final direction = 0.0.obs;
  final angle = 0.0.obs;
  final degrees = 0.0.obs;

  // @ String Properties
  final string = "".obs;
  final heading = "".obs;

  // @ Lobby Properties
  final stackItems = <PeerBubble>[].obs;

  // ^ Controller Constructer ^
  TransferController() {
    // @ Update Direction
    FlutterCompass.events.listen((dir) {
      var newDir = dir.headingForCameraMode;
      // Update String Elements
      if ((direction.value - newDir).abs() > 6) {
        string(_directionString(newDir));
        heading(_headingString(newDir));
      }

      // Reference
      direction(newDir);
      angle(((newDir ?? 0) * (pi / 180) * -1));

      // Calculate Degrees
      if (newDir + 90 > 360) {
        degrees(newDir - 270);
      } else {
        degrees(newDir + 90);
      }
    });

    // @ Check Peers Length
    Get.find<SonrService>().peers.listen((lob) {
      if (lob.length > 0) {
        gradient(activeGradient);
      } else {
        gradient(inactiveGradient);
      }
    });
  }

  // ^ Create Peer Item from Data ^ //
  addPeer(String id, Peer peer) {
    // Create Bubble Validate not Duplicate
    if (!stackItems.any((pb) => pb.controller.peer.id == id)) {
      // Add to Stack Items
      stackItems.add(PeerBubble(peer, stackItems.length - 1));
      stackItems.refresh();
    }
    stackItems.refresh();
  }

  // ^ Remove Peer Item from ID ^ //
  removePeer(String id) {
    // Find Bubble
    PeerBubble bubble = stackItems.firstWhere(
      (pb) => pb.controller.peer.id == id,
      orElse: () {
        return null;
      },
    );

    // Update Stack
    if (bubble != null) {
      stackItems.remove(bubble);
      stackItems.refresh();
    }
  }

  // ^ Retreives Direction String ^ //
  _directionString(double dir) {
    // Calculated
    var adjustedDegrees = dir.round();
    final unit = "°";

    // @ Convert To String
    if (adjustedDegrees >= 0 && adjustedDegrees <= 9) {
      return "0" + "0" + adjustedDegrees.toString() + unit;
    } else if (adjustedDegrees > 9 && adjustedDegrees <= 99) {
      return "0" + adjustedDegrees.toString() + unit;
    } else {
      return adjustedDegrees.toString() + unit;
    }
  }

  // ^ Retreives Heading String ^ //
  _headingString(double dir) {
    var adjustedDesignation = ((dir / 22.5) + 0.5).toInt();
    var compassEnum = Position_Heading.values[(adjustedDesignation % 16)];
    return compassEnum.toString().substring(compassEnum.toString().indexOf('.') + 1);
  }
}
