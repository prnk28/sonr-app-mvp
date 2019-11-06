// Remote Packages
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';

// Local Classes
import '../core/sonar_client.dart';
import '../model/direction_model.dart';
import '../model/location_model.dart';
import '../model/profile_model.dart';
import '../utils/ws_util.dart';

class WSClient {
// ==================================
// SONAR-WS-CLIENT Initialization
// ==================================
  static final WSClient _wsClient = new WSClient._internal();

  factory WSClient() {
    return _wsClient;
  }

  WSClient._internal() {
    sockets.addListener(_onMessageReceived);
  }

  initialize() {
    sockets.initCommunication();
  }

// ==================================
// SONAR-WS-CLIENT Broadcaster
// ==================================
  msgAuthorize(bool authStatus) {
    // Send msg based on bool
    if (authStatus) {
      // Action: AUTHORIZE.TRUE To Server
      sockets.send(jsonEncode({'action': "AUTHORIZE.TRUE"}));
    } else {
      // Action: AUTHORIZE.FALSE To Server
      sockets.send(jsonEncode({'action': "AUTHORIZE.FALSE"}));
    }
  }

  msgCancel() {}

  msgJoin(
      ProfileModel profile, DirectionModel direction, LocationModel location) {
    // Setup Data Map
    var data = {
      'profile': profile.toJSON(),
      'direction': profile.toJSON(),
      'location': profile.toJSON(),
    };

    // Action: JOIN To Server
    sockets.send(jsonEncode({'action': "JOIN", 'data': data}));
  }

  msgReceive(DirectionModel direction) {
    // Action: RECEIVE To Server
    sockets.send(jsonEncode({'action': "RECEIVE", 'data': direction.toJSON()}));
  }

  msgReceiveSearch(DirectionModel direction) {
    // Action: RECEIVE.SEARCH To Server
    sockets.send(
        jsonEncode({'action': "RECEIVE.SEARCH", 'data': direction.toJSON()}));
  }

  msgSend(DirectionModel direction) {
    // Action: SEND To Server
    sockets.send(jsonEncode({'action': "SEND", 'data': direction.toJSON()}));
  }

  msgSendSearch(DirectionModel direction) {
    // Action: SEND.SEARCH To Server
    sockets.send(
        jsonEncode({'action': "SEND.SEARCH", 'data': direction.toJSON()}));
  }

  msgZero() {
    // Action: ZERO To Server
    sockets.send(jsonEncode({'action': "ZERO"}));
  }

// ==================================
// SONAR-WS-CLIENT Interpretater
// ==================================
  _onMessageReceived(serverMessage) {
    // Convert server message to map
    Map message = json.decode(serverMessage);
    log(message["code"].toString());

    // Switch by Sonar Status Code
    switch (message["code"]) {
      // ** ============================ **
      // ** CODE: 0, EVENT: Initialization
      case 0:
        sonar.wsID = message["data"]["id"].toString();
        print(message);
        break;

      // ** ========================== **
      // ** CODE: 1, EVENT: Join Lobby
      case 1:
        sonar.wsID = message["data"]["id"].toString();
        print(message);
        break;

      // ** ========================== **
      // ** CODE: 2, EVENT: Create Lobby
      case 2:
        sonar.wsID = message["data"]["id"].toString();
        print(message);
        break;

      // ** ========================== **
      // ** CODE: 3, EVENT: Zero Position
      case 3:
        sonar.wsID = message["data"]["id"].toString();
        print(message);
        break;

      // ** ========================== **
      // ** CODE: 10, EVENT: Send
      case 10:
        sonar.wsID = message["data"]["id"].toString();
        print(message);
        break;

      // ** ========================== **
      // ** CODE: 11, EVENT: Send.Search
      case 11:
        sonar.wsID = message["data"]["id"].toString();
        print(message);
        break;

      // ** ========================== **
      // ** CODE: 12, EVENT: Send.Found
      case 12:
        sonar.wsID = message["data"]["id"].toString();
        print(message);
        break;

      // ** ========================== **
      // ** CODE: 20, EVENT: Receive
      case 20:
        sonar.wsID = message["data"]["id"].toString();
        print(message);
        break;

      // ** ========================== **
      // ** CODE: 21, EVENT: Receive.Search
      case 21:
        sonar.wsID = message["data"]["id"].toString();
        print(message);
        break;

      // ** ========================== **
      // ** CODE: 22, EVENT: Receive.Found
      case 22:
        sonar.wsID = message["data"]["id"].toString();
        print(message);
        break;

      // ** ========================== **
      // ** CODE: 30, EVENT: WebRTC Start
      case 30:
        sonar.wsID = message["data"]["id"].toString();
        print(message);
        break;

      // ** ========================== **
      // ** CODE: 31, EVENT: WebRTC Fail
      case 31:
        sonar.wsID = message["data"]["id"].toString();
        print(message);
        break;

      // ** ========================== **
      // ** CODE: 32, EVENT: WebRTC Done
      case 32:
        sonar.wsID = message["data"]["id"].toString();
        print(message);
        break;

      // ** ========================== **
      // ** CODE: 40, EVENT: Cancel
      case 40:
        sonar.wsID = message["data"]["id"].toString();
        print(message);
        break;

      // ** ========================== **
      // ** CODE: 41, EVENT: Timeout
      case 41:
        sonar.wsID = message["data"]["id"].toString();
        print(message);
        break;

      // ** ========================== **
      // ** CODE: 43, EVENT: WebRTC Establishment Failed
      case 43:
        sonar.wsID = message["data"]["id"].toString();
        print(message);
        break;

      // ** ========================== **
      // ** CODE: 44, EVENT: Server Down/Maintenance
      case 44:
        sonar.wsID = message["data"]["id"].toString();
        print(message);
        break;

      // ** ========================== **
      // ** CODE: 50, EVENT: Authorization Successful
      case 50:
        sonar.wsID = message["data"]["id"].toString();
        print(message);
        break;

      // ** ========================== **
      // ** CODE: 51, EVENT: Authorization Pending
      case 51:
        sonar.wsID = message["data"]["id"].toString();
        print(message);
        break;

      // ** ========================== **
      // ** CODE: 52, EVENT: Authorization Fail
      case 52:
        sonar.wsID = message["data"]["id"].toString();
        print(message);
        break;

      // ** ============================ **
      // ** Other Messages: Dispatch to Listeners.
      default:
        _listeners.forEach((Function callback) {
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
  addListener(Function callback) {
    _listeners.add(callback);
  }

  removeListener(Function callback) {
    _listeners.remove(callback);
  }

  // Closes Communication with Websocket
  close() {
    sockets.reset();
  }
}
