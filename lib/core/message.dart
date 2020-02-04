import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';

class Message extends Equatable {
// *******************
  // ** JSON Values **
  // *******************
  // From JSON
  final String message;
  final int code;
  final Map data;
  final IncomingMessageDataType type;

  // Interpreted Values
  final DateTime received;

  // *********************
  // ** Constructor Var **
  // *********************
  const Message(
    this.message,
    this.code,
    this.type, {
    this.data,
    this.received,
  });

  // **************************
  // ** Class Implementation **
  // **************************
  @override
  List<Object> get props => [
        message,
        code,
        type,
        received,
      ];

  // ***********************
  // ** Object Generation **
  // ***********************
  // Create Incoming Message from Server
  static Message incoming(dynamic json) {
    return Message(json["message"], json["code"],
        getMessageDataTypeFromString(json["type"]),
        data: json["data"], received: DateTime.now());
  }

  // Create Outgoing Message to Server
  static String outgoing(OutgoingMessageAction actionType, {Map givenData}) {
    // Construct JSON Map
    var map = {"action": actionType.toString(), "data": givenData};

    // Convert and Return Object
    return jsonEncode(map);
  }
}
