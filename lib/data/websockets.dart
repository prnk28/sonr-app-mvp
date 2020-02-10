import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:sonar_app/controllers/controllers.dart';
import 'package:web_socket_channel/io.dart';

// Application-level global variable to access the WebSockets
Websockets sonarWS = new Websockets();

// Websockets Address
const String _SERVER_ADDRESS = "ws://match.sonr.io";
class Websockets {
  // **************************
  // ** Class Initialization **
  // **************************
  // Initialize
  static final Websockets _sockets = new Websockets._internal();

  // Constructer
  factory Websockets() {
    return _sockets;
  }
  
  Websockets._internal();

  // The WebSocket "open" channel
  IOWebSocketChannel channel;

  // Is the connection established?
  bool _isOn = false;

  // Socket Listeners
  ObserverList<Function> _listeners = new ObserverList<Function>();

  // ****************************
  // ** Start WS Communication **
  // ****************************
  connect() async {
    // Just in case, close any previous communication
    disconnect();

    // Open a new WebSocket communication
    try {
      // Initialize Channel
      channel = new IOWebSocketChannel.connect(_SERVER_ADDRESS);

      // Generic Callback
      channel.stream.listen(_onReceptionOfMessageFromServer);
    } catch (e) {
      log("Error Has Occurred");
    }
  }

  // ****************************
  // ** Send Message to Server **
  // ****************************
  send(String message) {
    // Validate Channel
    if (channel != null) {
      // Verify Connection
      if (channel.sink != null && _isOn) {
        // Send Message to Channel
        channel.sink.add(message);
      }
    }
  }

  // **********************************
  // ** Message Callbacks for Stream **
  // **********************************
  addListener(Function callback){
    _listeners.add(callback);
  }

  removeListener(Function callback){
    _listeners.remove(callback);
  }

  // *******************************
  // ** Message Received Callback **
  // *******************************
  _onReceptionOfMessageFromServer(serverMessage) {
    // Server Connected
    _isOn = true;

    // Convert server message to map
    Message message = Message.incoming(serverMessage);

    // Send Message to All Listeners
    _listeners.forEach((Function callback){
      callback(message);
    });
  }

  // ********************************
  // ** Close Server Communication **
  // ********************************
  disconnect() {
    if (channel != null) {
      if (channel.sink != null) {
        channel.sink.close();
        _isOn = false;
      }
    }
  }
}
