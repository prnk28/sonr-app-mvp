import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonar_app/ui/modals/modals.dart';
import 'package:sonr_core/sonr_core.dart';
import 'dart:io';
import 'package:vibration/vibration.dart';

class SonrService extends GetxService {
  // @ Set Properteris
  Node _sonrNode;
  final connected = false.obs;
  String code = "";
  Status status;

  // @ Set Lobby Dependencies
  final size = 0.obs;
  final peers = Rx<List<Peer>>();

  // @ Set Transfer Dependencies
  AuthReply reply;
  Payload_Type payloadType;

  // @ Set Receive Dependencies
  AuthInvite invite;
  var offer = Rx<Metadata>();
  var progress = 0.0.obs;

  // ^ Updates Node^ //
  SonrService() {
    FlutterCompass.events.listen((newDegrees) {
      // Get Current Direction and Update Cubit
      if (connected()) {
        _sonrNode.update(newDegrees.headingForCameraMode);
      }
    });
  }

  // ^ Connect Node Method ^ //
  Future<SonrService> init(Position pos, Contact contact) async {
    // Get OLC
    code = OLC.encode(pos.latitude, pos.longitude, codeLength: 8);

    // Await Initialization
    _sonrNode = await SonrCore.initialize(
      code,
      "@Temp_Username",
      contact,
    );

    // Assign Node Callbacks
    _sonrNode.assignCallback(CallbackEvent.Refreshed, _handleRefresh);
    _sonrNode.assignCallback(CallbackEvent.Invited, _handleInvite);
    _sonrNode.assignCallback(CallbackEvent.Progressed, _handleProgress);
    _sonrNode.assignCallback(CallbackEvent.Received, _handleReceived);
    _sonrNode.assignCallback(CallbackEvent.Queued, _handleQueued);
    _sonrNode.assignCallback(CallbackEvent.Responded, _handleResponded);
    _sonrNode.assignCallback(CallbackEvent.Transmitted, _handleTransmitted);
    _sonrNode.assignCallback(CallbackEvent.Error, _handleSonrError);

    // Return and Set Connected
    connected(true);
    return this;
  }

  // **************************
  // ******* Callbacks ********
  // **************************

  // ^ Handle Lobby Update ^ //
  void _handleRefresh(dynamic data) {
    if (data is Lobby) {
      // Update Peers Code
      size(data.peers.length);

      // Update Peers List
      var peersList = data.peers.values.toList(growable: false);
      peers(peersList);
    }
  }

  // ^ File has Succesfully Queued ^ //
  void _handleQueued(dynamic data) async {
    if (data is Metadata) {
      // Update data
      status = _sonrNode.status;
      Get.offNamed("/transfer");
    }
  }

  // ^ Node Has Been Invited ^ //
  void _handleInvite(dynamic data) async {
    print("Invite" + data.toString());
    // Check Type
    if (data is AuthInvite) {
      // Update Values
      this.invite = data;

      // Inform Listener
      status = _sonrNode.status;
      Get.bottomSheet(InviteSheet());
    }
  }

  // ^ Node Has Been Accepted ^ //
  void _handleResponded(dynamic data) async {
    if (data is AuthReply) {
      // Set Message
      this.reply = data;
      status = _sonrNode.status;
      print("Peer Replied: " + reply.toString());

      if (data.payload.type == Payload_Type.CONTACT) {
        // Report Replied to Bubble for File
        Get.bottomSheet(ContactInviteView(
          reply.payload.contact,
          isReply: true,
        ));
        // update([data.from.id]);
      } else {
        // Report Replied to Bubble for File
        // update([data.from.id]);
      }
    }
  }

  // ^ Transfer Has Updated Progress ^ //
  void _handleProgress(dynamic data) async {
    if (data is double) {
      // Update Data
      this.progress(data);
    }
  }

  // ^ Resets Peer Info Event ^
  void _handleTransmitted(dynamic data) async {
    // Reset Peer/Auth
    if (data is Peer) {
      status = _sonrNode.status;
      //update([data.id]);
    }
  }

  // ^ Mark as Received File ^ //
  void _handleReceived(dynamic data) {
    if (data is Metadata) {
      // Set Data
      this.offer(data);
      status = _sonrNode.status;
      Get.back();

      // Display Completed Popup
      Future.delayed(Duration(milliseconds: 500));
      Get.dialog(CompletedPopup());
    } else {
      print("handleProgressed() - " + "Invalid Return type");
    }
  }

  // ^ An Error Has Occurred ^ //
  void _handleSonrError(dynamic data) async {
    if (data is ErrorMessage) {
      print(data.method + "() - " + data.message);
    }
  }
}
