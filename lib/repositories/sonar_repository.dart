// Remote Packages
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';

// Local Classes
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/data/data.dart';

class SonarRepository {
// ==================================
// SONAR-WS-CLIENT Initialization
// ==================================
  static final SonarRepository _wsClient = new SonarRepository._internal();

  factory SonarRepository() {
    return _wsClient;
  }

  SonarRepository._internal();

  initialize() {
    sonarWS.connect();
  }

// ==================================
// SONAR-WS-CLIENT Broadcaster
// ==================================
  msgAuthorize(bool authStatus) {
    // Send msg based on bool
    if (authStatus) {
      // Action: AUTHORIZE.TRUE To Server
      sonarWS.send(jsonEncode({'action': "AUTHORIZE.TRUE"}));
    } else {
      // Action: AUTHORIZE.FALSE To Server
      sonarWS.send(jsonEncode({'action': "AUTHORIZE.FALSE"}));
    }
  }

  msgCancel() {}

  msgJoin() {
    // Set Location
    // LocationUtility.getCurrentLocation().then((location) {
    // ProfileModel profile =
    //             new ProfileModel("firstName", "lastName", "profilePicture");

    // Set Data
    // var data = {
    //   'profile': profile.toJSON(),
    //   'location': location.toJSON()
    // };

    // // Action: JOIN To Server
    // sockets.send(jsonEncode({'action': "JOIN", 'data': data}));
    // });
  }

  msgReceive(Direction direction) {
    // Action: RECEIVE To Server
    var data = {
      'direction': direction.toJSON()
    };
    sonarWS.send(jsonEncode({'action': "RECEIVE", 'data': data}));
  }

  msgReceiveSearch(Direction direction) {
    // Action: RECEIVE.SEARCH To Server
    var data = {
      'direction': direction.toJSON()
    };
    sonarWS.send(
        jsonEncode({'action': "RECEIVE.SEARCH", 'data': data}));
  }

  msgSend(Direction direction) {
    // Action: SEND To Server
    var data = {
      'direction': direction.toJSON()
    };
    print(jsonEncode({'action': "SEND", 'data': data}));
    sonarWS.send(jsonEncode({'action': "SEND", 'data': data}));
  }

  msgSendSearch(Direction direction) {
    // Action: SEND.SEARCH To Server
    var data = {
      'direction': direction.toJSON()
    };
    sonarWS.send(
        jsonEncode({'action': "SEND.SEARCH", 'data': data}));
  }

