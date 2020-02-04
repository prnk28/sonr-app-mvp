// Local Classes
import 'package:sonar_app/controllers/controllers.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/data/data.dart';
import 'package:sonar_app/models/models.dart';

// Constant Sonar Domain
const String SERVER_ADDRESS = "ws://match.sonr.io";

class SonarRepository {
  // **************************
  // ** Class Initialization **
  // **************************
  // Websockets Sonar Object
  static final Websockets sonarWS = new Websockets("ws://match.sonr.io");

  // Initialize
  SonarRepository._internal() {
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
  initializeSonar(Location location, Profile profile) {
    // Create Message
    var message = Message.outgoing(OutgoingMessageAction.Initialize, givenData: {
      "location": location.toMap(),
      "profile": profile.toMap()
    });
    print(message);

    // Action: JOIN To Server
    sonarWS.send(message);
  }


  // Client Sending Mode
  setSending(Direction currentDirection) {
    // Create Message
    var message = Message.outgoing(OutgoingMessageAction.Sending, givenData: {
      "direction": currentDirection.toMap(),
    });

    // Action: JOIN To Server
    sonarWS.send(message);
  }

  // Client Receiving Mode
  setReceiving(Direction currentDirection) {
    // Create Message
    var message = Message.outgoing(OutgoingMessageAction.Receiving, givenData: {
      "direction": currentDirection.toMap(),
    });

    // Action: JOIN To Server
    sonarWS.send(message);
  }

  // User Selected Match or Auto-Matched
  setSelect(Client potentialMatch) {
    // Create Message
    var message = Message.outgoing(OutgoingMessageAction.Select, givenData: {
      "match": potentialMatch.toMap(),
    });

    // Action: Select To Server
    sonarWS.send(message);
  }

  // Authorize Match
  requestAuthorization(Client potentialMatch) {
    // Create Message
    var message = Message.outgoing(OutgoingMessageAction.Request, givenData: {
      "match": potentialMatch.toMap()
    });

    // Action: Authorize To Server
    sonarWS.send(message);
  }

  // Begin Transfer between Client and Match
  startTransfer(Client currentClient, Client currentMatch) {
    // Create Message
    var message = Message.outgoing(OutgoingMessageAction.Transfer, givenData: {
      "sender": currentClient.toMap(),
      "receiver": currentMatch.toMap()
    });

    // Action: JOIN To Server
    sonarWS.send(message);
  }

  // Transfer has Finished
  completeTransfer(Process sonarProcess) {}

  // Cancel Sequence
  cancelSonar(Client currentClient, Process sonarProcess) {}

  // Reset Sonar Client
  reset(Client currentClient, Process sonarProcess) {}
}
