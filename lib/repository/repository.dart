// Directory Exports
export 'session.dart';
export 'connection.dart';
export 'localdata.dart';
export "package:flutter_webrtc/webrtc.dart";
export 'package:chunked_stream/chunked_stream.dart';
export 'dart:typed_data';
export 'package:hive/hive.dart';
export 'package:path/path.dart';
export 'package:path_provider/path_provider.dart';

// Socket.io Client
import 'package:socket_io_client/socket_io_client.dart';
import 'package:sonar_app/repository/session.dart';

import 'localdata.dart';

// Constants for WebRTC
const CHUNK_SIZE = 16000; // MTU in Bytes
const CHUNKS_PER_ACK = 64;

const Map<String, dynamic> SOCKET_TRANSPORT = <String, dynamic>{
  'transports': ['websocket'],
};

// Initialize Repositories
Socket socket = io('http://match.sonr.io', SOCKET_TRANSPORT);
RTCSession rtcSession = new RTCSession();
LocalData localData = new LocalData();
