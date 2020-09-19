// Directory Exports
export 'session.dart';
export 'connection.dart';
export 'device.dart';
export 'local_data.dart';
export "package:flutter_webrtc/webrtc.dart";
export 'package:chunked_stream/chunked_stream.dart';

// Socket.io Client
import 'package:socket_io_client/socket_io_client.dart';

Socket socket = io('http://match.sonr.io', <String, dynamic>{
  'transports': ['websocket'],
});
