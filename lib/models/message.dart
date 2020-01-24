import 'package:equatable/equatable.dart';
import 'package:sonar_app/models/models.dart';

enum MessageCategory {
  Initialization,
  Lobby,
  Position,
  Sender,
  Receiver,
  WebRTC,
  Error,
  Authorization,
}

class Message extends Equatable {
// *******************
  // ** JSON Values **
  // *******************
  // From JSON
  final int code;
  final String message;
  final String clientId;
  final Lobby lobby;

  // Interpreted Values
  final MessageCategory category;
  final DateTime received;

  // *********************
  // ** Constructor Var **
  // *********************
  const Message({
    this.code,
    this.message,
    this.clientId,
    this.category,
    this.received,
    this.lobby
  });

  // **************************
  // ** Class Implementation **
  // **************************
  @override
  List<Object> get props => [
        code,
        message,
        clientId,
        category,
        received,
        lobby
      ];

  // ***********************
  // ** Object Generation **
  // ***********************
  // Create Object from Events
  static Message fromJSON(dynamic json) {
// Return Object
      return Message(
          code: json["code"],
          message: json["data"]["message"],
          clientId: json["data"]["id"],
          category: _getCategoryFromCode(json["code"]),
          lobby: Lobby.fromJSON(json["data"]["lobby"]),
          received: DateTime.now());
  }

  static MessageCategory _getCategoryFromCode(int code){
      //TODO: Add This
      return MessageCategory.Initialization;
  }
}
