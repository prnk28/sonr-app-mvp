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
  Transferring // In Transfer
}

class Peer {
  // Management
  String id;
  String olc;
  Device device;
  Profile profile;
  DateTime lastUpdated;
  Status _status;

  // Sensory Variables
  double direction;
  double distance;
  ProximityStatus proximity;

  // Dependencies
  DirectedValueGraph _graph;
  RTCSession _session;

// ** Constructer **
  Peer(this.profile) {
    // Set Default Variables
    this.id = uuid.v1();
    this.direction = 0.01;
    this.status = Status.Offline;
    this.device.getPlatform();

    // Initialize Dependencies
    _graph = new DirectedValueGraph();
    _session = new RTCSession();
  }

// ** Build Neighbor from Map **
  static Peer fromMap(Map map) {
    Peer neighbor = new Peer(Profile.fromMap(map['profile']));
    neighbor.id = map['id'];
    neighbor.device.fromString(map["device"]);
    neighbor.status.fromString(map["status"]);
    neighbor.direction = map['direction'];
    return neighbor;
  }

// ** Reset Networking and Node itself **
  void reset() {
    log.i("Work in Progress");
  }

// ** Convert Object to Map **
  // -- Export Peer to Map for Communication --
  toMap() {
    return {
      'id': this.id,
      'device': this.device.asString(),
      'direction': this.direction.toDouble(),
      'profile': this.profile.toMap(),
      'status': this.status.asString()
    };
  }
}
