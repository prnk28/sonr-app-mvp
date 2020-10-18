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
  Profile profile;
  DateTime lastUpdated;
  Device device;

  // Sensory Variables
  double direction;
  double distance;
  ProximityStatus proximity;
  Location location;

  // Dependencies
  DirectedValueGraph _graph;
  RTCSession _session;

  // -- Status --
  Status _status;

  // Getter
  Status get status {
    return _status;
  }

  // Setter
  set status(Status status) {
    // Update to Given Status
    _status = status;

    // Change Last Updated
    this.lastUpdated = DateTime.now();
  }

// ** Constructer **
  Peer({this.profile, Map map}) {
    // ******************* //
    // ** Neigbhor Peer ** //
    // ******************* //
    if (map != null && this.profile == null) {
      // Set Variables from Map
      this.id = map['id'];
      this.profile.fromMap(map['profile']);
      this.device.fromString(map["device"]);
      this.status.fromString(map["status"]);
      this.direction = map['direction'];

      // Deactivate Dependencies
      _graph = null;
      _session = null;
    }
    // *************** //
    // ** User Peer ** //
    // *************** //
    else {
      // Set Default Variables
      this.id = uuid.v1();
      this.direction = 0.01;
      this.status = Status.Offline;
      this.device = getPlatform();

      // Initialize Dependencies
      _graph = new DirectedValueGraph();
      _session = new RTCSession();
    }
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
