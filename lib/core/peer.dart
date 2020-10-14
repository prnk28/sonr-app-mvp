import 'package:geolocator/geolocator.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';

// ********************** //
// ** Enums for Object ** //
// ********************** //
enum PeerStatus {
  Inactive,
  Active,
  Searching,
  Busy,
}

enum ProximityStatus {
  Immediate,
  Near,
  Far,
  Distant,
}

// ***************************** //
// ** Class for Node in Graph ** //
// ***************************** //
class Peer {
  // Management
  String id;
  String lobbyId;
  Profile profile;
  DateTime lastUpdated;

  // Proximity Variables
  double direction;
  double distance;
  double proximity;

  // Location Variables
  Position location;

  // Status Variables - Get/Set
  PeerStatus _status;
  PeerStatus get status {
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
    this.status = PeerStatus.Inactive;
  }

  // **************************** //
  // ** Methods to Update Node ** //
  // **************************** //
  // -- Setter Method to Update Status --
  set status(PeerStatus givenStatus) {
    // Update to Given Status
    _status = givenStatus;

    // Change Last Updated
    this.lastUpdated = DateTime.now();
  }

  // ************************ //
  // ** Comparison Methods ** //
  // ************************ //
  // Checker Method: If Peer can Send to Peer
  bool canSendTo(Peer peer) {
    return this.status == PeerStatus.Searching &&
        peer.status == PeerStatus.Active;
  }

  // Checker Method: If Peer can Receive from Peer
  bool canReceiveFrom(Peer peer) {
    return this.status == PeerStatus.Searching &&
        peer.status == PeerStatus.Active;
  }

  // Method to Calculate Difference between two Peers
  static double getDifference(Peer sender, Peer receiver) {
    // Check Node Status: Senders are From
    if (sender.status == PeerStatus.Searching &&
        receiver.status == PeerStatus.Active) {
      // Calculate Difference
      var diff = sender.direction - receiver.direction;

      // Log and Get difference
      return diff;
    }
    return -1;
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

    // Set Status from String
    newPeer.status = enumFromString(map["status"], PeerStatus.values);

    // Add Direction Data from Map
    newPeer.direction = map["direction"];

    // Add Location Data from Map
    var location = map["location"];
    newPeer.location = new Position(
        accuracy: location["accuracy"],
        altitude: location["altitude"],
        latitude: location["latitude"],
        longitude: location["longitude"]);

    return newPeer;
  }

  // -- Export Peer to Map for Communication --
  toMap() {
    // Create Location Map
    var loaction = {
      'accuracy': this.location.accuracy.toDouble(),
      'altitude': this.location.altitude.toDouble(),
      'latitude': this.location.latitude.toDouble(),
      'longitude': this.location.longitude.toDouble(),
    };

    // Combine into Map
    return {
      'id': id,
      "direction": this.direction.toDouble(),
      'location': loaction,
      'status': enumAsString(this.status),
      'profile': this.profile.toMap()
    };
  }
}
