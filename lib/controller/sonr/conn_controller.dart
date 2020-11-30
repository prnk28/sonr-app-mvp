import 'dart:io';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sonar_app/model/model.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:sonr_core/utils/olc.dart';
import 'package:get/get.dart' hide Node;

import 'sonr.dart';

class ConnController extends GetxController {
  // @ Set Properteris
  Node node;
  bool connected = false;

  ConnController() {
    FlutterCompass.events.listen((newDegrees) {
      // Get Current Direction and Update Cubit
      if (connected) {
        node.update(newDegrees.headingForCameraMode);
      }
    });
  }

  // ^ Connect Node Method ^ //
  void connect(Position pos, Contact con) async {
    // Get OLC
    var olcCode = OLC.encode(pos.latitude, pos.longitude, codeLength: 8);

    // Await Initialization
    node = await SonrCore.initialize(olcCode, con, logging: false);

    // Assign Node Callbacks
    node.assignCallback(CallbackEvent.Refreshed, _handleRefreshed);
    node.assignCallback(CallbackEvent.Queued, _handleQueued);
    node.assignCallback(CallbackEvent.Invited, _handleInvited);
    node.assignCallback(CallbackEvent.Accepted, _handleAccepted);
    node.assignCallback(CallbackEvent.Denied, _handleDenied);
    node.assignCallback(CallbackEvent.Progressed, _handleProgressed);
    node.assignCallback(CallbackEvent.Completed, _handleCompleted);
    node.assignCallback(CallbackEvent.Error, _handleSonrError);
    connected = true;
  }

  // ^ Lobby Has Been Updated ^ //
  void _handleRefreshed(dynamic data) async {
    // Check Type
    if (data is Lobby) {
      LobbyController lobby = Get.find();
      // Update Lobby
      lobby.refreshLobby(data);
    } else {
      throw SonrError("handleRefreshed() - " + "Invalid Return type");
    }
  }

  // ^ File has Succesfully Queued ^ //
  void _handleQueued(dynamic data) async {
    if (data is Metadata) {
      // Get Controllers
      TransferController transfer = Get.find();
      transfer.updateTransfer(metadata: data);
    } else {
      throw SonrError("handleQueued() - " + "Invalid Return type");
    }
  }

// ^ Node Has Been Invited ^ //
  void _handleInvited(dynamic data) async {
    // Check Type
    if (data is AuthMessage) {
      // Get Controllers
      ReceiveController receive = Get.find();

      // Update Data
      receive.updateReceive(message: data);
    } else {
      throw SonrError("handleInvited() - " + "Invalid Return type");
    }
  }

  // ^ Node Has Been Accepted ^ //
  void _handleAccepted(dynamic data) async {
    // Check Type
    if (data is AuthMessage) {
      // Get Controllers
      TransferController transfer = Get.find();

      // Update Data
      transfer.updateTransfer(message: data);
    } else {
      throw SonrError("handleAccepted() - " + "Invalid Return type");
    }
  }

// ^ Node Has Been Denied ^ //
  void _handleDenied(dynamic data) async {
    // Check Type
    if (data is AuthMessage) {
      // Get Controllers
      TransferController transfer = Get.find();

      // Update Data
      transfer.updateTransfer(message: data);
    } else {
      throw SonrError("handleDenied() - " + "Invalid Return type");
    }
  }

// ^ Transfer Has Updated Progress ^ //
  void _handleProgressed(dynamic data) async {
    if (data is ProgressUpdate) {
      // Get Controllers
      ReceiveController receive = Get.find();

      // Update Data
      receive.updateReceive(progress: data);
    } else {
      throw SonrError("handleProgressed() - " + "Invalid Return type");
    }
  }

  // ^ Transfer Has Succesfully Completed ^ //
  void _handleCompleted(dynamic data) async {
    if (data is Metadata) {
      // Get Controllers
      ReceiveController receive = Get.find();
      TransferController transfer = Get.find();

      receive.setCompleted(data);
      transfer.setCompleted();
    } else {
      throw SonrError("handleCompleted() - " + "Invalid Return type");
    }
  }

  // ^ An Error Has Occurred ^ //
  void _handleSonrError(dynamic data) async {
    if (data is ErrorMessage) {
      throw SonrError(data.method + "() - " + data.message);
    }
  }
}
