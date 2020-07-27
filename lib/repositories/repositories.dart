// Directory Exports
export 'session.dart';
export 'connection.dart';
export 'device.dart';
export "package:flutter_webrtc/webrtc.dart";
export 'package:chunked_stream/chunked_stream.dart';

// Socket.io Client
import 'package:socket_io_client/socket_io_client.dart';

Socket socket = io('http://match.sonr.io', <String, dynamic>{
  'transports': ['websocket'],
});

// Turn Server Configuration
const ICE_CONFIG = {
  'iceServers': [
    //{"url": "stun:stun.l.google.com:19302"},
    {'urls': 'stun:165.227.86.78:3478', 'username': 'test', 'password': 'test'}
  ]
};

// Data Channel Streaming Settings
const DC_SETTINGS = {
  'mandatory': {
    'OfferToReceiveAudio': false,
    'OfferToReceiveVideo': false,
  },
  'optional': [],
};
