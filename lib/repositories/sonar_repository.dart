// Remote Packages
import 'dart:convert';

// Local Classes
import 'package:sonar_app/controllers/controllers.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/data/data.dart';

// Constant Sonar Domain
const String SERVER_ADDRESS = "ws://match.sonr.io";
class SonarRepository {
  // **************************
  // ** Class Initialization **
  // **************************
  // Websockets Sonar Object
  static final Websockets sonarWS = new Websockets("ws://match.sonr.io");
  
  // Initialize
  SonarRepository._internal(){
    sonarWS.connect();
  }
  
  // Constructer
  factory SonarRepository() {
    SonarRepository _wsClient = new SonarRepository._internal();
    return _wsClient;
  }

  // *******************************
  // ** WebSockets Server Actions **
  // *******************************
  // Connect to Server, Join/Create Lobby
  initializeSonar(Location currentLocation, Client currentClient) {
    // Set Data
    var data = {
      'profile': currentClient.user.toJSON(),
      'location': currentLocation.toJSON()
    };

    // Action: JOIN To Server
    sonarWS.send(jsonEncode({'action': "JOIN", 'data': data}));
  }

  // Authorize Match
  setAuthorize(bool authStatus, Client currentClient, Match potentialMatch) {
    // Send msg based on bool
    if (authStatus) {
      // Action: AUTHORIZE.TRUE To Server
      sonarWS.send(jsonEncode({'action': "AUTHORIZE.TRUE"}));
    } else {
      // Action: AUTHORIZE.FALSE To Server
      sonarWS.send(jsonEncode({'action': "AUTHORIZE.FALSE"}));
    }
  }

  // Client Sending Mode
  setSending(Direction currentDirection) {
    // Action: SEND To Server
    var data = {'direction': currentDirection.toJSON()};
    print(jsonEncode({'action': "SEND", 'data': data}));
    sonarWS.send(jsonEncode({'action': "SEND", 'data': data}));
  }

  // Client Receiving Mode
  setReceiving(Direction currentDirection) {
    // Action: RECEIVE To Server
    var data = {'direction': currentDirection.toJSON()};
    sonarWS.send(jsonEncode({'action': "RECEIVE", 'data': data}));
  }

  // User Selected Match or Auto-Matched
  setSelect(Match potentialMatch){

  }

  // Begin Transfer between Client and Match
  setTransfer(Client currentClient, Match currentMatch){

  }

  // Transfer has Finished
  completeTransfer(Process sonarProcess){

  }

  // Cancel Sequence
  cancelSonar(Client currentClient, Process sonarProcess){

  }

  // Reset Sonar Client
  reset(Client currentClient, Process sonarProcess){

  }
}
