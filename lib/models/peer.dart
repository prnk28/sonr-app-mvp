import 'models.dart';

// Peer Enums
enum OrientationType { Default, Tilt, LandscapeLeft, LandscapeRight }

enum Status { Standby, Sending, Receiving }

class Peer {
  // Compass Variables
  double degrees;
  double antipodalDegress;

  // Accelerometer Variables
  double accelX;
  double accelY;
  double accelZ;
  OrientationType orientation;
  Status status;

  // Object Variables
  DateTime lastUpdated;
  final Profile profile;

  // ** Constructer **
  Peer(this.profile) {
    this.lastUpdated = DateTime.now();
    this.status = Status.Standby;
  }

  // ** Generate Peer from Map **
  static Peer fromMap({Map data}) {
    // Extract Profile and Create Peer
    Profile profile = Profile.fromMap(data["profile"]);
    Peer newPeer = new Peer(profile);

    // Add Direction from Data
    newPeer.degrees = data["direction"]["degrees"];
    newPeer.antipodalDegress = data["direction"]["antipodalDegress"];

    // Add Motion from Data
    newPeer.accelX = data["motion"]["accelX"];
    newPeer.accelY = data["motion"]["accelY"];
    newPeer.accelZ = data["motion"]["accelZ"];

    // Set Orientation from String
    newPeer.orientation = OrientationType.values
        .firstWhere((e) => e.toString() == data["motion"]["orientation"]);

    // Set Status from String
    newPeer.status =
        Status.values.firstWhere((e) => e.toString() == data["status"]);
  }

  // ** Method to Update Direction **
  updateDirection(double newDegrees) {
    this.degrees = newDegrees;
    this.antipodalDegress = getAntipodalDegrees(this.degrees, this.accelX);
    this.lastUpdated = DateTime.now();
  }

  // ** Method to Update Motion **
  updateMotion(double newX, double newY, newZ) {
    // Set Class Variables
    this.accelX = newX;
    this.accelY = newY;
    this.accelZ = newZ;
    this.orientation =
        getOrientationFromAccelerometer(this.accelX, this.accelY);
    this.lastUpdated = DateTime.now();

    // Determine Status
    if (this.isReceiving()) {
      this.status = Status.Receiving;
    } else if (this.isSending()) {
      this.status = Status.Sending;
    } else {
      this.status = Status.Standby;
    }
  }

  // ** Method to Get Antipodal Degrees **
  getAntipodalDegrees(double degrees, double accelerometerX) {
    // Verify Peer is Receiver
    if (this.orientation == OrientationType.LandscapeLeft ||
        this.orientation == OrientationType.LandscapeRight) {
      // Right Tilt
      if (accelerometerX < 0) {
        // Adjust by Degrees
        if (degrees < 270) {
          // Get Temp Value
          var temp = degrees + 90;

          // Get Reciprocal of Adjusted
          if (temp < 180) {
            return temp + 180;
          } else {
            return temp - 180;
          }
        } else {
          // Get Temp Value
          var temp = degrees - 270;

          // Get Reciprocal of Adjusted
          if (temp < 180) {
            return temp + 180;
          } else {
            return temp - 180;
          }
        }
      }
      // Left Tilt
      else {
        // Adjust by Degrees
        if (degrees < 90) {
          // Get Temp Value
          var temp = 270 - degrees;

          // Get Reciprocal of Adjusted
          if (temp < 180) {
            return temp + 180;
          } else {
            return temp - 180;
          }
        } else {
          // Get Temp Value
          var temp = degrees - 90;

          // Get Reciprocal of Adjusted
          if (temp < 180) {
            return temp + 180;
          } else {
            return temp - 180;
          }
        }
      }
    } else {
      return -1;
    }
  }

  // ** Method to get Device Orientation **
  getOrientationFromAccelerometer(double x, double y) {
    // Set Sonar State by Accelerometer
    if (x > 7.5) {
      return OrientationType.LandscapeLeft;
    } else if (x < -7.5) {
      return OrientationType.LandscapeRight;
    } else {
      // Detect Position for Default and Tilt
      if (y > 4.1) {
        return OrientationType.Default;
      } else {
        return OrientationType.Tilt;
      }
    }
  }

  // ** BOOL: Check if Tilted or Landscape **
  bool isSearching() {
    return this.orientation == OrientationType.Tilt ||
        this.orientation == OrientationType.LandscapeLeft ||
        this.orientation == OrientationType.LandscapeRight;
  }

  // ** BOOL: Check if Tilted **
  bool isSending() {
    return this.orientation == OrientationType.Tilt;
  }

  // ** BOOL: Check if Landscape **
  bool isReceiving() {
    return this.orientation == OrientationType.LandscapeLeft ||
        this.orientation == OrientationType.LandscapeRight;
  }

  // ** Export Peer to Map for Communication
  toMap() {
    // Create Direction Map
    var direction = {
      "degrees": this.degrees,
      "antipodalDegrees": this.antipodalDegress
    };

    // Create Motion Map
    var motion = {
      "accelX": this.accelX,
      "accelY": this.accelY,
      "accelZ": this.accelZ,
      "orientation": this.orientation.toString()
    };

    // Combine into Map
    return {
      'motion': motion,
      'direction': direction,
      'status': this.status.toString(),
      'profile': this.profile.toMap()
    };
  }
}
