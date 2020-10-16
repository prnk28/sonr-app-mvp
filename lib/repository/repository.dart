// Directory Exports
export 'localdata.dart';
export 'session.dart';
export 'connection.dart';
export "package:flutter_webrtc/webrtc.dart";
export 'package:chunked_stream/chunked_stream.dart';
export 'dart:typed_data';
export 'package:hive/hive.dart';

// Socket.io Client
import 'package:sonar_app/repository/localdata.dart';

// ** HiveDB Box Names **
const String PREFERENCES_BOX = "preferencesBox";
const String PROFILE_BOX = "profileBox";

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

// Handler type for handling the event emitted by an
typedef dynamic EventHandler<T>(T data);

// Chunking Constants
const CHUNK_SIZE = 16000;
const CHUNKS_PER_ACK = 64;

// Initialize Repo
LocalData localData = new LocalData();
