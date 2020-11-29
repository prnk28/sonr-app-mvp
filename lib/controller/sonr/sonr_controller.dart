import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:sonr_core/utils/olc.dart';
import 'package:get/get.dart' hide Node;
part 'sonr_data.dart';

//() -- Constants() -- //
const int CALLBACK_INTERVAL = 16; // Every Kilobyte

class SonrController extends GetxController {
// *************************
// ** Service Properties  **
// *************************
  // @ Set Dependencies
  Node _node;
  bool _isConnected = false;
  bool _isProcessed = false;
  int _callbackInterval;

  // @ 1. Initialize State Bools
  final status = Rx<SonrStatus>();

  // @ 2. Initialize Data Streams
  final auth = Rx<AuthMessage>();
  final lobby = Rx<Lobby>();
  final progress = 0.0.obs;

  // @ 3. Initialize P2P Info
  final currentPeer = Rx<Peer>();
  final sendFile = Rx<File>();
  final sendMetadata = Rx<Metadata>();
  final offeredMetadata = Rx<Metadata>();
  final savedMetadata = Rx<Metadata>();

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
    status.update((status) {
      status = SonrStatus.Available;
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
        status.update((val) {
          val = SonrStatus.Pending;
        });

        // Update Peer
        currentPeer.update((val) {
          val.relation = Peer_Relation.INVITED;
          val = peer;
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
        status.update((val) {
          val = SonrStatus.Receiving;
        });
      } else {
        // Update Status
        status.update((val) {
          val = SonrStatus.Available;
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
      lobby.update((val) {
        val = data;
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
      sendMetadata.update((val) {
        val = data;
      });

      status.update((val) {
        val = SonrStatus.Searching;
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

      // Update Status
      status.update((val) {
        val = SonrStatus.Pending;
      });

      // Update Auth
      auth.update((val) {
        val = data;
      });

      // Update Peer
      currentPeer.update((val) {
        val = data.from;
      });

      // Update Metadata
      offeredMetadata.update((val) {
        val = data.metadata;
      });
    } else {
      throw SonrError("handleInvited() - " + "Invalid Return type");
    }
  }

  // ^ Node Has Been Accepted ^ //
  void _handleAccepted(dynamic data) async {
    // Check Type
    if (data is AuthMessage) {
      // Update Status
      status.update((val) {
        val = SonrStatus.Transferring;
      });

      // Update Auth
      auth.update((val) {
        val = data;
      });

      // Update Peer
      currentPeer.update((val) {
        val = data.from;
        val.relation = Peer_Relation.ACCEPTED;
      });

      // Update Metadata
      offeredMetadata.update((val) {
        val = data.metadata;
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
      // Update Status
      status.update((val) {
        val = SonrStatus.Searching;
      });

      // Update Auth
      auth.update((val) {
        val = data;
      });

      // Update Peer
      currentPeer.update((val) {
        val = data.from;
        val.relation = Peer_Relation.DECLINED;
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
        // Update progress
        progress.update((val) {
          val = data.percent;
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
      if (status.value == SonrStatus.Transferring) {
        // Update Status
        status.update((val) {
          val = SonrStatus.CompletedTransfer;
        });
      }
      // @ Receiving Direction
      else if (status.value == SonrStatus.Receiving) {
        // Update Status
        status.update((val) {
          val = SonrStatus.CompletedReceive;
        });

        // Update Metadata
        savedMetadata.update((val) {
          val = data;
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
