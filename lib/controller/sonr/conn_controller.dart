import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:sonr_core/utils/olc.dart';
import 'package:get/get.dart' hide Node;

import '../controller.dart';

// ** Global Sonr Node ** //
Node sonrNode;

// ** Node Connection Controller ** //
class ConnController extends GetxController {
  // @ Set Properteris
  bool connected = false;

  ConnController() {
    FlutterCompass.events.listen((newDegrees) {
      // Get Current Direction and Update Cubit
      if (connected) {
        sonrNode.update(newDegrees.headingForCameraMode);
      }
    });
  }

  // ^ Connect Node Method ^ //
  void connect(Position pos, Contact contact) async {
    // Get OLC
    var olcCode = OLC.encode(pos.latitude, pos.longitude, codeLength: 8);

    // Await Initialization
    sonrNode = await SonrCore.initialize(
      olcCode,
      "@Temp_Username",
      contact,
    );
    connected = true;

    // Get Controllers
    LobbyController lobby = Get.find();
    ReceiveController receive = Get.find();
    TransferController transfer = Get.find();

    // Assign Node Callbacks
    lobby.assign();
    receive.assign();
    transfer.assign();
    sonrNode.assignCallback(CallbackEvent.Error, _handleSonrError);
  }

  // ^ An Error Has Occurred ^ //
  void _handleSonrError(dynamic data) async {
    if (data is ErrorMessage) {
      print(data.method + "() - " + data.message);
    }
  }
}
