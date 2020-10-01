// Directory Exports
export 'session.dart';
export 'hiveprovider.dart';
export "package:flutter_webrtc/webrtc.dart";
export 'package:chunked_stream/chunked_stream.dart';
export 'dart:typed_data';
export 'package:hive/hive.dart';
export 'package:path/path.dart';
export 'package:path_provider/path_provider.dart';

// Socket.io Client
import 'package:socket_io_client/socket_io_client.dart';
import 'package:sonar_app/repository/session.dart';

import 'hiveprovider.dart';

// ** Constants for WebRTC **
const CHUNK_SIZE = 16000; // MTU in Bytes
const CHUNKS_PER_ACK = 64;

// ** Socket Transport Settings **
const Map<String, dynamic> SOCKET_TRANSPORT = <String, dynamic>{
  'transports': ['websocket'],
};

// ** WebRTC Transport Settings **
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

// ** HiveDB Box Names **
const String CONTACT_BOX = "contactBox";
const String PREFERENCES_BOX = "preferencesBox";
const String PROFILE_BOX = "profileBox";

// File Box's
const String FILE_BOX = "fileBox";

// Initialize Repositories
Socket socket = io('http://match.sonr.io', SOCKET_TRANSPORT);
RTCSession rtcSession = new RTCSession();
HiveProvider localData = new HiveProvider();