  msgZero() {
    // Action: ZERO To Server
    sonarWS.send(jsonEncode({'action': "ZERO"}));
  }

// ==================================
// SONAR-WS-CLIENT Interpretater
// ==================================
  _onMessageReceived(serverMessage) {

    // // Switch by Sonar Status Code
    // switch (message["code"]) {
    //   // ** ============================ **
    //   // ** CODE: 0, EVENT: Initialization
    //   case 0:
    //     sonar.wsID = message["data"]["id"].toString();
    //     print(message);
    //     break;

    //   // ** ========================== **
    //   // ** CODE: 1, EVENT: Join Lobby
    //   case 1:
    //     sonar.wsID = message["data"]["id"].toString();
    //     sonar.wsStatus = SonarState.ZERO;
    //     print(message);
    //     break;

    //   // ** ========================== **
    //   // ** CODE: 2, EVENT: Create Lobby
    //   case 2:
    //     sonar.wsID = message["data"]["id"].toString();
    //     sonar.wsStatus = SonarState.ZERO;
    //     print(message);
    //     break;

    //   // ** ========================== **
    //   // ** CODE: 3, EVENT: Zero Position
    //   case 3:
    //     sonar.wsID = message["data"]["id"].toString();
    //     sonar.wsStatus = SonarState.ZERO;
    //     print(message);
    //     break;

    //   // ** ========================== **
    //   // ** CODE: 10, EVENT: Send
    //   case 10:
    //     sonar.wsID = message["data"]["id"].toString();
    //     sonar.wsStatus = SonarState.SEND;
    //     print(message);
    //     break;

    //   // ** ========================== **
    //   // ** CODE: 11, EVENT: Send.Search
    //   case 11:
    //     sonar.wsID = message["data"]["id"].toString();
    //     sonar.wsStatus = SonarState.SEND_SEARCH;
    //     print(message);
    //     break;

    //   // ** ========================== **
    //   // ** CODE: 12, EVENT: Send.Found
    //   case 12:
    //     sonar.wsID = message["data"]["id"].toString();
    //     print(message);
    //     break;

    //   // ** ========================== **
    //   // ** CODE: 20, EVENT: Receive
    //   case 20:
    //     sonar.wsID = message["data"]["id"].toString();
    //     sonar.wsStatus = SonarState.RECEIVE;
    //     print(message);
    //     break;

    //   // ** ========================== **
    //   // ** CODE: 21, EVENT: Receive.Search
    //   case 21:
    //     sonar.wsID = message["data"]["id"].toString();
    //     sonar.wsStatus = SonarState.RECEIVE_SEARCH;
    //     print(message);
    //     break;

    //   // ** ========================== **
    //   // ** CODE: 22, EVENT: Receive.Found
    //   case 22:
    //     sonar.wsID = message["data"]["id"].toString();
    //     print(message);
    //     break;

    //   // ** ========================== **
    //   // ** CODE: 30, EVENT: WebRTC Start
    //   case 30:
    //     sonar.wsID = message["data"]["id"].toString();
    //     print(message);
    //     break;

    //   // ** ========================== **
    //   // ** CODE: 31, EVENT: WebRTC Fail
    //   case 31:
    //     sonar.wsID = message["data"]["id"].toString();
    //     print(message);
    //     break;

    //   // ** ========================== **
    //   // ** CODE: 32, EVENT: WebRTC Done
    //   case 32:
    //     sonar.wsID = message["data"]["id"].toString();
    //     print(message);
    //     break;

    //   // ** ========================== **
    //   // ** CODE: 40, EVENT: Cancel
    //   case 40:
    //     sonar.wsID = message["data"]["id"].toString();
    //     print(message);
    //     break;

    //   // ** ========================== **
    //   // ** CODE: 41, EVENT: Timeout
    //   case 41:
    //     sonar.wsID = message["data"]["id"].toString();
    //     print(message);
    //     break;

    //   // ** ========================== **
    //   // ** CODE: 43, EVENT: WebRTC Establishment Failed
    //   case 43:
    //     sonar.wsID = message["data"]["id"].toString();
    //     print(message);
    //     break;

    //   // ** ========================== **
    //   // ** CODE: 44, EVENT: Server Down/Maintenance
    //   case 44:
    //     sonar.wsID = message["data"]["id"].toString();
    //     print(message);
    //     break;

    //   // ** ========================== **
    //   // ** CODE: 50, EVENT: Authorization Successful
    //   case 50:
    //     sonar.wsID = message["data"]["id"].toString();
    //     print(message);
    //     break;

    //   // ** ========================== **
    //   // ** CODE: 51, EVENT: Authorization Pending
    //   case 51:
    //     sonar.wsID = message["data"]["id"].toString();
    //     print(message);
    //     break;

    //   // ** ========================== **
    //   // ** CODE: 52, EVENT: Authorization Fail
    //   case 52:
    //     sonar.wsID = message["data"]["id"].toString();
    //     print(message);
    //     break;

      // ** ============================ **
      // ** Other Messages: Dispatch to Listeners.
      // default:
      //   _listeners.forEach((Function callback) {
      //     print(message);
      //     callback(message);
      //   });
      //   break;
   // }
  }

  // Closes Communication with Websocket
  close() {
    sonarWS.reset();
  }
}
