import 'package:geolocator/geolocator.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';
import 'package:uuid/uuid.dart';

// ********************** //
// ** Enums for Object ** //
// ********************** //
enum PeerStatus {
  Inactive,
  Active,
  Searching,
  Busy,
}

// ***************************** //
// ** Class for Node in Graph ** //
// ***************************** //
class Peer {
  // Management
  String id;
  Profile profile;
  DateTime lastUpdated;
  String lobbyId;

  // Compass Variables - Get/Set
  double _direction;
  double antipodalDirection;

  // Proximity Variables
  double distance;
  double proximity;

  // Degrees Getter
  double get direction {
    return _direction;
  }

  // Enum Private Variables - Get/Set
  PeerStatus _status;

  // Status Getter
  PeerStatus get status {
    return _status;
  }

  // Location Variables
  Position location;
  int accuracy;
  int altitude;
  int latitude;
  int longitude;

  // ***************** //
  // ** Constructer ** //
  // ***************** //
  Peer(this.profile) {
    // Set Id
    var uuid = Uuid();
    this.id = uuid.v1();

    // Default Direction Variables
    this.direction = 0.01;

    // Default Location Variables
    this.accuracy = 12345;
    this.altitude = 123;
    this.latitude = 45;
    this.longitude = -120;

    // Default Object Variables
    this.status = PeerStatus.Inactive;
  }

  // ****************************** //
  // ** Methods to Update Values ** //
  // ****************************** //
  // -- Setter to Update Direction --
  set direction(double newDegrees) {
    // Set New Direction
    _direction = newDegrees;

    // Find Antipodal Degrees
    var adjusted;
    // switch (orientation) {
    //   case OrientationType.LandscapeLeft:
    //     // Set Adjusted
    //     if (this.direction < 90) {
    //       adjusted = 270 - this.direction;
    //     } else {
    //       adjusted = this.direction - 90;
    //     }

    //     // Get Reciprocal of Adjusted
    //     if (adjusted < 180) {
    //       this.antipodalDirection = adjusted + 180;
    //     } else {
    //       this.antipodalDirection = adjusted - 180;
    //     }
    //     break;
    //   case OrientationType.LandscapeRight:
    //     // Set Adjusted
    //     if (newDegrees < 270) {
    //       adjusted = this.direction + 90;
    //     } else {
    //       adjusted = this.direction - 270;
    //     }

    //     // Get Reciprocal of Adjusted
    //     if (adjusted < 180) {
    //       this.antipodalDirection = adjusted + 180;
    //     } else {
    //       this.antipodalDirection = adjusted - 180;
    //     }
    //     break;
    //   default:
    //     this.antipodalDirection = -1.0;
    //     break;
    // }
  }

  // -- Setter Method to Update Status --
  set status(PeerStatus givenStatus) {
    // Update to Given Status
    _status = givenStatus;

    // Change Last Updated
    this.lastUpdated = DateTime.now();
  }

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
      var diff = sender.direction - receiver.antipodalDirection;

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

    // Add Compass Data from Map
    var compass = map["compass"];
    newPeer.direction = compass["direction"];

    // Add Location Data from Map
    var location = map["location"];
    newPeer.accuracy = location["accuracy"];
    newPeer.altitude = location["altitude"];
    newPeer.latitude = location["latitude"];
    newPeer.longitude = location["longitude"];

    return newPeer;
  }

  // -- Export Peer to Map for Communication --
  toMap() {
    // Create Direction Map
    var compass = {
      "direction": this.direction.toDouble(),
    };

    // Create Location Map
    var loaction = {
      'accuracy': this.accuracy.toDouble(),
      'altitude': this.altitude.toDouble(),
      'latitude': this.latitude.toDouble(),
      'longitude': this.longitude.toDouble(),
    };

    // Combine into Map
    return {
      'id': id,
      'compass': compass,
      'location': loaction,
      'status': enumAsString(this.status),
      'profile': this.profile.toMap()
    };
  }
}
