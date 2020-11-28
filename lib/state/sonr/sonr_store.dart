import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:sonr_core/utils/olc.dart';
import 'package:get/get.dart' hide Node;
import '../state.dart';
part 'sonr_data.dart';

//() -- Constants() -- //
const int CALLBACK_INTERVAL = 16; // Every Kilobyte

class SonrStore extends GetxController {
// *************************
// ** Service Properties  **
// *************************
  // @ Set Dependencies
  Node _node;
  bool _isConnected = false;
  bool _isProcessed = false;
  int _callbackInterval;

  // @ 1. Initialize State Bools
  SonrStatus status;

  // @ 2. Initialize Data Streams
  AuthMessage auth;
  Lobby lobby;
  ProgressUpdate progress;

  // @ 3. Initialize P2P Info
  Peer currentPeer;
  File sendFile;
  Metadata sendMetadata;
  Metadata offeredMetadata;
  Metadata savedMetadata;

// *******************
// ** Node Actions  **
// *******************
  // ^ Initialize Node Method ^ //
  void initialize(Position pos, Contact con) async {
    // Get OLC
    var olcCode = OLC.encode(pos.latitude, pos.longitude, codeLength: 8);

    // Await Initialization
    _node = await SonrCore.initialize(olcCode, con, logging: false);
    _isConnected = true;

    // Assign Node Callbacks
    _node.assignCallback(CallbackEvent.Refreshed, _handleRefreshed);
    _node.assignCallback(CallbackEvent.Queued, _handleQueued);
    _node.assignCallback(CallbackEvent.Invited, _handleInvited);
    _node.assignCallback(CallbackEvent.Accepted, _handleAccepted);
    _node.assignCallback(CallbackEvent.Denied, _handleDenied);
    _node.assignCallback(CallbackEvent.Progressed, _handleProgressed);
    _node.assignCallback(CallbackEvent.Completed, _handleCompleted);
    _node.assignCallback(CallbackEvent.Error, _handleSonrError);

    // Update Status
    sonrStore.update((sonrStore) {
      sonrStore.status = SonrStatus.Available;
    });
  }

  // ^ Update Event ^
  void updateDirection(double dir) async {
    // @ Check Connection
    if (_isConnected) {
      // Emit Update
      await _node.update(dir);
    } else {
      throw SonrError("update() - " + "Not Connected");
    }
  }

  // ^ Queue-File Event ^
  void queueFile(File file) async {
    // @ Check Connection
    if (_isConnected) {
      // Queue File
      _node.queue(file.path);
    } else {
      throw SonrError("queueFile() - " + " Not Connected");
    }
  }

  // ^ Invite-Peer Event ^
  void invitePeer(Peer peer) async {
    // @ Check Connection
    if (_isConnected) {
      // @ Check File Status
      if (_isProcessed) {
        // Send Invite
        await _node.invite(peer);

        // Update Status
        sonrStore.update((sonrStore) {
          peer.relation = Peer_Relation.INVITED;
          sonrStore.currentPeer = peer;
          sonrStore.status = SonrStatus.Pending;
        });
      } else {
        throw SonrError("InvitePeer() - " + "File not processed.");
      }
    } else {
      throw SonrError("invitePeer() - " + "Not Connected");
    }
  }

  // ^ Respond-Peer Event ^
  void respondPeer(bool decision) async {
    // @ Check Connection
    if (_isConnected) {
      // Update Status by Decision
      if (decision) {
        // Update Status
        sonrStore.update((sonrStore) {
          sonrStore.status = SonrStatus.Receiving;
        });
      } else {
        // Update Status
        sonrStore.update((sonrStore) {
          sonrStore.status = SonrStatus.Available;
        });
      }

      // Send Response
      await _node.respond(decision);
    } else {
      throw SonrError("respondPeer() - " + "Not Connected");
    }
  }

// ************************
// ** Callback Handlers  **
// ************************

  // ^ Lobby Has Been Updated ^ //
  void _handleRefreshed(dynamic data) async {
    // Check Type
    if (data is Lobby) {
      // Update Status
      sonrStore.update((sonrStore) {
        sonrStore.lobby = data;
      });
    } else {
      throw SonrError("handleRefreshed() - " + "Invalid Return type");
    }
  }

  // ^ File has Succesfully Queued ^ //
  void _handleQueued(dynamic data) async {
    if (data is Metadata) {
      // Set Data
      _isProcessed = true;
      // Update Status
      sonrStore.update((sonrStore) {
        sonrStore.sendMetadata = data;
        sonrStore.status = SonrStatus.Searching;
      });
    } else {
      throw SonrError("handleQueued() - " + "Invalid Return type");
    }
  }

// ^ Node Has Been Invited ^ //
  void _handleInvited(dynamic data) async {
    // Check Type
    if (data is AuthMessage) {
      // Set Interval
      _callbackInterval = (data.metadata.chunks / CALLBACK_INTERVAL).ceil();

      // Update Data
      sonrStore.update((sonrStore) {
        sonrStore.currentPeer = data.from;
        sonrStore.auth = data;
        sonrStore.offeredMetadata = data.metadata;
        sonrStore.status = SonrStatus.Pending;
      });
    } else {
      throw SonrError("handleInvited() - " + "Invalid Return type");
    }
  }

  // ^ Node Has Been Accepted ^ //
  void _handleAccepted(dynamic data) async {
    // Check Type
    if (data is AuthMessage) {
      // Update Data
      sonrStore.update((sonrStore) {
        var _peer = data.from;
        _peer.relation = Peer_Relation.ACCEPTED;
        sonrStore.currentPeer = _peer;
        sonrStore.auth = data;
        sonrStore.offeredMetadata = data.metadata;
        sonrStore.status = SonrStatus.Transferring;
      });

      // Start Transfer
      _node.transfer();
    } else {
      throw SonrError("handleAccepted() - " + "Invalid Return type");
    }
  }

// ^ Node Has Been Denied ^ //
  void _handleDenied(dynamic data) async {
    // Check Type
    if (data is AuthMessage) {
      // Update Data
      sonrStore.update((sonrStore) {
        var _peer = data.from;
        _peer.relation = Peer_Relation.DECLINED;
        sonrStore.currentPeer = _peer;
        sonrStore.auth = data;
        sonrStore.offeredMetadata = data.metadata;
        sonrStore.status = SonrStatus.Searching;
      });
    } else {
      throw SonrError("handleDenied() - " + "Invalid Return type");
    }
  }

// ^ Transfer Has Updated Progress ^ //
  void _handleProgressed(dynamic data) async {
    if (data is ProgressUpdate) {
      // Update Cubit on Interval
      if (data.current % _callbackInterval == 0) {
        // Update Data
        sonrStore.update((sonrStore) {
          sonrStore.progress = data;
        });
      }
    } else {
      throw SonrError("handleProgressed() - " + "Invalid Return type");
    }
  }

  // ^ Transfer Has Succesfully Completed ^ //
  void _handleCompleted(dynamic data) async {
    if (data is Metadata) {
      // @ Sending Direction
      if (sonrStore().status == SonrStatus.Transferring) {
        // Update Data
        sonrStore.update((sonrStore) {
          sonrStore.status = SonrStatus.CompletedTransfer;
        });
      }
      // @ Receiving Direction
      else if (sonrStore().status == SonrStatus.Receiving) {
        // Update Data
        sonrStore.update((sonrStore) {
          sonrStore.savedMetadata = data;
          sonrStore.status = SonrStatus.CompletedReceive;
        });
      }
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
