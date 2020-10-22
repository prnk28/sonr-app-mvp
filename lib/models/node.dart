import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/core/core.dart';

// ** Proximity Enum ** //
enum Proximity { Immediate, Near, Far, Away }

// Status of Node
enum Status {
  Initial,
  Offline, // Offline Status
  Available, // Ready to Receive
  Searching, // Looking for Peers
  Busy, // Pending/Waiting/Transferring
}

class Node {
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
  Proximity proximity;

// ** Constructer **
  Node(this.profile) {
    // Set Default Variables
    this.id = "";
    this._status = Status.Initial;
    this.direction = 0.01;
    this.device = Platform.operatingSystem.toUpperCase();
  }

// ** Build Peer from Map **
  static Node fromMap(Map map) {
    Node neighbor = new Node(Profile.fromMap(map['profile']));
    neighbor.id = map['id'];
    neighbor.device = map["device"];
    neighbor.direction = map['direction'];
    neighbor.status = enumFromString(map["status"], Status.values);
    return neighbor;
  }

  // ** Checker Method: If Peer can Send to Peer **
  canSendTo(Node peer) {
    // Verify Status
    bool statusCheck;
    statusCheck =
        this.status == Status.Searching && peer.status == Status.Available;

    // Check Id
    bool idCheck;
    idCheck = this.id != null && peer.id != null;

    // Validate
    return statusCheck && idCheck;
  }

  // ** Get Difference When User is Searching **
  getDifference(Node receiver) {
    // Check Node Status: Senders are From
    if (this.status == Status.Searching &&
        receiver.status == Status.Available) {
      // Calculate Difference
      var diff = this.direction - receiver.direction;

      // Log and Get difference
      return diff.abs();
    }
    return -1;
  }

  // ** Set OLC from Current Location **
  setLocation() async {
    // Get Location
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // Encode OLC
    this.olc = OLC.encode(position.latitude, position.longitude, codeLength: 8);
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
