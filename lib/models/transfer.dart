// Dependencies
import 'package:flutter/material.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/data/data.dart';
import 'package:sonar_app/models/models.dart';

// Packages
import 'package:equatable/equatable.dart';

class Transfer extends Equatable {
// *******************
  // ** JSON Values **
  // *******************
  // From JSON
  final String id;
  //final FileType fileType;

  // *********************
  // ** Constructor Var **
  // *********************
  // Required Properties
  final Lobby lobby;
  final Client sender;
  final Client receiver;

  // Constructer
  const Transfer(this.lobby, this.sender, this.receiver,
      {this.id});

  // **************************
  // ** Class Implementation **
  // **************************
  @override
  List<Object> get props => [
        lobby, sender, receiver, id
      ];

  // ***********************
  // ** Object Generation **
  // ***********************
  // Create Object from Events
  static Transfer update(Transfer previousTransfer, dynamic json) {
    return Transfer(previousTransfer.lobby, previousTransfer.sender,
        previousTransfer.receiver,
        id: json["id"],
        // fileType: getFileTypeFromString(json["file_type"]),
        );
  }

  // Create Object from Events
  static Transfer create(Lobby lobby, Client sender, Client receiver) {
    return Transfer(lobby, sender, receiver);
  }


  // *********************
  // ** JSON Conversion **
  // *********************
  toMap() {
    return {
      // Properties
      'lobbyId': lobby.id,
      'senderId': sender.id,
      'receiverId': receiver.id,
    };
  }
}
