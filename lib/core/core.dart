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
export 'package:geolocator/geolocator.dart';
export 'package:soundpool/soundpool.dart';
export 'package:graph_collection/graph.dart';
export 'package:path/path.dart';
export 'package:path_provider/path_provider.dart';
export 'package:posthog_flutter/posthog_flutter.dart';

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

export 'sonrfile.dart';
part 'routing.dart';
part 'events.dart';
part 'olc.dart';

// ******************************* //
// ** Global Package References ** //
// ******************************* //
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

// ****************************************
// ** Get File Object from Assets Folder **
// ****************************************
Future<File> getAssetFileByPath(String path) async {
  // Get Application Directory
  Directory directory = await getApplicationDocumentsDirectory();

  // Get File Extension and Set Temp DB Extenstion
  var dbPath = join(directory.path, "temp" + extension(path));

  // Get Byte Data
  ByteData data = await rootBundle.load(path);

  // Get Bytes as Int
  List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

  // Return File Object
  return await File(dbPath).writeAsBytes(bytes);
}

// ********************* //
// ** Enum Extensions ** //
// ********************* //
// Initialize FileTypes
initFileType() async {
  var json = await rootBundle.loadString("assets/data/filetype.json");
  Metadata.fileTypes = jsonDecode(json);
}

// Enum Value Converstion to String
String enumAsString(Object o) => o.toString().split('.').last;

// String Conversion to Enum Value
T enumFromString<T>(String key, Iterable<T> values) => values.firstWhere(
      (v) => v != null && key == enumAsString(v),
      orElse: () => null,
    );
