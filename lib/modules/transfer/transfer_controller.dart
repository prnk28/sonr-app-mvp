import 'dart:math';

import 'package:get/get.dart';
import 'package:sonar_app/modules/transfer/peer_widget.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

// ** Compass Designation Enum **
enum CompassHeading {
  N,
  NNE,
  NE,
  ENE,
  E,
  ESE,
  SE,
  SSE,
  S,
  SSW,
  SW,
  WSW,
  W,
  WNW,
  NW,
  NNW
}

enum LobbyState {
  Empty,
  Active,
  Busy,
}

class TransferController extends GetxController {
  // @ Properties
  final Rx<Gradient> gradient = FlutterGradients.findByName(
          FlutterGradientNames.octoberSilence,
          type: GradientType.linear)
      .obs;

  // @ References
  final inactiveGradient = FlutterGradients.findByName(
      FlutterGradientNames.octoberSilence,
      type: GradientType.linear);

  final activeGradient = FlutterGradients.findByName(
      FlutterGradientNames.summerGames,
      type: GradientType.linear);

  // @ Direction Properties
  final direction = 0.0.obs;
  final angle = 0.0.obs;
  final degrees = 0.0.obs;

  // @ String Properties
  final string = "".obs;
  final heading = "".obs;

  // @ Lobby Properties
  final isEmpty = true.obs;
  bool _isEmpty = true;
  RxList<PeerBubble> stackItems = new List<PeerBubble>().obs;

  // ^ Controller Constructer ^
  TransferController() {
    // @ Update Direction
    Get.find<SonrService>().direction.listen((newDir) {
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
    Get.find<SonrService>().lobby.listen((lob) {
      if (lob.length > 0) {
        gradient(activeGradient);
      } else {
        gradient(inactiveGradient);
      }
    });
  }

  // ^ Create Peer Item from Data ^ //
  addPeerBubble(String id, Peer peer) {
    // @ Update State if already unchecked
    if (_isEmpty) {
      isEmpty(_isEmpty = false);
    }

    // @ Create Bubbles
    // Validate not Duplicate
    if (!stackItems.any((pb) => pb.controller.peer.id == id)) {
      stackItems.add(PeerBubble(peer, stackItems.length - 1));
      stackItems.refresh();
      //print("Added Bubble");
    }
    //print("Total Bubbbles = " + stackItems.length.toString());
    stackItems.refresh();
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
    var compassEnum = CompassHeading.values[(adjustedDesignation % 16)];
    return compassEnum
        .toString()
        .substring(compassEnum.toString().indexOf('.') + 1);
  }
}
