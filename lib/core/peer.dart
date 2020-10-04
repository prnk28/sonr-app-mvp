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
  double accuracy;
  double altitude;
  double latitude;
  double longitude;

  // ***************** //
  // ** Constructer ** //
  // ***************** //
  Peer(this.profile) {
    // Defualt Motion Variables
    this.motion = new AccelerometerEvent(0, 0, 0);

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
        if (this.direction < 270) {
          adjusted = direction + 90;
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
        this.antipodalDirection = -1;
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

  // Method to Calculate Difference with another Peer
  double getDifference(Peer peer) {
    // Check Node Status: Senders are From
    if (this.status == PeerStatus.Sending &&
        peer.status == PeerStatus.Receiving) {
      // Calculate Difference
      return this.direction - peer.antipodalDirection;
    }
    // Check Node Status: Receivers are To
    else if (this.status == PeerStatus.Receiving &&
        peer.status == PeerStatus.Sending) {
      // Calculate Difference
      return this.antipodalDirection - peer.direction;
    }
    return null;
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

  // *********************** //
  // ** Object Generation ** //
  // *********************** //
  // -- Generate Peer from Map --
  static Peer fromMap(Map map) {
    // Extract Profile and Create Peer
    Profile profile = Profile.fromMap(map["profile"]);
    Peer newPeer = new Peer(profile);
    newPeer.id = map["id"];

    // Add Motion from Map
    newPeer.motion = new AccelerometerEvent(
        map["motion"]["x"], map["motion"]["y"], map["motion"]["z"]);

    // Add Compass Data from Map
    newPeer.direction = map["compass"]["direction"];
    newPeer.antipodalDirection = map["compass"]["antipodalDegress"];

    // Add Location Data from Map
    newPeer.accuracy = map["location"]["accuracy"];
    newPeer.altitude = map["location"]["altitude"];
    newPeer.latitude = map["location"]["latitude"];
    newPeer.longitude = map["location"]["longitude"];

    // Set Status from String
    newPeer.status = enumFromString(map["status"], PeerStatus.values);

    return newPeer;
  }

  // -- Export Peer to Map for Communication --
  toMap() {
    // Create Direction Map
    var compass = {
      "direction": this.direction,
      "antipodalDegrees": this.antipodalDirection
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

  // -- Read the Data in this Object --
  read() {
    log.i("Peer #" + this.id);
    print(this.toMap().toString());
  }
}
