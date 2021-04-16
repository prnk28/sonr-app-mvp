import 'dart:math';
import 'package:sonr_app/theme/form/theme.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:sonr_core/sonr_core.dart';
import 'peer.dart';

// * Constants * //
const double K_RADIUS = 1.0;
const double K_DISTANCE = 6.0;

// * Range Enum * //
enum VectorPositionRange {
  Direct, // 0.8 -> 1.0
  CloseLeft, // 1.0 -> 1.2
  CloseRight, // 0.6 -> 0.8
  FarLeft, // 1.2 -> 2.0
  FarRight, // 0 -> 0.6
  Off // Not Intersecting
}

class VectorPosition {
  // # Reference
  final Position data;

  // @ Direction Facing
  double facing;
  double get radFacing => (facing * pi) / 180.0;
  Vector3 get posFacing => Vector3(K_DISTANCE * cos(radFacing), 0.0, K_DISTANCE * sin(radFacing));
  Sphere get sphereFacing => Sphere.centerRadius(posFacing, K_RADIUS);
  Matrix4 get rotoFacing => Matrix4.rotationY(radFacing);
  Ray get rayFacing => Ray.originDirection(Vector3.zero(), rotoFacing.transform3(Vector3(0, 0, K_DISTANCE)));

  // @ Direction Heading
  double heading;
  double get radHeading => (heading * pi) / 180.0;
  Vector3 get posHeading => Vector3(K_DISTANCE * cos(radHeading), 0.0, K_DISTANCE * sin(radHeading));
  Sphere get sphereHeading => Sphere.centerRadius(posHeading, K_RADIUS);
  Matrix4 get rotoHeading => Matrix4.rotationY(radHeading);
  Ray get rayHeading => Ray.originDirection(Vector3.zero(), rotoHeading.transform3(Vector3(0, 0, K_DISTANCE)));

  // @ Direction Anitpodal Facing
  double antiFacing;
  double get radAntiFacing => (antiFacing * pi) / 180.0;
  Vector3 get posAntiFacing => Vector3(K_DISTANCE * cos(radAntiFacing), 0.0, K_DISTANCE * sin(radAntiFacing));
  Sphere get sphereAntiFacing => Sphere.centerRadius(posAntiFacing, K_RADIUS);
  Matrix4 get rotoAntiFacing => Matrix4.rotationY(radAntiFacing);
  Ray get rayAntiFacing => Ray.originDirection(Vector3.zero(), rotoAntiFacing.transform3(Vector3(0, 0, K_DISTANCE)));

  // @ Direction Anitpodal Heading
  double antiHeading;
  double get radAntiHeading => (antiHeading * pi) / 180.0;
  Vector3 get posAntiHeading => Vector3(K_DISTANCE * cos(radAntiHeading), 0.0, K_DISTANCE * sin(radAntiHeading));
  Sphere get sphereAntiHeading => Sphere.centerRadius(posAntiHeading, K_RADIUS);
  Matrix4 get rotoAntiHeading => Matrix4.rotationY(radAntiHeading);
  Ray get rayAntiHeading => Ray.originDirection(Vector3.zero(), rotoAntiHeading.transform3(Vector3(0, 0, K_DISTANCE)));

  // @ Gyroscope Rotation
  double xGyro; // X Axis Gyro in Rad/s
  Matrix4 get rotoXGyro => Matrix4.rotationX(xGyro);

  double yGoro; // Y Axis Gyro in Rad/s
  Matrix4 get rotoYGyro => Matrix4.rotationY(yGoro);

  double zGyro; // Z Axis Gyro in Rad/s
  Matrix4 get rotoZGyro => Matrix4.rotationZ(zGyro);

  // # Factory Constructer from Direction Quadruple
  factory VectorPosition.fromQuadruple(Quadruple<double, double, Position_Accelerometer, Position_Gyroscope> data) {
    // Initialize
    double antiFacing;
    double antiHeading;

    // Set Anti Facing
    if (data.item1 < 180) {
      antiFacing = 180 - data.item1;
    } else {
      antiFacing = data.item1 - 180;
    }

    // Set Anti Heading
    if (data.item2 < 180) {
      antiHeading = 180 - data.item2;
    } else {
      antiHeading = data.item2 - 180;
    }

    // Return Position
    return VectorPosition(Position(
        facing: data.item1,
        heading: data.item2,
        accelerometer: data.item3,
        gyroscope: data.item4,
        facingAntipodal: antiFacing,
        headingAntipodal: antiHeading));
  }

  // # Constructer
  VectorPosition(this.data) {
    // Set Direction
    this.facing = data.facing;
    this.heading = data.heading;

    // Set Antipodal
    this.antiFacing = data.facingAntipodal;
    this.antiHeading = data.headingAntipodal;

    // Set Rotation
    this.xGyro = data.gyroscope.x;
    this.yGoro = data.gyroscope.y;
    this.zGyro = data.gyroscope.z;
  }

// ^ Method Checks if Vector Ray intersects with peer sphere
  bool isPointingAt(VectorPosition peer) {
    // Get Initial
    Vector3 direction = rotoFacing.transform3(Vector3(0, 0, K_DISTANCE));

    // Rotate for Peer
    peer.rotoXGyro.transform3(direction);
    peer.rotoYGyro.transform3(direction);
    peer.rotoZGyro.transform3(direction);

    // Check Collision
    var ray = Ray.originDirection(Vector3.zero(), direction);
    // Check if Heading touches facing
    var headingToFacing = ray.intersectsWithSphere(peer.sphereFacing);

    if (headingToFacing != null) {
      return true;
    }
    return false;
  }

