import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:web_socket_channel/io.dart';

class Websockets {
  // **************************
  // ** Class Initialization **
  // **************************
  // Server Address
  final String serverAddress;

  // Initialize
  Websockets._internal(this.serverAddress);

  // Constructer
  factory Websockets(String serverAddress) {
    Websockets _sockets = new Websockets._internal(serverAddress);
    return _sockets;
  }

  // The WebSocket "open" channel
  IOWebSocketChannel _channel;

  // WS Server Stream
  Stream messages;

  // Is the connection established?
  bool _isOn = false;

  // ****************************
  // ** Start WS Communication **
  // ****************************
  connect() async {
    // Just in case, close any previous communication
    disconnect();

    // Open a new WebSocket communication
    try {
      // Initialize Channel
      _channel = new IOWebSocketChannel.connect(serverAddress);
      log("Connected to Server");

      // Start Stream
      messages = _channel.stream;

      // Generic Callback
      _channel.stream.listen(_onReceptionOfMessageFromServer);
    } catch (e) {
      log("Error Has Occurred");
    }
  }

  // ****************************
  // ** Send Message to Server **
  // ****************************
  send(String message) {
    // Validate Channel
    if (_channel != null) {
      // Verify Connection
      if (_channel.sink != null && _isOn) {
        // Send Message to Channel
        _channel.sink.add(message);
      }
    }
  }

  // *******************************
  // ** Message Received Callback **
  // *******************************
  _onReceptionOfMessageFromServer(serverMessage) {
    // Server Connected
    _isOn = true;

    // Convert server message to map
    Map message = json.decode(serverMessage);
    print(message);
  }

  // ********************************
  // ** Close Server Communication **
  // ********************************
  disconnect() {
    if (_channel != null) {
      if (_channel.sink != null) {
        _channel.sink.close();
        _isOn = false;
      }
    }
  }
}
