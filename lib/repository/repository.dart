// Directory Exports
export "package:flutter_webrtc/webrtc.dart";
export 'package:chunked_stream/chunked_stream.dart';
export 'dart:typed_data';
export 'package:hive/hive.dart';
export 'package:socket_io_client/socket_io_client.dart';

export 'peer.dart';
export 'localdata.dart';
export 'session.dart';

// Clients
import 'package:socket_io_client/socket_io_client.dart';
import 'package:sonar_app/repository/localdata.dart';

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

// ** Start Repositories **
LocalData localData = new LocalData();
Socket socket = io('http://match.sonr.io', <String, dynamic>{
  'transports': ['websocket'],
  'autoConnect': false
});
