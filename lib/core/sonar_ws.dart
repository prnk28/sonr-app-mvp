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
  // Initialize Variables
  static final WSClient _wsClient = new WSClient._internal();

  factory WSClient() {
    return _wsClient;
  }

  WSClient._internal() {
    sockets.addListener(_onMessageReceived);
  }

  initialize(){
    sockets.initCommunication();
  }

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

  _onMessageReceived(serverMessage) {
    ///
    /// As messages are sent as a String
    /// let's deserialize it to get the corresponding
    /// JSON object
    ///
    Map message = json.decode(serverMessage);
    log(message["code"]);
    switch (message["code"]) {

      ///
      /// When the communication is established, the server
      /// returns the unique identifier of the player.
      /// Let's record it
      ///
      case '00':
        sonar.wsID = message["data"]["id"];
        print(message);
        break;

      ///
      /// For any other incoming message, we need to
      /// dispatch it to all the listeners
      ///
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
