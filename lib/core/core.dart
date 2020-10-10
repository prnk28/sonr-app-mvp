// Core
export 'pathfinder.dart';
export 'dart:async';
export 'dart:convert';
export 'dart:io' hide Socket;
export 'dart:math';
export 'filetype.dart';
export 'package:flutter/services.dart';
export 'design/design.dart';

// Dev Libraries
export 'package:logger/logger.dart';
export 'peer.dart';
export 'package:tuple/tuple.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sonar_app/core/design/design.dart';
import 'dart:math';

import 'package:tuple/tuple.dart';
export 'package:bloc/bloc.dart';

// Networking Libraries
export 'package:socket_io_client/socket_io_client.dart';

// Device Libraries
export 'package:flutter_sensor_compass/flutter_sensor_compass.dart';
export 'package:sensors/sensors.dart';
export 'package:soundpool/soundpool.dart';

// **************************** //
// ** Global Logging Package ** //
// **************************** //
Logger log = Logger();

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
