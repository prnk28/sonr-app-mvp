import 'core_ws.dart';
import 'dart:convert';
import 'client_ws.dart';

class SonarWSMessenger {
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

  sendApprove(){
    ///
    /// Send the action to the server
    /// To send the message, we need to serialize the JSON
    ///
    sockets.send(json.encode({
      "action": "approve",
    }));
  }

  sendDecline(){
    ///
    /// Send the action to the server
    /// To send the message, we need to serialize the JSON
    ///
    sockets.send(json.encode({
      "action": "decline",
    }));
  }
}