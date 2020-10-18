// Core
export 'dart:async';
export 'dart:convert';
export 'dart:io' hide Socket;
export 'dart:math';
export 'package:flutter/services.dart';

// Dev Libraries
export 'package:logger/logger.dart';
export 'package:tuple/tuple.dart';
export 'package:bloc/bloc.dart';

// Device Libraries
export 'package:flutter_sensor_compass/flutter_sensor_compass.dart';
export 'package:sensors/sensors.dart';
export 'package:geolocator/geolocator.dart' hide Codec;
export 'package:soundpool/soundpool.dart';
export 'package:graph_collection/graph.dart';
export 'package:path/path.dart';
export 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'package:logger/logger.dart';
import 'package:sonar_app/design/design.dart';
import 'package:sonar_app/repository/repository.dart';
import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sonar_app/screens/screens.dart';

part 'routing.dart';
part 'events.dart';
part 'olc.dart';

// ******************************* //
// ** Global Package References ** //
// ******************************* //
enum Device { ANDROID, FUCHSIA, IOS, LINUX, MACOS, WINDOWS }

Logger log = Logger();
Uuid uuid = Uuid();
Size screenSize;

// ********************
// ** Math Functions **
// ********************
num directionToRads(num deg) {
  return (directionToDegrees(deg) * pi) / 180.0;
}

double directionToDegrees(double direction) {
  if (direction + 90 > 360) {
    return direction - 270;
  } else {
    return direction + 90;
  }
}

Alignment directionToAlignment(double r, double deg) {
  // Calculate radians
  double radAngle = directionToRads(deg);

  double x = cos(radAngle) * r;
  double y = sin(radAngle) * r;
  return Alignment(x, y);
}

// ********************* //
// ** Enum Extensions ** //
// ********************* //
extension DeviceExtension on Device {
  asString() {
    this.toString().split('.').last;
  }

  Device fromString(key) {
    return Device.values.firstWhere(
      (v) => v != null && key == v.asString(),
      orElse: () => null,
    );
  }

  Device getPlatform() {
    Device device;
    device.fromString(Platform.operatingSystem.toUpperCase());
    return device;
  }
}

extension FileTypeExtension on FileType {
  asString() {
    this.toString().split('.').last;
  }

  FileType fromString(key) {
    return FileType.values.firstWhere(
      (v) => v != null && key == v.asString(),
      orElse: () => null,
    );
  }
}

extension StatusExtension on Status {
  asString() {
    this.toString().split('.').last;
  }

  Status fromString(key) {
    return Status.values.firstWhere(
      (v) => v != null && key == v.asString(),
      orElse: () => null,
    );
  }
}
