// Directory Exports
export "package:flutter_webrtc/webrtc.dart";
export 'package:chunked_stream/chunked_stream.dart';
export 'dart:typed_data';
export 'package:hive/hive.dart';
export 'package:socket_io_client/socket_io_client.dart';

export 'circle.dart';
export 'session.dart';
export 'traffic.dart';

// Clients
import 'package:socket_io_client/socket_io_client.dart';

// * Chunking Constants **
const CHUNK_SIZE = 16000;
const CHUNKS_PER_ACK = 64;

// * WebRTC Settings **
// ICE RTCConfiguration Map
const RTC_CONFIG = {
  'iceServers': [
    //{"url": "stun:stun.l.google.com:19302"},
    {'urls': 'stun:165.227.86.78:3478', 'username': 'test', 'password': 'test'}
  ]
};

// Create DC Constraints
const RTC_CONSTRAINTS = {
  'mandatory': {
    'OfferToReceiveAudio': false,
    'OfferToReceiveVideo': false,
  },
  'optional': [],
};

// ** Start Socket **
Socket socket = io('http://match.sonr.io', <String, dynamic>{
  'transports': ['websocket'],
  'autoConnect': false
});
