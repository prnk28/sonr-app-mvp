import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sonar_app/core/core.dart';

class Message extends Equatable {
// *******************
  // ** JSON Values **
  // *******************
  // From JSON
  final String message;
  final SonarStage stage;
  final int code;
  final Map data;
  final IncomingMessageDataType type;

  // *********************
  // ** Constructor Var **
  // *********************
  const Message(
    this.code,
    this.stage,
    this.message,  
    this.type, {
    this.data,
  });

  // **************************
  // ** Class Implementation **
  // **************************
  @override
  List<Object> get props => [
        code,
        stage,
        message,
        type,
        data
      ];

  @override
  String toString() {
    return '{ ${this.code}, ${this.stage}, ${this.message}, ${this.type}, ${this.data}}';
  }

  // ***********************
  // ** Object Generation **
  // ***********************
  // Create Incoming Message from Server
  factory Message.incoming(dynamic serverMessage) {
    // Init Json
    var json = jsonDecode(serverMessage);
    
    // Return Message
    return Message(
     json["code"] as int,
     getSonarStageFromString(json["stage"]),
     json["message"] as String,
     getDataTypeFromString(json["type"]),
     data: json["data"]);
  }

  // Create Outgoing Message to Server
  static String outgoing(OutgoingMessageAction actionType, {Map givenData}) {
    // Construct JSON Map
    var map = {"action": getShortMessageAction(actionType), "data": givenData};

    // Convert and Return Object
    return jsonEncode(map);
  }
}
