import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'websockets.dart';

///
/// Again, application-level global variable
///
SonarCommunication sonar = new SonarCommunication();

class SonarCommunication {
  static final SonarCommunication _sonar = new SonarCommunication._internal();
  ///
  /// Before the "join" action, the player has no unique ID
  ///
  String _clientId = "";

  factory SonarCommunication(){
    return _sonar;
  }

  SonarCommunication._internal(){
    ///
    /// Let's initialize the WebSockets communication
    ///
    //sockets.initCommunication();

    ///
    /// and ask to be notified as soon as a message comes in
    ///
    sockets.addListener(_onMessageReceived);
  }

  initialize(){
    sockets.initCommunication();
  }

  /// ----------------------------------------------------------
  /// Common handler for all received messages, from the server
  /// ----------------------------------------------------------
  _onMessageReceived(serverMessage){
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
        _clientId = message["data"];
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

  /// ----------------------------------------------------------
  /// Common method to send requests to the server
  /// ----------------------------------------------------------
  send(String action, Map data){
    ///
    /// Send the action to the server
    /// To send the message, we need to serialize the JSON 
    ///
    sockets.send(json.encode({
      "action": action,
      "data": data
    }));
  }

    sendRequest(Map data, Map request){
    ///
    /// Send the action to the server
    /// To send the message, we need to serialize the JSON
    ///
    sockets.send(json.encode({
      "action": "request",
      "data": data,
      "request": request
    }));
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