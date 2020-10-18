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
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
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
enum DeviceType { ANDROID, FUCHSIA, IOS, LINUX, MACOS, WINDOWS }

enum Status {
  Disconnected,
  Active,
  Searching,
  Pending,
  Requested,
  Transferring
}

Logger log = Logger();
Uuid uuid = Uuid();
Size screenSize;

getPlatform() {
  return enumFromString(
      Platform.operatingSystem.toUpperCase(), DeviceType.values);
}

// ****************** //
// ** Enum Methods ** //
// ****************** //
// Enum Value Converstion to String
String enumAsString(Object o) => o.toString().split('.').last;

// String Conversion to Enum Value
T enumFromString<T>(String key, Iterable<T> values) => values.firstWhere(
      (v) => v != null && key == enumAsString(v),
      orElse: () => null,
    );

// ********************************
// ** Read Local Data of Assets ***
// ********************************
Future<Uint8List> getBytesFromPath(String path) async {
  Uri myUri = Uri.parse(path);
  File audioFile = new File.fromUri(myUri);
  Uint8List bytes;
  await audioFile.readAsBytes().then((value) {
    bytes = Uint8List.fromList(value);
    log.i('reading of bytes is completed');
  }).catchError((onError) {
    log.w(
        'Exception Error while reading audio from path:' + onError.toString());
  });
  return bytes;
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

// **************************
// ** Write File to a Path **
// **************************
Future<File> writeToFile(Uint8List data, String path) {
  final buffer = data.buffer;
  return new File(path)
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}

// ********************
// ** Math Functions **
// ********************
num directionToRads(num deg) {
  return (directionToDegrees(deg) * pi) / 180.0;
}

Alignment directionToAlignment(double r, double deg) {
  // Calculate radians
  double radAngle = directionToRads(deg);

  double x = cos(radAngle) * r;
  double y = sin(radAngle) * r;
  return Alignment(x, y);
}

double directionToDegrees(double direction) {
  if (direction + 90 > 360) {
    return direction - 270;
  } else {
    return direction + 90;
  }
}
