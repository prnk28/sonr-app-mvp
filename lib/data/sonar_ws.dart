import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';

///
/// Application-level global variable to access the WebSockets
///
SonarWS sonarWS = new SonarWS();

///
/// Put your WebSockets server IP address and port number
///
const String _SERVER_ADDRESS = "ws://match.sonr.io";

class SonarWS {
  static final SonarWS _sockets = new SonarWS._internal();

  factory SonarWS(){
    return _sockets;
  }

  SonarWS._internal();

  ///
  /// The WebSocket "open" channel
  ///
  IOWebSocketChannel channel;

  ///
  /// Is the connection established?
  ///
  bool _isOn = false;

  /// ----------------------------------------------------------
  /// Initialization the WebSockets connection with the server
  /// ----------------------------------------------------------
  connect() async {
    ///
    /// Just in case, close any previous communication
    ///
    reset();

    ///
    /// Open a new WebSocket communication
    ///
    try {
      channel = new IOWebSocketChannel.connect(_SERVER_ADDRESS);
      log("Connected to Server");
      ///
      /// Start listening to new notifications / messages
      ///
      channel.stream.listen(_onReceptionOfMessageFromServer);
    } catch(e){
      log("Error Has Occurred");
      ///
      /// General error handling
      /// TODO
      ///
    }
  }

  /// ----------------------------------------------------------
  /// Closes the WebSocket communication
  /// ----------------------------------------------------------
  reset(){
    if (channel != null){
      if (channel.sink != null){
        channel.sink.close();
        _isOn = false;
      }
    }
  }

  /// ---------------------------------------------------------
  /// Sends a message to the server
  /// ---------------------------------------------------------
  send(String message){
    // print(message);
    if (channel != null){
      if (channel.sink != null && _isOn){
        channel.sink.add(message);
      }
    }
  }
  /// ----------------------------------------------------------
  /// Callback which is invoked each time that we are receiving
  /// a message from the server
  /// ----------------------------------------------------------
  _onReceptionOfMessageFromServer(serverMessage){
    _isOn = true;
    // Convert server message to map
    Map message = json.decode(serverMessage);
    print(message);
  }
}