import 'package:geolocator/geolocator.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';

// ********************** //
// ** Enums for Object ** //
// ********************** //
enum OrientationType { Portrait, Tilted, LandscapeLeft, LandscapeRight }

enum PeerStatus {
  Inactive,
  Ready,
  Sending,
  Receiving,
  Busy,
}

// ***************************** //
// ** Class for Node in Graph ** //
// ***************************** //
class Peer {
  // Management
  Profile profile;
  DateTime lastUpdated;
  String lobbyId;
  String _socketId;

  // Socket Id Getter
  String get id {
    return _socketId;
  }

  // Accelerometer Variables - Get/Set
  AccelerometerEvent _motion;
  OrientationType orientation;

  // Motion Getter
  AccelerometerEvent get motion {
    return _motion;
  }

  // Compass Variables - Get/Set
  double _direction;
  double antipodalDirection;

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
    // Defualt Motion Variables
    this.motion = new AccelerometerEvent(0.01, 0.01, 0.01);

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
    switch (orientation) {
      case OrientationType.LandscapeLeft:
        // Set Adjusted
        if (this.direction < 90) {
          adjusted = 270 - this.direction;
        } else {
          adjusted = this.direction - 90;
        }

        // Get Reciprocal of Adjusted
        if (adjusted < 180) {
          this.antipodalDirection = adjusted + 180;
        } else {
          this.antipodalDirection = adjusted - 180;
        }
        break;
      case OrientationType.LandscapeRight:
        // Set Adjusted
        if (newDegrees < 270) {
          adjusted = this.direction + 90;
        } else {
          adjusted = this.direction - 270;
        }

        // Get Reciprocal of Adjusted
        if (adjusted < 180) {
          this.antipodalDirection = adjusted + 180;
        } else {
          this.antipodalDirection = adjusted - 180;
        }
        break;
      default:
        this.antipodalDirection = -0.1; 
        break;
    }
  }

  // -- Setter for ID --
  set id(String givenId) {
    // Update Value
    _socketId = givenId;

    // Update Status
    this.status = PeerStatus.Ready;
  }

  // -- Setter to Update Motion --
  set motion(AccelerometerEvent newMotion) {
    // Set New Motion Variables
    _motion = newMotion;

    // Detect if Landscape - Left
    if (this.motion.x > 7.5) {
      // Update Orientation
      this.orientation = OrientationType.LandscapeLeft;
      // Set Status
      this.status = PeerStatus.Receiving;
    }
    // Detect if Landscape - Right
    else if (this.motion.x < -7.5) {
      // Update Orientation
      this.orientation = OrientationType.LandscapeRight;
      // Set Status
      this.status = PeerStatus.Receiving;
    }
    // Detect if Tilted
    else {
      if (this.motion.y > 4.1) {
        // Update Orientation
        this.orientation = OrientationType.Portrait;
        // Set Status
        this.status = PeerStatus.Ready;
      } else {
        // Update Orientation
        this.orientation = OrientationType.Tilted;
        // Set Status
        this.status = PeerStatus.Sending;
      }
    }
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
    return this.status == PeerStatus.Sending &&
        peer.status == PeerStatus.Receiving;
  }

  // Checker Method: If Peer can Receive from Peer
  bool canReceiveFrom(Peer peer) {
    return this.status == PeerStatus.Receiving &&
        peer.status == PeerStatus.Sending;
  }

  // Method to Calculate Difference between two Peers
  static double getDifference(Peer sender, Peer receiver) {
    // Check Node Status: Senders are From
    if (sender.status == PeerStatus.Sending &&
        receiver.status == PeerStatus.Receiving) {
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

    // Add Motion from Map
    var motion = map["motion"];
    newPeer.motion =
        new AccelerometerEvent(motion["x"], motion["y"], motion["z"]);

    // Add Compass Data from Map
    var compass = map["compass"];
    newPeer.direction = compass["direction"];
    newPeer.antipodalDirection = compass["antipodalDirection"];

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
      "direction": this.direction,
      "antipodalDirection": this.antipodalDirection
    };

    // Create Motion Map
    var motion = {
      "x": this.motion.x,
      "y": this.motion.y,
      "z": this.motion.z,
      "orientation": enumAsString(this.orientation)
    };

    // Create Location Map
    var loaction = {
      'accuracy': this.accuracy,
      'altitude': this.altitude,
      'latitude': this.latitude,
      'longitude': this.longitude,
    };

    // Combine into Map
    return {
      'id': id,
      'motion': motion,
      'compass': compass,
      'location': loaction,
      'status': enumAsString(this.status),
      'profile': this.profile.toMap()
    };
  }
}
