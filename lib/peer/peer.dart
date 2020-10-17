import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/repository/repository.dart';

part 'emitter.dart';
part 'circle.dart';
part 'handler.dart';

// ** Status Enum ** //
enum Status {
  Disconnected,
  Active,
  Searching,
  Pending,
  Requested,
  Transferring
}

// ***************************** //
// ** Class for Node in Graph ** //
// ***************************** //
class Peer {
  // Management
  String id;
  Profile profile;
  DateTime lastUpdated;
  DeviceType device;

  // Sensory Variables
  double direction;
  double distance;
  ProximityStatus proximity;
  Position location;

  // Dependencies
  DirectedValueGraph _graph;
  RTCSession _session;

  // Status Variables - Get/Set
  Status _status;
  Status get status {
    return _status;
  }

  // ***************** //
  // ** Constructer ** //
  // ***************** //
  Peer(this.profile) {
    // Set Id
    this.id = uuid.v1();

    // Default Direction Variables
    this.direction = 0.01;

    // Default Location Variables
    this.location = new Position(
        accuracy: 12345, altitude: 123, latitude: 45, longitude: -120);

    // Default Object Variables
    this.status = Status.Disconnected;

    // Set Device
    this.device = getPlatform();

    // Initialize Dependencies
    _graph = new DirectedValueGraph();
    _session = new RTCSession();
  }

  // **************************** //
  // ** Methods to Update Node ** //
  // **************************** //
  // -- Setter Method to Update Status --
  set status(Status givenStatus) {
    // Update to Given Status
    _status = givenStatus;

    // Change Last Updated
    this.lastUpdated = DateTime.now();
  }

  // ** Reset Networking and Node itself **
  void reset() {
    log.i("Work in Progress");
  }

  // *********************** //
  // ** Object Generation ** //
  // *********************** //
  // -- Generate Peer from Map --
  static Peer fromMap(Map map) {
    // Extract Profile and Create Peer
    Profile profile = Profile.fromMap(map["profile"]);
    Peer newPeer = new Peer(profile);
    newPeer.id = map["id"];

    // Set Direction
    newPeer.direction = map["direction"];

    // Set Device
    newPeer.device = enumFromString(map["device"], DeviceType.values);

    // Set Location
    newPeer.location = new Position(
        accuracy: map["location"]["accuracy"],
        altitude: map["location"]["altitude"],
        latitude: map["location"]["latitude"],
        longitude: map["location"]["longitude"]);

    // Set Status
    newPeer.status = enumFromString(map["status"], Status.values);

    return newPeer;
  }

  // -- Export Peer to Map for Communication --
  toMap() {
    return {
      'id': id,
      'device': enumAsString(this.device),
      'direction': this.direction.toDouble(),
      'location': {
        'accuracy': this.location.accuracy.toDouble(),
        'altitude': this.location.altitude.toDouble(),
        'latitude': this.location.latitude.toDouble(),
        'longitude': this.location.longitude.toDouble()
      },
      'profile': this.profile.toMap(),
      'status': enumAsString(this.status)
    };
  }
}
