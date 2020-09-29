import 'package:sonar_app/core/core.dart';

import 'models.dart';

// ********************** //
// ** Enums for Object ** //
// ********************** //
enum OrientationType {
  Portrait,
  Tilted,
  LandscapeLeft,
  LandscapeRight,
  Suspended
}

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
  // Bools for Graph
  bool isSearching;
  bool isBusy;

  // Management
  DateTime lastUpdated;
  Profile profile;

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
  double accuracy;
  double altitude;
  double latitude;
  double longitude;

  // ***************** //
  // ** Constructer ** //
  // ***************** //
  Peer(this.profile) {
    // Default Compass Variables
    this.direction = 0;
    this.antipodalDirection = 0;

    // Defualt Motion Variables
    this.orientation = OrientationType.Portrait;
    this.motion = new AccelerometerEvent(0, 0, 0);

    // Default Location Variables
    this.accuracy = 12345;
    this.altitude = 123;
    this.latitude = 45;
    this.longitude = -120;

    // Default Object Variables
    this.isSearching = false;
    this.isBusy = false;
    this.status = PeerStatus.Inactive;
  }

  // ****************************** //
  // ** Setters to Update Values ** //
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
        break;
      case OrientationType.LandscapeRight:
        // Set Adjusted
        if (this.direction < 270) {
          adjusted = direction + 90;
        } else {
          adjusted = this.direction - 270;
        }
        break;
      default:
        this.antipodalDirection = -1;
        break;
    }

    // Get Reciprocal of Adjusted
    if (adjusted < 180) {
      this.antipodalDirection = adjusted + 180;
    } else {
      this.antipodalDirection = adjusted - 180;
    }
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
    // Searching for Peer
    if (givenStatus == PeerStatus.Sending ||
        givenStatus == PeerStatus.Receiving) {
      // Change Bools
      this.isSearching = true;
      this.isBusy = false;
    }
    // Busy interacting with peer
    else if (givenStatus == PeerStatus.Busy) {
      // Change Bools
      this.isSearching = false;
      this.isBusy = true;
    }
    // Default
    else {
      // Change Bools
      this.isSearching = false;
      this.isBusy = false;
    }

    // Update to Given Status
    _status = givenStatus;

    // Change Last Updated
    this.lastUpdated = DateTime.now();
  }

  // *********************** //
  // ** Object Generation ** //
  // *********************** //
  // -- Generate Peer from Map --
  static Peer fromMap({Map map}) {
    // Extract Profile and Create Peer
    Profile profile = Profile.fromMap(map["profile"]);
    Peer newPeer = new Peer(profile);

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
    newPeer.status = enumValueFromString(map["status"], PeerStatus.values);

    return newPeer;
  }

  // -- Update Existing Peer with Map Data --
  update({Map map}) {
    // Add Motion from Data
    this.motion = new AccelerometerEvent(
        map["motion"]["x"], map["motion"]["y"], map["motion"]["z"]);

    // Add Compass Data from Map
    this.direction = map["compass"]["direction"];
    this.antipodalDirection = map["compass"]["antipodalDegress"];

    // Add Location Data from Map
    this.accuracy = map["location"]["accuracy"];
    this.altitude = map["location"]["altitude"];
    this.latitude = map["location"]["latitude"];
    this.longitude = map["location"]["longitude"];

    // Set Status from String
    this.status = enumValueFromString(map["status"], PeerStatus.values);
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
      "orientation": enumValueToString(this.orientation)
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
      'motion': motion,
      'compass': compass,
      'location': loaction,
      'status': enumValueToString(this.status),
      'profile': this.profile.toMap()
    };
  }

  // -- Export ONLY Compass Data --
  compassToMap() {
    return {
      "direction": this.direction,
      "antipodalDegrees": this.antipodalDirection
    };
  }

    // -- Export ONLY Motion Data --
  motionToMap() {
    return {
      "x": this.motion.x,
      "y": this.motion.y,
      "z": this.motion.z,
      "orientation": enumValueToString(this.orientation)
    };
  }

  // -- Export ONLY Location Data --
  locationToMap() {
    return {
      'accuracy': this.accuracy,
      'altitude': this.altitude,
      'latitude': this.latitude,
      'longitude': this.longitude,
    };
  }
}
