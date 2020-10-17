// Directory Exports
export 'localdata.dart';
export 'session.dart';
export "package:flutter_webrtc/webrtc.dart";
export 'package:chunked_stream/chunked_stream.dart';
export 'dart:typed_data';
export 'package:hive/hive.dart';

// Socket.io Client
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/repository/localdata.dart';

// ** HiveDB Box Constants **
const PREFERENCES_BOX = "preferencesBox";
const PROFILE_BOX = "profileBox";

// * Chunking Constants **
const CHUNK_SIZE = 16000;
const CHUNKS_PER_ACK = 64;

// ***********************
// * Transport Settings **
// ***********************
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

// ***********************
// * Start Repositories **
// ***********************
LocalData localData = new LocalData();
Socket socket = io('http://match.sonr.io', <String, dynamic>{
  'transports': ['websocket'],
});
