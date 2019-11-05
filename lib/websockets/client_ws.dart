import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'client_info.dart';
import 'core_ws.dart';
import 'messenger_ws.dart';

///
/// Again, application-level global variable
///
SonarWSClient sonar = new SonarWSClient();

class SonarWSClient {
  // Initialize Variables
  static final SonarWSClient _sonar = new SonarWSClient._internal();
  static SonarWSMessenger messenger;
  static SonarClientInfo clientInfo;

  factory SonarWSClient(){
    return _sonar;
  }

  SonarWSClient._internal(){
    sockets.initCommunication();
    sockets.addListener(_onMessageReceived);
    messenger = new SonarWSMessenger();
    clientInfo = new SonarClientInfo();
  }


  /// ----------------------------------------------------------
  /// Common handler for all received messages, from the server
  /// ----------------------------------------------------------
  _onMessageReceived(serverMessage) {
    ///
    /// As messages are sent as a String
    /// let's deserialize it to get the corresponding
    /// JSON object
    ///
    Map message = json.decode(serverMessage);

    switch(message["action"]){
      ///
      /// When the communication is established, the server
      /// returns the unique identifier of the player.
      /// Let's record it
      ///
      case 'connect':
        id = message["data"]["id"];
        print(message);
        break;

      ///
      /// For any other incoming message, we need to
      /// dispatch it to all the listeners
      ///
      default:
        _listeners.forEach((Function callback){
          print(message);
          callback(message);
        });
        break;
    }
  }

  /// ==========================================================
  ///
  /// Listeners to allow the different pages to be notified
  /// when messages come in
  ///
  ObserverList<Function> _listeners = new ObserverList<Function>();

  /// ---------------------------------------------------------
  /// Adds a callback to be invoked in case of incoming
  /// notification
  /// ---------------------------------------------------------
  addListener(Function callback){
    _listeners.add(callback);
  }
  removeListener(Function callback){
    _listeners.remove(callback);
  }

// Closes Communication with Websocket
  close(){
    sockets.reset();
  }
}