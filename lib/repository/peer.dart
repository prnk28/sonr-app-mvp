import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/repository/repository.dart';

part 'emitter.dart';
part 'graphing.dart';
part 'handler.dart';

enum Status {
  Offline, // Initial Status
  Standby, // Device Located ready to connect
  Available, // Ready to Receive
  Searching, // Looking for Peers
  Pending, // Waiting for Confirmation
  Requested, // Offered Transfer
  Authorized, // Receiver Made Decision
  Answered, // Sender Responded to Offer
  Transferring // In Transfer
}

class Peer {
  // Management
  String id;
  String olc;
  String device;
  Profile profile;
  DateTime lastUpdated;
  Status _status;
  Status get status {
    return _status;
  }

  // ** Set Status/ Change LastUpdated **
  set status(Status status) {
    // Update to Given Status
    _status = status;

    // Change Last Updated
    this.lastUpdated = DateTime.now();
  }

  // Sensory Variables
  double direction;
  double distance;
  ProximityStatus proximity;

  // Dependencies
  RTCSession session;
  DirectedValueGraph _graph;

// ** Constructer **
  Peer(this.profile) {
    // Set Default Variables
    this.id = "";
    this.direction = 0.01;
    this.status = Status.Offline;
    this.device = Platform.operatingSystem.toUpperCase();

    // Initialize Dependencies
    _graph = new DirectedValueGraph();
    session = new RTCSession();
  }

// ** Build Neighbor from Map **
  static Peer fromMap(Map map) {
    Peer neighbor = new Peer(Profile.fromMap(map['profile']));
    neighbor.id = map['id'];
    neighbor.device = map["device"];
    neighbor.direction = map['direction'];
    neighbor.status = enumFromString(map["status"], Status.values);
    return neighbor;
  }

// ** Reset Networking and Node itself **
  void reset({Peer match}) {
    // Check if Match Provided
    if (match != null) {
      // Close Connection and DataChannel
      session.peerConnections[match.id].close();
      session.dataChannels[match.id].close();

      // Remove from Connection and DataChannel
      session.peerConnections[match.id].remove();
      session.dataChannels[match.id].remove();

      // Clear Session ID
      session.id = null;
    }
  }

// ** Convert Object to Map **
  // -- Export Peer to Map for Communication --
  toMap() {
    return {
      'id': this.id,
      'device': this.device,
      'direction': this.direction.toDouble(),
      'profile': this.profile.toMap(),
      'status': enumAsString(this.status)
    };
  }
}
