import 'dart:async';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:sonr_core/utils/olc.dart';

part 'sonr_data.dart';

// -- Constants -- //
const int CALLBACK_INTERVAL = 20;

class SonrService {
// *************************
// ** Service Properties  **
// *************************
  // @ Set Dependencies
  Node _node;
  SonrStatus _status;

  // @ 1. Initialize State Bools
  bool _isConnected = false;
  bool _isProcessed = false;
  String _id = "";

  // @ 2. Initialize Data Streams
  final _auth = StreamController<AuthMessage>();
  final _lobby = StreamController<Lobby>();
  final _progress = StreamController<double>();

  // @ 3. Initialize P2P Info
  Peer _peer;
  File _sendFile;
  Metadata _sendMetadata;
  Metadata _offeredMetadata;
  Metadata _savedMetadata;
  int _callbackInterval;

  // @ 1a. Create State Getter Handlers
  SonrStatus get status => _status;
  bool get connected => _isConnected; // Created Host
  bool get processed => _isProcessed; // Pending File Processing
  String get id => _id; // Node P2P Host ID

  // @ 2a. Create Stream Getter Handlers
  Stream<AuthMessage> get authStream => _auth.stream;
  Stream<Lobby> get lobbyStream => _lobby.stream;
  Stream<double> get progressStream => _progress.stream;

  // @ 3a. Create P2P Info Getter Handlers
  Peer get peer => _peer;
  File get sendFile => _sendFile;
  Metadata get sendMetadata => _sendMetadata;
  Metadata get offeredMetadata => _offeredMetadata;
  Metadata get savedMetadata => _savedMetadata;

// *******************
// ** Node Actions  **
// *******************
  // ^ Initialize Node Method ^ //
  void initialize(Position pos, Contact con) async {
    // Get OLC
    var olcCode = OLC.encode(pos.latitude, pos.longitude, codeLength: 8);

    // Await Initialization
    _node = await SonrCore.initialize(olcCode, con);
    _isConnected = true;
    _id = _node.id;

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
    _status = SonrStatus.Available;
  }

  // ^ Update Event ^
  void update(double dir) async {
    // @ Check Connection
    if (_isConnected) {
      // Emit Update
      _node.update(dir);
    } else {
      throw SonrError("Update", "Not Connected");
    }
  }

  // ^ Queue-File Event ^
  void queueFile(File file) async {
    // @ Check Connection
    if (_isConnected) {
      // Queue File
      _node.queue(file.path);
    } else {
      throw SonrError("Update", "Not Connected");
    }
  }

  // ^ Invite-Peer Event ^
  void invitePeer(Peer peer) async {
    // @ Check Connection
    if (_isConnected) {
      // @ Check File Status
      if (_isProcessed) {
        // Send Invite
        _node.invite(peer);

        // Update Status
        _status = SonrStatus.Pending;
      } else {
        throw SonrError("InvitePeer", "File not processed.");
      }
    } else {
      throw SonrError("Update", "Not Connected");
    }
  }

  // ^ Respond-Peer Event ^
  void respondPeer(bool decision) async {
    // @ Check Connection
    if (_isConnected) {
      // Send Response
      _node.respond(decision);

      // Update Status by Decision
      if (decision) {
        _status = SonrStatus.Transferring;
      } else {
        _status = SonrStatus.Available;
      }
    } else {
      throw SonrError("Update", "Not Connected");
    }
  }

// ************************
// ** Callback Handlers  **
// ************************

  // ^ Lobby Has Been Updated ^ //
  void _handleRefreshed(dynamic data) async {
    // Check Type
    if (data is Lobby) {
      // Update Stream
      _lobby.sink.add(data);
    }
  }

  // ^ File has Succesfully Queued ^ //
  void _handleQueued(dynamic data) async {
    if (data is Metadata) {
      // Set Data
      _sendMetadata = data;

      // Update Status
      _status = SonrStatus.Searching;
    }
  }

// ^ Node Has Been Invited ^ //
  void _handleInvited(dynamic data) async {
    // Check Type
    if (data is AuthMessage) {
      // Set Data
      _peer = data.from;
      _offeredMetadata = data.metadata;
      _callbackInterval = (data.metadata.chunks / CALLBACK_INTERVAL).ceil();

      // Update Stream
      _auth.sink.add(data);

      // Update Status
      _status = SonrStatus.Pending;
    }
  }

  // ^ Node Has Been Accepted ^ //
  void _handleAccepted(dynamic data) async {
    // Check Type
    if (data is AuthMessage) {
      // Update Stream
      _auth.sink.add(data);

      // Start Transfer
      _node.transfer();

      // Update Status
      _status = SonrStatus.Transferring;
    }
  }

// ^ Node Has Been Denied ^ //
  void _handleDenied(dynamic data) async {
    // Check Type
    if (data is AuthMessage) {
      // Update Stream
      _auth.sink.add(data);

      // Update Status
      _status = SonrStatus.Searching;
    }
  }

// ^ Transfer Has Updated Progress ^ //
  void _handleProgressed(dynamic data) async {
    if (data is ProgressUpdate) {
      // Update Cubit on Interval
      if (data.current % _callbackInterval == 0) {
        _progress.sink.add(data.progress);
      }
    }
  }

  // ^ Transfer Has Succesfully Completed ^ //
  void _handleCompleted(dynamic data) async {
    if (data is Metadata) {
      // @ Sending Direction
      if (_status == SonrStatus.Transferring) {
        // Update Status
        _status = SonrStatus.CompletedTransfer;
      }
      // @ Receiving Direction
      else if (_status == SonrStatus.Receiving) {
        // Set Data
        _savedMetadata = data;

        // Update Status
        _status = SonrStatus.CompletedReceive;
      }
    }
  }

  // ^ An Error Has Occurred ^ //
  void _handleSonrError(dynamic data) async {
    if (data is ErrorMessage) {
      throw SonrError(data.method, data.message);
    }
  }

  // ! -- Dispose Streams -- //
  dispose() {
    _auth.close();
    _lobby.close();
    _progress.close();
  }
}