  // ^ Method Returns Pointing At Value
  double getPointingAtValue(VectorPosition peer) {
    // Get Initial
    Vector3 direction = rotoFacing.transform3(Vector3(0, 0, K_DISTANCE));

    // Rotate for Peer
    peer.rotoXGyro.transform3(direction);
    peer.rotoYGyro.transform3(direction);
    peer.rotoZGyro.transform3(direction);

    var ray = Ray.originDirection(Vector3.zero(), direction);
    return ray.intersectsWithSphere(peer.sphereFacing);
  }

  // ^ Method Checks if Vector Ray intersects with peer sphere
  bool isFlatPointingAt(VectorPosition peer) {
    if (peer.intersectsHeading(this) && this.intersectsHeading(peer)) {
      return true;
    }
    return false;
  }

  // ^ Method Checks if Heading Intersects with Facing Sphere
  bool intersectsFacing(VectorPosition receiver, {Ray ray}) {
    if (ray != null) {
      // Check if Heading touches facing
      var headingToFacing = ray.intersectsWithSphere(receiver.sphereFacing);
      if (headingToFacing != null) {
        print("Heading to Facing: " + headingToFacing.toString() + " Gyroscope Y: " + receiver.yGoro.toString());
        return true;
      }
      return false;
    } else {
      // Check if Heading touches facing
      var headingToFacing = rayHeading.intersectsWithSphere(receiver.sphereFacing);
      if (headingToFacing != null) {
        print("Heading to Facing: " + headingToFacing.toString() + " Gyroscope Y: " + receiver.yGoro.toString());
        return true;
      }
      return false;
    }
  }

  // ^ Method Checks if Heading Intersects with Facing Antipodal Sphere
  bool intersectsAntiFacing(VectorPosition receiver) {
    // Check if Heading touches facing
    var headingToAntiFacing = rayHeading.intersectsWithSphere(receiver.sphereAntiFacing);
    if (headingToAntiFacing != null) {
      print("Heading to Anti Facing: " + headingToAntiFacing.toString());
      return true;
    }
    return false;
  }

  // ^ Method Checks if Heading Intersects with Heading Sphere
  bool intersectsHeading(VectorPosition receiver) {
    // Check if Heading touches Heading
    var headingToHeading = rayHeading.intersectsWithSphere(receiver.sphereHeading);
    if (headingToHeading != null) {
      print("Heading to Heading: " + headingToHeading.toString());
      return true;
    }
    return false;
  }

  // ^ Method Checks if Heading Intersects with Heading Antipodal Sphere
  bool intersectsAntiHeading(VectorPosition receiver) {
    // Check if Heading touches facing
    var headingToAntiHeading = rayHeading.intersectsWithSphere(receiver.sphereAntiHeading);
    if (headingToAntiHeading != null) {
      print("Heading to AntiHeading: " + headingToAntiHeading.toString());
      return true;
    }
    return false;
  }

  // ^ Method Returns offset from Another Vector
  Offset offsetAgainstVector(VectorPosition vector) {
    // Get Difference Values
    var diff = vector.getPointingAtValue(this);
    var range = withinPointerRange(diff);

    // Top of View
    if (range == VectorPositionRange.Direct || range == VectorPositionRange.CloseRight || range == VectorPositionRange.CloseLeft) {
      return Offset(180, data.topOffset);
    } else if (range == VectorPositionRange.FarRight) {
      return Offset(270, data.topOffset + 20);
    } else if (range == VectorPositionRange.FarLeft) {
      return Offset(90, data.topOffset + 20);
    } else {
      return Offset(340, data.topOffset + 20);
    }
  }

  // ^ Method Checks if Value is Within Pointer Range
  VectorPositionRange withinPointerRange(double diff) {
    if (diff != null) {
      if (diff <= 0.6) {
        return VectorPositionRange.FarRight;
      } else if (diff > 0.6 && diff <= 0.8) {
        return VectorPositionRange.CloseRight;
      } else if (diff > 0.8 && diff <= 1.0) {
        return VectorPositionRange.Direct;
      } else if (diff > 1.0 && diff <= 1.2) {
        return VectorPositionRange.CloseLeft;
      } else if (diff > 1.2 && diff <= 2.0) {
        return VectorPositionRange.FarLeft;
      } else {
        return VectorPositionRange.Off;
      }
    } else {
      return VectorPositionRange.Off;
    }
  }

  // # Returns String of Data
  @override
  String toString() {
    return {
      "Facing": {
        "Direction": facing,
        "Radians": radFacing,
        "Position": {
          "X": cos(radFacing),
          "Y": 0,
          "Z": sin(radFacing),
        },
      },
      "Antipodal Facing": {
        "Direction": antiFacing,
        "Radians": radAntiFacing,
        "Position": {
          "X": cos(radAntiFacing),
          "Y": 0,
          "Z": sin(radAntiFacing),
        },
      },
      "Heading": {
        "Direction": heading,
        "Radians": radHeading,
        "Position": {
          "X": cos(radHeading),
          "Y": 0,
          "Z": sin(radHeading),
        },
      },
      "Antipodal Heading": {
        "Direction": antiHeading,
        "Radians": radAntiHeading,
        "Position": {
          "X": cos(radAntiHeading),
          "Y": 0,
          "Z": sin(radAntiHeading),
        },
      },
      "Rotation": {
        "X": xGyro,
        "Y": yGoro,
        "Z": zGyro,
      }
    }.toString();
  }
}
